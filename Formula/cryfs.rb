class Cryfs < Formula
  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/0.10.2/cryfs-0.10.2.tar.xz"
  sha256 "5531351b67ea23f849b71a1bc44474015c5718d1acce039cf101d321b27f03d5"
  license "LGPL-3.0"
  revison 2

  # bottle do
  #   cellar :any
  #   rebuild 2
  #   # sha256 "3a5986dc3775877188cbf4442bd72c6f20ffe1d384fefebac8041c0d8f9ff09b" => :catalina
  #   sha256 "xxx" => :big_sur
  # end

  head do
    url "https://github.com/cryfs/cryfs.git", branch: "develop", shallow: false
  end

  # deprecate! date: "2020-11-10", because: "requires FUSE"

  depends_on macos: :big_sur
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libomp"
  depends_on "openssl@1.1"
  depends_on :macfuse if MacOS.version >= :big_sur

  patch do
    url "https://https://github.com/mschirrmeister/homebrew-cryfs/Patch/params.patch"
    sha256 "ea8d27109e912a0ce3a807bfb1a8eddfe71ab521bfc21648948581cd9d115cb6"
  end

  patch do
    url "https://https://github.com/mschirrmeister/homebrew-cryfs/Patch/cmakelists.patch"
    sha256 "4a5041e5a4c5428476c7ccf3b3591c3255c773364fe7f58ae4f412408f850f8c"
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
