// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let release = "1.3"

let frameworks = ["ffmpegkit": "f819cd66d62eea4f9027b4f521715ad69b52c6d30df969e7acf1b09151cc7b00", "libavcodec": "38048ea9ad493bb5889aa4901816a744c469a28bd24e07c9c5b5bede36634449", "libavdevice": "1d98b0752b510c2e5daf4a0f4441b6144d31d466b10f4bf5418c0847acea7d69", "libavfilter": "fad281371c88bc7d47b5751f5a121a0871c53733e216c24baedabb9a328d5b34", "libavformat": "ec01b38d4cb6b1b3acc0c3e7f537ec2152b2b474448d866e5cb69a19c80510ed", "libavutil": "ad987287454870066c481cc63718936734fd0e730eba8483607ed66bacc06079", "libswresample": "bc2678aa71f87fc16691f41dc6d41762e11a0be775e7403d553a93641c709d9f", "libswscale": "0be8978bf13694069adb40aea317d778221f76f6677eb67bccbfe77ed0ceba1c"]

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
