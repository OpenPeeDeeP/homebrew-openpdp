class Chessclock < Formula
  desc "is a cli for keeping up with how long tasks take"
  homepage "https://github.com/OpenPeeDeeP/ChessClock-CLI"
  url "https://github.com/OpenPeeDeeP/ChessClock-CLI.git",
    :tag => "v0.1.2"
  head "https://github.com/OpenPeeDeeP/ChessClock-CLI.git"

  depends_on "go" => :build
  depends_on "dep" => :build
  depends_on "OpenPeeDeeP/openpdp/chessclockd" => :run

  def install
    ENV["GOPATH"] = buildpath
    bin_path = buildpath/"src/github.com/OpenPeeDeeP/ChessClock-CLI"
    bin_path.install Dir["*"]
    cd bin_path do
      system "dep", "ensure"
      ldflags = "-s -w -X main.version=#{version}"
      system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/clock", "."
    end
  end

  test do
    system bin/"clock", "help"
  end
end
