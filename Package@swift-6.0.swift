// swift-tools-version:6.0
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
        .library(name: "FeatherMailTesting", targets: ["FeatherMailTesting"]),
    ],

    dependencies: [
        .package(url: "https://github.com/apple/swift-log", from: "1.8.0")
    ],

    targets: [
        .target(
            name: "FeatherMail",
            dependencies: [
                .product(name: "Logging", package: "swift-log")
            ]
        ),
        .target(
            name: "FeatherMailTesting",
            dependencies: [
                .target(name: "FeatherMail")
            ],
            resources: [
                .copy("Assets/feather.png")
            ]
        ),
        .testTarget(
            name: "FeatherMailTests",
            dependencies: [
                .target(name: "FeatherMailTesting")
            ]
        ),
    ]
)
