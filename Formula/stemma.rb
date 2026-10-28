# Written by tools/update.py from stemma-math/stemma-exedra v0.2.1: do not edit.
class Stemma < Formula
  desc "Collaborative platform for humans and agents doing mathematics"
  homepage "https://github.com/stemma-math/stemma-exedra"
  version "0.2.1"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
    on_arm do
      url "https://github.com/stemma-math/stemma-exedra/releases/download/v0.2.1/stemma-0.2.1-aarch64-apple-darwin.tar.gz"
      sha256 "644e17cd9905466f5e95235871a5fc994641e8dc43bd993b0cbac51f2f2b818f"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    on_intel do
      url "https://github.com/stemma-math/stemma-exedra/releases/download/v0.2.1/stemma-0.2.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0c9776730e77cee0f58e1b492eed2772b88553f12cee5fbbc761a92b5682af1b"
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
