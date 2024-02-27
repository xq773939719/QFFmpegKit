// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let release = "1.2"

let frameworks = ["ffmpegkit": "c1b0965a3de210dbb2e8458026ce8acab9e26007c51bb0dd67e9d96788c9bc2a", "libavcodec": "7af47d135bed97816b8124d68837f2aa3e03725f44b0e59e3c7d6b0e2ecfcaa6", "libavdevice": "539c7a9ca98031b75d23ea21e0041163ea3ca0d979f0d1917cb4c4d0714a89f1", "libavfilter": "01370bc9e8489a7236f98f50b08012f02a4c536819d63ee6bd77f8ae2ec7b541", "libavformat": "b879d982d413e3215ea864c495afcf270e1e07ca4c79b3c5180d60111422383b", "libavutil": "0c883f39e33961796dd14ad1f6d74ca0d8828153d273b890f63fc45f6e75b0c7", "libswresample": "e8d4edac1cdba6380a2c90579d83dce075ce2610becb8afc46f3f5c74dc29850", "libswscale": "ed1fd5d0f6f9a39ee3a664cd4bfb98c675dffc369f0ca8e89883ff3cfaa75fcf"]

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
