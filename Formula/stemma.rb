# Written by tools/update.py from stemma-math/stemma-exedra v0.1.1: do not edit.
class Stemma < Formula
  desc "Collaborative platform for humans and agents doing mathematics"
  homepage "https://github.com/stemma-math/stemma-exedra"
  version "0.1.1"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
    on_arm do
      url "https://github.com/stemma-math/stemma-exedra/releases/download/v0.1.1/stemma-0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "750db90918c453f38e7ed3d5c69215aa8499e31ad9172a6c0d228f55599a73d0"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    on_intel do
      url "https://github.com/stemma-math/stemma-exedra/releases/download/v0.1.1/stemma-0.1.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f16dce3ce9cee3c157442abfea2de2f7cb96362469395bc57b38828aa0179d04"
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
