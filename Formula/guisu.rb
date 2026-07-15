class Guisu < Formula
  desc "CLI for guisu dotfile manager"
  homepage "https://github.com/YvanY0/guisu"
  version "0.2.6"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/YvanY0/guisu/releases/download/v0.2.6/guisu-aarch64-apple-darwin.tar.xz"
    sha256 "a1efa574cac7f4ab0d19d9456792fd444af2d813808241299bce1d5465578d1f"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/YvanY0/guisu/releases/download/v0.2.6/guisu-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5f8bfc86b3cdf049ab3d230c795e40d34738267fa13bf302ceddd659882dc6d8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/YvanY0/guisu/releases/download/v0.2.6/guisu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "19b625dbace21a57f2f71ceed96997873070a9932660d66f677aadb078e77261"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "guisu" if OS.mac? && Hardware::CPU.arm?
    bin.install "guisu" if OS.linux? && Hardware::CPU.arm?
    bin.install "guisu" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
