# Written by tools/update.py from stemma-math/stemma-exedra v0.2.0: do not edit.
class Stemma < Formula
  desc "Collaborative platform for humans and agents doing mathematics"
  homepage "https://github.com/stemma-math/stemma-exedra"
  version "0.2.0"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
    on_arm do
      url "https://github.com/stemma-math/stemma-exedra/releases/download/v0.2.0/stemma-0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "4973effbd755200174325146886d5dbb643291a56ba0ce08079c9ba83b8d3168"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    on_intel do
      url "https://github.com/stemma-math/stemma-exedra/releases/download/v0.2.0/stemma-0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f6c0c33add84cc11103785a0f55f01cb20b5764c2f8798eb801d41e54c9398b1"
    end
  end

  conflicts_with "stemma-signum", because: "both install a `stemma` binary"

  def install
    bin.install "stemma"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stemma --version")
  end
end
