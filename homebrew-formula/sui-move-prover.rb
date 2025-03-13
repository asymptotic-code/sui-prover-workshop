class SuiMoveProver < Formula
  desc "Sui Prover - a tool for verifying Move smart contracts on the Sui blockchain"
  homepage "https://github.com/asymptotic-code/sui"
  license "Apache-2.0"

  stable do
    depends_on "dotnet@8"
    url "https://github.com/asymptotic-code/sui.git", branch: "next"
    version "0.1.2"
    resource "boogie" do
      url "https://github.com/boogie-org/boogie.git", branch: "master"
    end
  end

  #bottle do
  #  root_url "https://github.com/andrii-a8c/homebrew-test-sui-move-prover/releases/download/sui-move-prover-0.1.2"
  #  sha256 cellar: :any_skip_relocation, arm64_sequoia: "73e8e45221110830255b36dc4b13ff12c2b06b5512ab20982c981ba71bb5c776"
  #  sha256 cellar: :any_skip_relocation, ventura:       "715f238d55c0341e77246ea9299a536c68a75bc11915357c560b89af45df3317"
  #  sha256 cellar: :any_skip_relocation, x86_64_linux:  "505230897e2f20c796221d98d5be7cf1b9db7aef480e66d894c5a792c81249d1"
  #end

  head "https://github.com/asymptotic-code/sui.git", branch: "next" do
    depends_on "dotnet@8"
    resource "boogie" do
      url "https://github.com/boogie-org/boogie.git", branch: "master"
    end
  end

  depends_on "rust" => :build
  depends_on "z3"

  def install
    system "cargo", "install", "--locked", "--path", "./crates/sui-move", "--features", "all"
    # system "cargo", "build", "--release", "--features", "build", "--package", "sui-move"

    libexec.install "target/release/sui-move"

    ENV.prepend_path "PATH", Formula["dotnet@8"].opt_bin
    ENV["DOTNET_ROOT"] = Formula["dotnet@8"].opt_libexec

    resource("boogie").stage do
      system "dotnet", "build", "Source/Boogie.sln", "-c", "Release"
      libexec.install Dir["Source/BoogieDriver/bin/Release/net8.0/*"]
      bin.install_symlink libexec/"BoogieDriver" => "boogie"
    end

    (bin/"sui-move").write_env_script libexec/"sui-move", {
      DOTNET_ROOT: Formula["dotnet@8"].opt_libexec,
      BOOGIE_EXE:  bin/"boogie",
      Z3_EXE:      Formula["z3"].opt_bin/"z3",
    }
  end

  def caveats
    <<~EOS
      The formal verification toolchain has been installed.
    EOS
  end

  test do
    system "z3", "--version"
    system "#{bin}/sui-move", "--version"
  end
end
