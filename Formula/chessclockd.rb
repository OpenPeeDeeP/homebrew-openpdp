class Chessclockd < Formula
  desc "is a daemon for keeping up with how long tasks take"
  homepage "https://github.com/OpenPeeDeeP/ChessClock-Daemon"
  url "https://github.com/OpenPeeDeeP/ChessClock-Daemon.git",
    :tag => "v0.1.1"
  head "https://github.com/OpenPeeDeeP/ChessClock-Daemon.git"

  depends_on "go" => :build
  depends_on "dep" => :build

  def install
    ENV["GOPATH"] = buildpath
    bin_path = buildpath/"src/github.com/OpenPeeDeeP/ChessClock-Daemon"
    bin_path.install Dir["*"]
    cd bin_path do
      system "dep", "ensure"
      ldflags = "-s -w -X main.version=#{version}"
      system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/chessclockd", "."
    end
  end

  plist_options :manual => "chessclockd"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/chessclockd</string>
        </array>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
    EOS
  end

  test do
    daemon = fork do
      exec bin/"chessclockd"
    end
    sleep 0.5
    Process.kill("TERM", daemon)
  end
end
