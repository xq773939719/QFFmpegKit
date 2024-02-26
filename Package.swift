// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let release = "0.1"

let frameworks = [".DS_Store": "ba2188798968fefc9ed95042ad6231b4294bf2bf864488594c665cd86fc264fa", "ffmpegkit": "ebfcf6e9659e6a79a789b1f669005b4c0dd95a2aec6a2c153c2a0fff44e68679", "libavcodec": "09c0951e4b66f3299cca75660b2aaa01519ff8f880e5e9c867c6719dc0380418", "libavdevice": "1260b726991524671c0248a1e44c4c3418a3eda03aedc75f342c8abe59d67b91", "libavfilter": "11a2a63867fb8dc929024fb3eacaeb302fe0a98684641e39a9ccb523866cf8eb", "libavformat": "523831662fadee7904944987ed63732b6a8d22e942ced0b95acc08a7f94fdfeb", "libavutil": "b24a4bbbc998639cac69657e30c2d7ca81ce037751ebf8ae4a6c4156b260552f", "libswresample": "760328f937ad5c65fb0557fb0db16c13c7ebb3c322701c572094d4357bf324c5", "libswscale": "934c63f6b88675457412d23db806e1fd44a7b421b25b89e0243147e2fd2571e3"]

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
