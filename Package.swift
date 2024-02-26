// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let release = "1.2"

let frameworks = ["ffmpegkit": "bccd8f442c4a1acfbfce2e1696bc6e41e23186bdee22a54cb1dc1124cddbfa6b", "libavcodec": "e29613341d8f09ef25fbf864f3a879a79ffa6709d693d1bd46f2ae8c5122cebe", "libavdevice": "d8ccd72b33d8a9ce99c7d6d0b0ffb682d1dd4fee14dd53d9dcb1c2bc19958df3", "libavfilter": "be77157cdbf2458e53eb61312470889f75939c087be2e906bce457a8b121a076", "libavformat": "92be6c8b645b819337f127971493267184f364c38afd2a1f8af15d5de50bb97a", "libavutil": "ddc5178024a79013f60473c2e8f5ff79ea3333a1713f54d3d19f591b981a093b", "libswresample": "def08299595eaf998ef8096a1e9287d9f56ae94558ed05fd8b9429e0f21b14b6", "libswscale": "321925010b76d2940548273f87adcbb95dd5dba75401f50835d9e76b75b29480"]

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
