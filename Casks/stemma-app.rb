# Written by tools/update.py from stemma-math/stemma-exedra v0.2.1: do not edit.
cask "stemma-app" do
  version "0.2.1"
  sha256 "1c168c19f7a29882af8dd77013d80e0089eeacbc06fe133719f1685f5a8d1205"

  url "https://github.com/stemma-math/stemma-exedra/releases/download/v#{version}/stemma-app-#{version}-aarch64-apple-darwin.dmg"
  name "Stemma"
  desc "Desktop app for doing mathematics with people and agents"
  homepage "https://github.com/stemma-math/stemma-exedra"

  depends_on arch: :arm64
  depends_on formula: "stemma-math/tap/stemma"
  depends_on :macos

  app "Stemma.app"

  # Signed ad hoc, not by a developer: macOS would refuse to open it.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Stemma.app"]
  end
end
