// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let release = "1.4"

let frameworks = ["ffmpegkit": "703d48f9a0d720c6da5579e1147bf4fe092544b8cf2349590ab3b06b54cb8802", "libavcodec": "351c0fc4b9f6f1493342193a5e4c01d680f9a042649faaf5ecc54cef53525cd8", "libavdevice": "b529d3f0da4e0421828055338fb38561738614228ba221bebdb73870eb48cf22", "libavfilter": "4804989d1196140569a2502d3e55f8eac5787ebb10691be8119068d736aad56b", "libavformat": "f28b14e03d156b593d07fd1b91acdbb8111482f2df2e05cb077e04cc61264c42", "libavutil": "60202c0baf3f4a8335f05183fffdf8a4fdc04e8b63b28fc1990006f043037cd9", "libswresample": "4c02d1dec9082de60ecab04391aa56115b263fb6dd3effc772a4c147b18f5fbb", "libswscale": "c021aad42d4e4d9e36a4babdf29cb4d5a40df116e0955a187298160373619dd9"]

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
