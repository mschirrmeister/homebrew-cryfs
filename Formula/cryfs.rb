class Cryfs < Formula
  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/0.10.2/cryfs-0.10.2.tar.xz"
  sha256 "5531351b67ea23f849b71a1bc44474015c5718d1acce039cf101d321b27f03d5"
  license "LGPL-3.0"
  # revision 1

  bottle do
    root_url "https://github.com/mschirrmeister/homebrew-cryfs/releases/download/0.10.2"
    cellar :any
    sha256 "b794a11cb00237d2a3cf0f62eb9445ac556cfe5bd3558b933cc0df7a0e5c5516" => :big_sur
    # rebuild 1
  end

  head do
    url "https://github.com/cryfs/cryfs.git", branch: "develop", shallow: false
  end

  # deprecate! date: "2020-11-10", because: "requires FUSE"

  depends_on macos: :big_sur
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libomp"
  depends_on "openssl@1.1"

  # Dependencies on a cask are not officially supported and do not work
  # depends_on :macfuse if MacOS.version >= :big_sur
  # depends_on :macfuse => "4.0.4"
  # This will work that the formula itself does not give an error, but since it is actually a cask, you will get an error during install
  # depends_on "mschirrmeister/cryfs/mschirrmeister-macfuse" if MacOS.version >= :big_sur

  patch do
    url "https://raw.githubusercontent.com/mschirrmeister/homebrew-cryfs/main/Patch/params.patch"
    sha256 "03bc6d7fc229c3c96d352e7b6a1c65e18aefe6407bb971eb4192fab77ee025a0"
  end

  patch do
    url "https://raw.githubusercontent.com/mschirrmeister/homebrew-cryfs/main/Patch/cmakelists.patch"
    sha256 "e8442cceef26719a15b78b1a9cf97b8fc2caeec3b793430fccb344f4b2ccaf26"
  end

  def install
    configure_args = [
      "-DBUILD_TESTING=off",
    ]

    if build.head?
      libomp = Formula["libomp"]
      configure_args.concat(
        [
          "-DOpenMP_CXX_FLAGS='-Xpreprocessor -fopenmp -I#{libomp.include}'",
          "-DOpenMP_CXX_LIB_NAMES=omp",
          "-DOpenMP_omp_LIBRARY=#{libomp.lib}/libomp.dylib",
        ],
      )
    end

    system "cmake", ".", *configure_args, *std_cmake_args
    system "make", "install"
  end

  def caveats; <<~EOS
    CryFS needs FUSE and macOS Big Sur requires macFUSE 4.0.0+.
    With the switch to version 4 the library and framework has been renamed to 'macFUSE'.
    Either install macFUSE manually from https://osxfuse.github.io/ or via homebrew from custom tap.

        brew tap mschirrmeister/cryfs
        brew install --cask mschirrmeister-macfuse

  EOS
  end

  test do
    ENV["CRYFS_FRONTEND"] = "noninteractive"

    # Test showing help page
    assert_match "CryFS", shell_output("#{bin}/cryfs 2>&1", 10)

    # Test mounting a filesystem. This command will ultimately fail because homebrew tests
    # don't have the required permissions to mount fuse filesystems, but before that
    # it should display "Mounting filesystem". If that doesn't happen, there's something
    # wrong. For example there was an ABI incompatibility issue between the crypto++ version
    # the cryfs bottle was compiled with and the crypto++ library installed by homebrew to.
    mkdir "basedir"
    mkdir "mountdir"
    assert_match "Operation not permitted", pipe_output("#{bin}/cryfs -f basedir mountdir 2>&1", "password")
  end
end
