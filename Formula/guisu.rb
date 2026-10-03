class Guisu < Formula
  desc "CLI for guisu dotfile manager"
  homepage "https://github.com/YvanY0/guisu"
  version "0.2.12"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/YvanY0/guisu/releases/download/v0.2.12/guisu-aarch64-apple-darwin.tar.xz"
    sha256 "07bebdc57085da67d626f4de2ecd41a8dfdf7b0862d76d28f17d9369c32f66a0"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/YvanY0/guisu/releases/download/v0.2.12/guisu-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4807f7623bd4485e3f391c439505e97dc903a4cdf5e8ccea55a21943c539ad2c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/YvanY0/guisu/releases/download/v0.2.12/guisu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d37138778f18eb3cbf625535b383820a5562664bb4d53bb9d780acbc5152ea91"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "guisu"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "guisu"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "guisu"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
