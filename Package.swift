// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let release = "1.2"

let frameworks = ["ffmpegkit": "9b76c58a1a97c48711ff5d2c89fde8af75bbd146d595f3d42af4fc08db4b5d8f", "libavcodec": "6a51cf4f21dd7cb9300a26a9803a5efc7d9fb6ea63ae79ea511871ea050d6a8b", "libavdevice": "2801d0a0232b575c29e0faf2d6f825af9218d6c8694650152c9cbd3e7a4ad1cc", "libavfilter": "48c949b721076b9cfe6551228012f7b2df1728e4176c942aec85a69d35cd3ee0", "libavformat": "f62f422328814d4768a4c4b6f56fcf29db8ce3d35ad19121250ed86752dde1f5", "libavutil": "2f5e38f00afdeb8143242493cea5e332fdea8422b634649f2cc32bb2a6ab2822", "libswresample": "ca3f56306c0946f82232eed01269ae6c5e336611e0483f30fd6cce54290a8394", "libswscale": "325e21dfc94e646254748acfd27b074f3124b033cc551164fae53c2f5425cfc0"]

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
