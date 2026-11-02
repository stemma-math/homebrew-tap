# Written by tools/update.py from stemma-math/stemma-exedra v0.3.1: do not edit.
class Stemma < Formula
  desc "Collaborative platform for humans and agents doing mathematics"
  homepage "https://github.com/stemma-math/stemma-exedra"
  version "0.3.1"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
    on_arm do
      url "https://github.com/stemma-math/stemma-exedra/releases/download/v0.3.1/stemma-0.3.1-aarch64-apple-darwin.tar.gz"
      sha256 "30e1874325d2bff32b453780cf2f50e52be7b6f2eba332ea70b1bb980f151bdc"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    on_intel do
      url "https://github.com/stemma-math/stemma-exedra/releases/download/v0.3.1/stemma-0.3.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bc2a3baf0ef0ce31f0bea4d69550aceaf7a1af7249862bcf7417efd4658d15f4"
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
