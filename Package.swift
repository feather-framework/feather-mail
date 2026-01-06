// swift-tools-version:6.2
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
        .library(name: "XCTFeatherMail", targets: ["XCTFeatherMail"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.2"),
        .package(url: "https://github.com/apple/swift-log", from: "1.8.0"),
    ],
    targets: [
        .target(
            name: "FeatherMail",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
            ]
        ),
        .target(
            name: "XCTFeatherMail",
            dependencies: [
                .target(name: "FeatherMail"),
            ],
            resources: [
                .copy("Assets/feather.png")
            ]
        ),
        .testTarget(
            name: "XCTFeatherMailTests",
            dependencies: [
                .target(name: "XCTFeatherMail"),
            ]
        ),
    ]
)
