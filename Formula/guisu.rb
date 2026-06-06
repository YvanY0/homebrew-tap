class Guisu < Formula
  desc "CLI for guisu dotfile manager"
  homepage "https://github.com/YvanY0/guisu"
  version "0.2.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/YvanY0/guisu/releases/download/v0.2.1/guisu-cli-aarch64-apple-darwin.tar.xz"
    sha256 "6d06b56b04630d4aecab19f731703509497aa96901736efd203bd4cbdfbd94d8"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/YvanY0/guisu/releases/download/v0.2.1/guisu-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "152cf9ebb4b77da0f3bfc2cb2654c593461f305bcec9c17f327670e3b6fab76b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/YvanY0/guisu/releases/download/v0.2.1/guisu-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "85c81c48caaab0748b0b39abc0cb286cd725641a9ca18bf5cd948684fad117ce"
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
