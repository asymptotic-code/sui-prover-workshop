class SuiMoveProver < Formula
    desc "Sui Move Prover - a tool for verifying Move smart contracts on the Sui blockchain"
    homepage "https://github.com/asymptotic-code/sui"
    url "https://github.com/asymptotic-code/sui.git", using: :git
    head "https://github.com/asymptotic-code/sui.git", branch: "next"
    version "0.1.0"
    license "Apache-2.0"

    depends_on "rust" => :build
    depends_on "z3"

    head do
      depends_on "dotnet@8"
      resource "boogie" do
        url "https://github.com/boogie-org/boogie.git", branch: "master"
      end
    end

    stable do
      depends_on "dotnet@6"
    end

    def install
      system "cargo", "build", "--release", "--features", "build", "--package", "sui-move"
      libexec.install "target/release/sui-move"

      if build.head?
        ENV.prepend_path "PATH", Formula["dotnet@8"].opt_bin
        ENV["DOTNET_ROOT"] = Formula["dotnet@8"].opt_libexec

        resource("boogie").stage do
          system "dotnet", "build", "Source/Boogie.sln", "-c", "Release"
          libexec.install Dir["Source/BoogieDriver/bin/Release/net8.0/*"]
          bin.install_symlink libexec/"BoogieDriver" => "boogie"
        end

        (bin/"sui-move").write_env_script libexec/"sui-move", {
          :DOTNET_ROOT => Formula["dotnet@8"].opt_libexec,
          :BOOGIE_EXE => bin/"boogie",
          :Z3_EXE => Formula["z3"].opt_bin/"z3",
        }
      else
        ENV.prepend_path "PATH", Formula["dotnet@6"].opt_bin
        ENV["DOTNET_ROOT"] = Formula["dotnet@6"].opt_libexec

        system "dotnet", "tool", "install", "boogie", "--tool-path=#{bin}"

        (bin/"sui-move").write_env_script libexec/"sui-move", {
          :DOTNET_ROOT => Formula["dotnet@6"].opt_libexec,
          :BOOGIE_EXE => bin/"boogie",
          :Z3_EXE => Formula["z3"].opt_bin/"z3",
        }
      end
    end

    def caveats
      <<~EOS
        The formal verification toolchain has been installed.
      EOS
    end

    test do
      system "z3", "--version"
      system "boogie", "-version"
      system "sui-move", "--version"
    end
  end
