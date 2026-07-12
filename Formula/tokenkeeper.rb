class Tokenkeeper < Formula
  desc "Read-only metadata auditor for AI-agent credentials and configuration"
  homepage "https://github.com/SoundBlaster/tokenkeeper"
  url "https://github.com/SoundBlaster/tokenkeeper/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "2f76f4b19cb57bb1088461e12a2cc66f6a3300fc36875f706d23bb53c5264b96"
  license "MIT"

  depends_on "rust" => :build

  def install
    # macOS beta releases can reject the Homebrew rustc code signature while
    # a rustup-managed toolchain remains valid. Prefer it when available, but
    # keep clean Homebrew builders self-contained.
    rustup = which("rustup")
    rustup ||= Pathname(Dir["/Users/*/.cargo/bin/rustup"].first) if Dir["/Users/*/.cargo/bin/rustup"].any?
    rustup ||= Pathname(Dir.home) / ".cargo/bin/rustup"
    if rustup.exist?
      rustup_user_home = rustup.dirname.parent.parent
      ENV["RUSTUP_HOME"] = (rustup_user_home / ".rustup").to_s
      ENV["CARGO_HOME"] = (rustup_user_home / ".cargo").to_s
      ENV.delete("RUSTC_WRAPPER")
      if system(rustup.to_s, "run", "stable", "rustc", "-vV")
        toolchain_rustc = Utils.safe_popen_read(rustup.to_s, "which", "rustc").chomp
        toolchain_cargo = Utils.safe_popen_read(rustup.to_s, "which", "cargo").chomp
        with_env(
          "CARGO_BUILD_RUSTC" => toolchain_rustc,
          "RUSTC_WRAPPER" => "",
          "PATH" => "#{Pathname(toolchain_rustc).dirname}:#{ENV["PATH"]}"
        ) do
          system toolchain_cargo, "install", "--locked", "--root", prefix, "--path", "."
        end
      else
        system "cargo", "install", "--locked", "--root", prefix, "--path", "."
      end
    else
      system "cargo", "install", "--locked", "--root", prefix, "--path", "."
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tokenkeeper --version")
    assert_match "codex", shell_output("#{bin}/tokenkeeper profiles")
  end
end
