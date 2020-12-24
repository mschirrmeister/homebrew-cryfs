cask "macfuse" do
  version "4.0.4"
  sha256 "95ccd44ec552d72c5862bc8cbdc406700c3b3aa70b1151aa34d235d419c99875"

  url "https://github.com/osxfuse/osxfuse/releases/download/macfuse-#{version}/macfuse-#{version}.dmg",
      verified: "github.com/osxfuse/"
  appcast "https://github.com/osxfuse/osxfuse/releases.atom"
  name "MACFUSE"
  desc "File system integration"
  homepage "https://osxfuse.github.io/"

  pkg "Extras/FUSE for macOS #{version}.pkg"

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
