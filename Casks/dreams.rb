cask "dreams" do
  version "0.1.2"
  sha256 "e68ee2e6d1813ebae0ee35ba3ee1cbb40ec7410b876db8e41a85d4ec5836561d"

  url "https://github.com/SoundBlaster/Dreams/releases/download/v#{version}/Dreams-#{version}.dmg"
  name "Dreams"
  desc "Matrix digital rain that follows Codex and Claude Code agents"
  homepage "https://github.com/SoundBlaster/Dreams"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sequoia

  app "Dreams.app"

  uninstall quit: "ru.egormerkushev.dreams"

  zap trash: [
    "~/Library/Application Support/Dreams",
    "~/Library/Preferences/ru.egormerkushev.dreams.plist",
  ]

  caveats <<~EOS
    Connect Dreams to your agents from its window (Agent hooks), or run:
      "#{appdir}/Dreams.app/Contents/MacOS/Dreams" --install-hooks
    Before uninstalling, remove the hooks the same way with --uninstall-hooks.
  EOS
end
