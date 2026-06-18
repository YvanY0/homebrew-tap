class Guisu < Formula
  desc "CLI for guisu dotfile manager"
  homepage "https://github.com/YvanY0/guisu"
  version "0.2.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/YvanY0/guisu/releases/download/v0.2.3/guisu-aarch64-apple-darwin.tar.xz"
    sha256 "810b02b58f280d53146b4ddd176f7654e437c7b4175ce2038064b7263d5d8d0e"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/YvanY0/guisu/releases/download/v0.2.3/guisu-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "adf922a674c46059b71b58eac63a22a2942521d4de988c6e55b235df05f2eea1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/YvanY0/guisu/releases/download/v0.2.3/guisu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "51c365a98ec5111eb1d829f80930d4a8899de0e24a97014982881dd830211089"
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
