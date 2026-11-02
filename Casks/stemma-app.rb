# Written by tools/update.py from stemma-math/stemma-exedra v0.3.1: do not edit.
cask "stemma-app" do
  version "0.3.1"
  sha256 "9ca753b75173a4bb906ecac655cdae331f7c42b031eee9fed693eea34afd0204"

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
