require "language/go"

class Chessclock < Formula
  desc "is a cli for keeping up with how long tasks take"
  homepage "https://github.com/OpenPeeDeeP/ChessClock"
  url "https://github.com/OpenPeeDeeP/ChessClock.git",
    :revision => "cb0531181eff0ee5dcb5acc1ef9314416f07919b"
  version "0.1.0"
  head "https://github.com/OpenPeeDeeP/ChessClock.git"

  depends_on "go" => :build
  depends_on "OpenPeeDeeP/openpdp/chessclockd" => :run

  go_resource "github.com/OpenPeeDeeP/xdg" do
    url "https://github.com/OpenPeeDeeP/xdg.git",
      :revision => "8d747087fa4fbc3b1dcdd531ab65021e01bcecf4"
  end

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
      :revision => "1e59b77b52bf8e4b449a57e6f79f21226d571845"
  end

  go_resource "github.com/ianschenck/envflag" do
    url "https://github.com/ianschenck/envflag.git",
      :revision => "9111d830d133f952887a936367fb0211c3134f0d"
  end

  go_resource "github.com/inconshreveable/mousetrap" do
    url "https://github.com/inconshreveable/mousetrap.git",
      :revision => "76626ae9c91c4f2a10f34cad8ce83ea42c93bb75"
  end

  go_resource "github.com/rs/zerolog" do
    url "https://github.com/rs/zerolog.git",
      :revision => "3ac71fc58dbd43122668a912b755b0979ba9ce1f"
  end

  go_resource "github.com/spf13/cobra" do
    url "https://github.com/spf13/cobra.git",
      :revision => "7b2c5ac9fc04fc5efafb60700713d4fa609b777b"
  end

  go_resource "github.com/spf13/pflag" do
    url "https://github.com/spf13/pflag.git",
      :revision => "e57e3eeb33f795204c1ca35f56c44f83227c6e66"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
      :revision => "9dfe39835686865bff950a07b394c12a98ddc811"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
      :revision => "88f656faf3f37f690df1a32515b479415e1a6769"
  end

  go_resource "google.golang.org/genproto" do
    url "https://github.com/google/go-genproto.git",
      :revision => "891aceb7c239e72692819142dfca057bdcbfcb96"
  end

  go_resource "google.golang.org/grpc" do
    url "https://github.com/grpc/grpc-go.git",
      :revision => "401e0e00e4bb830a10496d64cd95e068c5bf50de"
  end

  def install
    ENV["GOPATH"] = buildpath
    bin_path = buildpath/"src/github.com/OpenPeeDeeP/ChessClock"
    bin_path.install Dir["*"]
    Language::Go.stage_deps resources, buildpath/"src"
    cd bin_path do
      ldflags = "-s -w -X main.version=#{version}"
      system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/cc", "./cmd/cc"
    end
  end

  test do
    system bin/"cc", "help"
  end
end
