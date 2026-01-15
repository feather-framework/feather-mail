// swift-tools-version:6.1
import PackageDescription

let package = Package(
    name: "feather-mail",

    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1),
    ],

    products: [
        .library(name: "FeatherMail", targets: ["FeatherMail"]),
    ],

    dependencies: [
        .package(url: "https://github.com/apple/swift-log", from: "1.6.0")
    ],

    targets: [
        .target(
            name: "FeatherMail",
            dependencies: [
                .product(name: "Logging", package: "swift-log")
            ]
        ),
        .testTarget(
            name: "FeatherMailTests",
            dependencies: [
                .target(name: "FeatherMail")
            ],
            resources: [
                .copy("Assets/feather.png")
            ]
        ),
    ]
)
