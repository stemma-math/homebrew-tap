# Written by tools/update.py from stemma-math/stemma-exedra v0.3.0: do not edit.
class Stemma < Formula
  desc "Collaborative platform for humans and agents doing mathematics"
  homepage "https://github.com/stemma-math/stemma-exedra"
  version "0.3.0"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
    on_arm do
      url "https://github.com/stemma-math/stemma-exedra/releases/download/v0.3.0/stemma-0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "13c853a039323b7db2deea5e36aed90370be95ac6127d4128c5a9c35b8dbaf87"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    on_intel do
      url "https://github.com/stemma-math/stemma-exedra/releases/download/v0.3.0/stemma-0.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "542af318ebf97d72f2a062a48762cdf14e2835798883130126883139bb7cca5f"
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
