// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let release = "1.0"

let frameworks = ["ffmpegkit": "c0b710038bb52043f06258237ef2d3ba9d79b170a0f1acc2a272a43edaf8cdf6", "libavcodec": "b5dd0ea64b462114c68988fa4c51c0f5f64e9e32a4bea5818d0a288ebe95e937", "libavdevice": "f92942a1c910e10e649bc7450028f73c58d72d56dd677d749cedfbfd06ebb0a9", "libavfilter": "fdee44ad52ed1e2f1d02924f784d3fa2be3bc96d9f298ba047ea5139f7d4511c", "libavformat": "075041b758c5e08e3e4f8006a79889a3991e7e7ebd7cdd38044e5ef835c3fba6", "libavutil": "a4478b4d101c9a615a3548727556acb664f813fb1138a88dbb9125352d1912e7", "libswresample": "7c9d962a4cee2d480ea91a5121106affe58dbe333d5fc9f72623ada8847e48d0", "libswscale": "21a84586fdb41dabb5e179166bc77d99096bf9792d82787c435419431d465cde"]

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
