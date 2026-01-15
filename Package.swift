// swift-tools-version:6.1
import PackageDescription

var defaultSwiftSettings: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    .enableExperimentalFeature(
        "AvailabilityMacro=FeatherMailAvailability:macOS 13, iOS 16, watchOS 9, tvOS 16, visionOS 1"
    ),
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableExperimentalFeature("Lifetimes"),
]

#if compiler(>=6.2)
defaultSwiftSettings.append(
    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0461-async-function-isolation.md
    .enableUpcomingFeature("NonisolatedNonsendingByDefault")
)
#endif

let package = Package(
    name: "feather-mail",
   
    products: [
        .library(name: "FeatherMail", targets: ["FeatherMail"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log", from: "1.6.0"),
    ],
    targets: [
        .target(
            name: "FeatherMail",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
            ]
        ),
        .testTarget(
            name: "FeatherMailTests",
            dependencies: [
                .target(name: "FeatherMail"),
            ],
            resources: [
                .copy("Assets/feather.png")
            ]
        ),
    ]
)
