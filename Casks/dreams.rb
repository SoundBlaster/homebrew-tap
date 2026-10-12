cask "dreams" do
  version "0.1.5"
  sha256 "6502b0c96cd72944a69ab31192a5b3709bb8159f3b3e1fd83896da6302a3263e"

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
