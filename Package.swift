// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let release = "0.1"

let frameworks = ["ffmpegkit": "b11a59e8542f4e41869ec04e229e27b5aeff547e33633cf0cad2842076abd21a", "libavcodec": "e5adbce7812f639dd3e3db9a2fa0c6ed481638ecd0c142343dcba2aec543230d", "libavdevice": "9104497d34dfe331ee97d90e8885a47fedc22df7e821a79d0cb6da8392b2c6d2", "libavfilter": "d303d88e3dadaa25ba89b799392cb4d259836a381c42b36f6b575a0b7a7fcc37", "libavformat": "65db7fe22428abb9b316c0c123a89b6b069953aa027846913341e901be904ee5", "libavutil": "1965c3f99f91bebc5903cfc97eb2d52e5ad2b680e9f0ffeef546c32ab1093d5b", "libswresample": "3b6958bf4e61ef6d7ea592695b44eb0d45df2629a8f24dff4b3dca4edcc003ed", "libswscale": "c17883a5eeff03529a3d3d9e669502ec73ac92da13380e27e0cb6e9f34c65ac0"]

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
