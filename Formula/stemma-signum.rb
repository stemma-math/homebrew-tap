# Written by tools/update.py from stemma-math/stemma-signum v0.5.2: do not edit.
class StemmaSignum < Formula
  desc "Standard, and a command-line that implements it, for doing mathematics"
  homepage "https://github.com/stemma-math/stemma-signum"
  version "0.5.2"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
    on_arm do
      url "https://github.com/stemma-math/stemma-signum/releases/download/v0.5.2/stemma-0.5.2-aarch64-apple-darwin.tar.gz"
      sha256 "a47cffdf214400fd30d01cd8bea68292394610512fc5bdf96510d87a7abbdd0b"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    on_intel do
      url "https://github.com/stemma-math/stemma-signum/releases/download/v0.5.2/stemma-0.5.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1a311094c0f404013965c1fbf042d5c415f2d058af1d8b8768b23e80db478c1f"
    end
  end

  conflicts_with "stemma", because: "both install a `stemma` binary"

  def install
    bin.install "stemma"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stemma --version")
  end
end
