// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let release = "0.1"

let frameworks = [".DS_Store": "63f5a8a32bc702056497262b729efa578ee096c67070c5f6262c6e640afd33e3", "ffmpegkit": "bf53a74313dda68aa4b6911224189b6c72a42fec1c3995b2db0a4dec5237ef6c", "libavcodec": "6f8c6f76bf3ca3bb5dd8079578c4e060ece63332cdddc1c117ff5988df2d066b", "libavdevice": "c6f65705be6bcca2961e1e5aa3ac855464fdbb1d4296865edd1d48ae99271da8", "libavfilter": "fe58324449c7270ab191c97ee5a076e0ae319dbb3867b6975959c3865f5e29fc", "libavformat": "469696b41f4ad45bd4e7a0b7fe80e4270d3909ac8d346476c129e797016df3c1", "libavutil": "93c8cb117428ba27df6bdac790cfdccf07496b239311367d2a00180fdfa51c3e", "libswresample": "23fd3a655f01ca72849049035a192ae77d6dd3420588c82c9552b6c971cde65d", "libswscale": "84cd49d996eb6e834396c55d780d66e942db2945747f09eba14f3d7dd516674f"]

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
        .library(
            name: "FFmpeg",
            type: .dynamic,
            targets: ["FFmpeg"] + libs.map { $0.key }),
    ] + libs.map { .library(name: $0.key, targets: [$0.key]) },
    dependencies: [],
    targets: [
        .target(
            name: "FFmpeg-Kit",
            dependencies: frameworks.map { .byName(name: $0.key) },
            linkerSettings: linkerSettings),
        .target(
            name: "FFmpeg",
            dependencies: libs.map { .byName(name: $0.key) },
            linkerSettings: linkerSettings),
    ] + frameworks.map { xcframework($0) }
)
