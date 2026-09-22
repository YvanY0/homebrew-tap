class Guisu < Formula
  desc "CLI for guisu dotfile manager"
  homepage "https://github.com/YvanY0/guisu"
  version "0.2.11"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/YvanY0/guisu/releases/download/v0.2.11/guisu-aarch64-apple-darwin.tar.xz"
    sha256 "5f3385955eda0d4eaa6a2970de60e69aa10068f2de5487a47b1d8442b7e3d037"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/YvanY0/guisu/releases/download/v0.2.11/guisu-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f2bec7c12e8858fbb15dd0a780d895402a309b30cf63a0f7b4848579ac0c77a5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/YvanY0/guisu/releases/download/v0.2.11/guisu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "20aaaaff0f702f0ef3e1453dbe3fee91d62294db70091523d96331721079f4ca"
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
