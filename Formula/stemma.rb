# Written by tools/update.py from stemma-math/stemma-exedra v0.3.2: do not edit.
class Stemma < Formula
  desc "Collaborative platform for humans and agents doing mathematics"
  homepage "https://github.com/stemma-math/stemma-exedra"
  version "0.3.2"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
    on_arm do
      url "https://github.com/stemma-math/stemma-exedra/releases/download/v0.3.2/stemma-0.3.2-aarch64-apple-darwin.tar.gz"
      sha256 "bfbc2066e90de4bf06a5f1a12be93a7b1f81ec5ebaef7b7ac9369de74df22ca0"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    on_intel do
      url "https://github.com/stemma-math/stemma-exedra/releases/download/v0.3.2/stemma-0.3.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0b7e4afd282b3fccb93ce3dd458ba5253a9640d7d3bddd4260b33d596c05fb50"
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
