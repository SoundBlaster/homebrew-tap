class ScreenerMcp < Formula
  desc "MCP server that gives coding agents a visual history of app UI"
  homepage "https://github.com/SoundBlaster/Screener"
  url "https://github.com/SoundBlaster/Screener/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "6e40a988b0e3e4eb1a8db1950406fe662cdf3880e1a2217b91e2a0f5bd6a6906"
  license "MIT"

  depends_on xcode: ["16.3", :build]
  # Homebrew's macOS dependency supports major releases; install enforces 15.2.
  depends_on macos: :sequoia

  def install
    macos_version = Version.new(Utils.safe_popen_read("/usr/bin/sw_vers", "-productVersion").strip)
    odie "screener-mcp requires macOS 15.2 or later to build with Xcode 16.3" if macos_version < Version.new("15.2")

    system "swift", "build", "--configuration", "release", "--product", "screener-mcp", "--disable-sandbox"

    build_path = Utils.safe_popen_read("swift", "build", "--configuration", "release", "--show-bin-path").chomp
    bin.install "#{build_path}/screener-mcp"
  end

  test do
    initialize = {
      jsonrpc: "2.0",
      id:      1,
      method:  "initialize",
      params:  {
        protocolVersion: "2025-06-18",
        capabilities:    {},
        clientInfo:      { name: "homebrew-test", version: "1.0" },
      },
    }
    initialized = { jsonrpc: "2.0", method: "notifications/initialized" }
    list_tools = { jsonrpc: "2.0", id: 2, method: "tools/list", params: {} }

    IO.popen("#{bin}/screener-mcp --traces-dir #{testpath}", "r+") do |io|
      io.sync = true
      io.puts JSON.generate(initialize)
      initialize_response = JSON.parse(io.gets)
      assert_equal 1, initialize_response["id"]

      io.puts JSON.generate(initialized)
      io.puts JSON.generate(list_tools)
      tools_response = JSON.parse(io.gets)
      tool_names = tools_response.dig("result", "tools").map { |tool| tool["name"] }

      assert_includes tool_names, "screener.sessions"
      assert_includes tool_names, "screener.contact_sheet"
      io.close_write
    end
  end
end
