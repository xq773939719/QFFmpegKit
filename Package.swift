// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let release = "1.4"

let frameworks = ["ffmpegkit": "c05a603639e4ffc0ec65b6c7c747201fc66f4a1d0c6ec9c135c78d5c6749ede1", "libavcodec": "9f4cd70fb6962b6f4c0617c904487ca3b36f7300d1953a9cf32b3360490e0908", "libavdevice": "6b5021c98cdc93f5ea9837317c3c49ca35d4d5347a178e25512b4b105d467923", "libavfilter": "078f97121f7eebf665a5352db24fbdd8e76f836387141cb98e1ad5e2ca097524", "libavformat": "b1432dfc2f54c149c540e8d2a49ee45d8160f0136212b9d390cf5f1e79c20900", "libavutil": "9e5111f265ab4e903b3c73f9bd14204586ea5e6d4e64797ddab08c7ffad888e6", "libswresample": "b1928b7dba9bd83fd76a67ffda077c423f52f8134142647ced17ffb6e9dc23dc", "libswscale": "b2964cf51c0419b26c79775d38cfd43feeee9dbfda9607edd9f595185ce918b0"]

func xcframework(_ package: Dictionary<String, String>.Element) -> Target {
    let url = "https://github.com/xq773939719/QFFmpegKit/releases/download/\(release)/\(package.key).xcframework.zip"
    return .binaryTarget(name: package.key, url: url, checksum: package.value)
}

let linkerSettings: [LinkerSetting] = [
    .linkedFramework("AudioToolbox", .when(platforms: [.macOS, .iOS, .macCatalyst, .tvOS])),
    .linkedFramework("AVFoundation", .when(platforms: [.macOS, .iOS, .macCatalyst])),
    .linkedFramework("CoreMedia", .when(platforms: [.macOS])),
    .linkedFramework("OpenGL", .when(platforms: [.macOS])),
    .linkedFramework("VideoToolbox", .when(platforms: [.macOS, .iOS, .macCatalyst, .tvOS])),
    .linkedLibrary("z"),
    .linkedLibrary("lzma"),
    .linkedLibrary("bz2"),
    .linkedLibrary("iconv")
]

let libs = frameworks.filter({ $0.key != "ffmpegkit" })

let package = Package(
    name: "QFFmpegKit",
    platforms: [.iOS(.v12), .macOS(.v10_15), .tvOS(.v11), .watchOS(.v7)],
    products: [
        .library(
            name: "FFmpeg-Kit",
            type: .dynamic,
            targets: ["FFmpeg-Kit", "ffmpegkit"]),
    ] + libs.map { .library(name: $0.key, targets: [$0.key]) },
    dependencies: [],
    targets: [
        .target(
            name: "FFmpeg-Kit",
            dependencies: frameworks.map { .byName(name: $0.key) },
            linkerSettings: linkerSettings),
    ] + frameworks.map { xcframework($0) }
)
