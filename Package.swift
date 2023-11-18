// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "feather-mail",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "FeatherMail", targets: ["FeatherMail"]),
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
        .testTarget(
            name: "FeatherMailTests",
            dependencies: [
                .target(name: "FeatherMail"),
            ]
        ),
    ]
)
