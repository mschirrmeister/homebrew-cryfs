cask "mschirrmeister-macfuse" do
  version "4.0.4"
  sha256 "3e1b52a78ba6530cba2fb34a64c1da2ef969e03aeb2a58ae622cb0f09772d450"

  url "https://github.com/osxfuse/osxfuse/releases/download/macfuse-#{version}/macfuse-#{version}.dmg",
      verified: "github.com/osxfuse/"
  appcast "https://github.com/osxfuse/osxfuse/releases.atom"
  name "macFUSE"
  desc "File system integration"
  homepage "https://osxfuse.github.io/"

  pkg "Extras/macFUSE #{version}.pkg"

  postflight do
    set_ownership ["/usr/local/include", "/usr/local/lib"]
  end

  uninstall pkgutil: [
    "com.github.osxfuse.pkg.Core",
    "com.github.osxfuse.pkg.PrefPane",
  ],
            kext:    "com.github.osxfuse.filesystems.macfuse"

  zap trash: "~/Library/Caches/io.macfuse.preferencepanes.macfuse"

  caveats do
    reboot
  end
end
