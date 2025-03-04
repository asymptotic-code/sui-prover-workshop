class ReviveProver < Formula
    desc "Sui Move Prover - a tool for verifying Move smart contracts on the Sui blockchain"
    homepage "https://github.com/asymptotic-code/sui"
    url "https://github.com/asymptotic-code/sui.git", using: :git, branch: "revive_prover"
    version "0.1.0"
    license "Apache-2.0"

    head "https://github.com/asymptotic-code/sui.git", branch: "revive_prover"

  
    depends_on "rust" => :build
    depends_on "z3"
    depends_on "dotnet@6"

    head do
      resource "boogie" do
        url "https://github.com/boogie-org/boogie.git", tag: "v3.4.3"
      end
    end
  
    def install
      system "cargo", "install", "--features=build", "--locked", "--path", "crates/sui-move", "--root=#{prefix}"
      
      ENV.prepend_path "PATH", Formula["dotnet@6"].opt_bin
      ENV["DOTNET_ROOT"] = Formula["dotnet@6"].opt_libexec

      if build.head?
        resource("boogie").stage do
          system "dotnet", "build", "Source/Boogie.sln", "-c", "Release"
          libexec.install Dir["Source/BoogieDriver/bin/Release/net6.0/*"]
          bin.install_symlink libexec/"BoogieDriver" => "boogie"

          ohai "Boogie was installed into #{libexec}"
        end
      else
        system "dotnet", "tool", "install", "boogie", "--tool-path=#{bin}"
      end
    end
  
    def post_install
      shell_profile = if ENV["SHELL"].include?("zsh")
                        "~/.zshrc"
                      else
                        "~/.bashrc"
                      end


      system "echo 'export DOTNET_ROOT=#{Formula["dotnet@6"].opt_libexec}' >> #{shell_profile}"
      system "echo 'export PATH=$DOTNET_ROOT/bin:$PATH' >> #{shell_profile}"
      system "echo 'export BOOGIE_EXE=#{HOMEBREW_PREFIX}/bin/boogie' >> #{shell_profile}"
      system "echo 'export Z3_EXE=#{HOMEBREW_PREFIX}/bin/z3' >> #{shell_profile}"
    end
  
    test do
      system "dotnet", "--help"
      system "boogie", "-version"
      system "sui-move", "--version"
    end
  end
  