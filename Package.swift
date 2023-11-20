// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "feather-mail",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
    ],
    products: [
        .library(name: "FeatherMail", targets: ["FeatherMail"]),
        .library(name: "XCTFeatherMail", targets: ["XCTFeatherMail"]),
    ],
    dependencies: [
        .package(url: "https://github.com/feather-framework/feather-service",
            .upToNextMinor(from: "0.2.0")
        ),
    ],
    targets: [
        .target(
            name: "FeatherMail",
            dependencies: [
                .product(name: "FeatherService", package: "feather-service")
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
            name: "FeatherMailTests",
            dependencies: [
                .target(name: "FeatherMail"),
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
