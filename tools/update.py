"""Write each formula and cask from its repository's latest release.

    python3 tools/update.py [package...]

With no packages, every one in `packages.toml`. A package is written only
from what the release holds: its version, its archives and their sums.
"""

import json
import os
import sys
import tomllib
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
API = "https://api.github.com"

# Where each target runs, as Homebrew names it: (system, architecture).
PLATFORMS = {
    "aarch64-apple-darwin": ("macos", "arm"),
    "x86_64-apple-darwin": ("macos", "intel"),
    "aarch64-unknown-linux-gnu": ("linux", "arm"),
    "aarch64-unknown-linux-musl": ("linux", "arm"),
    "x86_64-unknown-linux-gnu": ("linux", "intel"),
    "x86_64-unknown-linux-musl": ("linux", "intel"),
}


def get(url: str) -> bytes:
    request = urllib.request.Request(url)
    if token := os.environ.get("GH_TOKEN"):
        request.add_header("Authorization", f"Bearer {token}")
    with urllib.request.urlopen(request) as response:
        return response.read()


def latest_release(repo: str) -> dict:
    """The newest published release, pre-releases included."""
    releases = json.loads(get(f"{API}/repos/{repo}/releases?per_page=10"))
    for release in releases:
        if not release["draft"]:
            return release
    sys.exit(f"{repo} has no published release")


def archives(name: str, prefix: str, suffix: str, release: dict) -> dict[tuple, tuple]:
    """Each platform's `<prefix>-<version>-<target><suffix>` in the release,
    with its URL and sum."""
    version = release["tag_name"].removeprefix("v")
    assets = {a["name"]: a["browser_download_url"] for a in release["assets"]}
    if "SHA256SUMS" not in assets:
        sys.exit(f"{name}: the release {release['tag_name']} has no SHA256SUMS")
    found = {}
    for line in get(assets["SHA256SUMS"]).decode().splitlines():
        sha256, _, file = line.partition("  ")
        start = f"{prefix}-{version}-"
        if not (file.startswith(start) and file.endswith(suffix)):
            continue
        target = file.removeprefix(start).removesuffix(suffix)
        if target in PLATFORMS and file in assets:
            found[PLATFORMS[target]] = (assets[file], sha256)
    return found


def formula(name: str, package: dict, release: dict) -> str:
    repo, binary = package["repo"], package["binary"]
    version = release["tag_name"].removeprefix("v")
    found = archives(name, binary, ".tar.gz", release)
    if not found:
        sys.exit(f"{name}: the release {release['tag_name']} has no archives")
    klass = "".join(part.capitalize() for part in name.split("-"))

    lines = [
        f"# Written by tools/update.py from {repo} {release['tag_name']}: do not edit.",
        f"class {klass} < Formula",
        f'  desc "{package["desc"]}"',
        f'  homepage "https://github.com/{repo}"',
        f'  version "{version}"',
        f'  license "{package["license"]}"',
    ]
    systems = [system for system in ("macos", "linux") if any(s == system for s, _ in found)]
    if len(systems) == 1:
        lines += ["", f"  depends_on :{systems[0]}"]
    for system in systems:
        arches = [arch for arch in ("arm", "intel") if (system, arch) in found]
        lines += ["", f"  on_{system} do"]
        if len(arches) == 1:
            lines += [f"    depends_on arch: :{'arm64' if arches[0] == 'arm' else 'x86_64'}"]
        for arch in arches:
            url, sha256 = found[(system, arch)]
            lines += [f"    on_{arch} do", f'      url "{url}"', f'      sha256 "{sha256}"', "    end"]
        lines += ["  end"]
    for other in package.get("conflicts", []):
        lines += ["", f'  conflicts_with "{other}", because: "both install a `{binary}` binary"']
    lines += [
        "",
        "  def install",
        f'    bin.install "{binary}"',
        "  end",
        "",
        "  test do",
        f'    assert_match version.to_s, shell_output("#{{bin}}/{binary} --version")',
        "  end",
        "end",
    ]
    return "\n".join(lines) + "\n"


def cask(name: str, package: dict, release: dict) -> str | None:
    """The cask of a macOS app, from its disk image for Apple silicon; or
    nothing, when the release has none."""
    repo, app = package["repo"], package["app"]
    version = release["tag_name"].removeprefix("v")
    found = archives(name, package["asset"], ".dmg", release)
    if ("macos", "arm") not in found:
        return None
    url, sha256 = found[("macos", "arm")]
    lines = [
        f"# Written by tools/update.py from {repo} {release['tag_name']}: do not edit.",
        f'cask "{name}" do',
        f'  version "{version}"',
        f'  sha256 "{sha256}"',
        "",
        f'  url "{url.replace(version, "#{version}")}"',
        f'  name "{package["name"]}"',
        f'  desc "{package["desc"]}"',
        f'  homepage "https://github.com/{repo}"',
        "",
        "  depends_on :macos",
        "  depends_on arch: :arm64",
    ]
    if depends_on := package.get("depends_on"):
        lines += [f'  depends_on formula: "stemma-math/tap/{depends_on}"']
    lines += [
        "",
        f'  app "{app}"',
        "",
        "  # Signed ad hoc, not by a developer: macOS would refuse to open it.",
        "  postflight_steps do",
        f'    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{{{appdir}}}}/{app}"]',
        "  end",
        "end",
    ]
    return "\n".join(lines) + "\n"


def main() -> None:
    packages = tomllib.loads((ROOT / "packages.toml").read_text())
    names = sys.argv[1:] or list(packages)
    for name in names:
        if name not in packages:
            sys.exit(f"{name} is not in packages.toml")
        package = packages[name]
        release = latest_release(package["repo"])
        if "app" in package:
            text = cask(name, package, release)
            if text is None:
                print(f"{name}: {release['tag_name']} has no app for macOS, left as it was")
                continue
            path = ROOT / "Casks" / f"{name}.rb"
        else:
            text = formula(name, package, release)
            path = ROOT / "Formula" / f"{name}.rb"
        path.parent.mkdir(exist_ok=True)
        path.write_text(text)
        print(f"{name} {release['tag_name']}")


if __name__ == "__main__":
    main()
