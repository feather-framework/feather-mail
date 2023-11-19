// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "feather-mail",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "FeatherMail", targets: ["FeatherMail"]),
        .library(name: "XCTFeatherMail", targets: ["XCTFeatherMail"]),
    ],
    dependencies: [
        .package(url: "https://github.com/feather-framework/feather-service.git", .upToNextMinor(from: "0.1.0")),
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
