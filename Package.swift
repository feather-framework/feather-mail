// swift-tools-version:6.3
import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    .strictMemorySafety(),
    .treatAllWarnings(as: .error),
    .enableUpcomingFeature("InternalImportsByDefault"),
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableUpcomingFeature("InferIsolatedConformances"),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("ImmutableWeakCaptures"),
    .enableExperimentalFeature("SuppressedAssociatedTypes"),
    .enableExperimentalFeature("LifetimeDependence"),
    .enableExperimentalFeature("Lifetimes"),
    .enableUpcomingFeature("StrictConcurrency"),
]

let package = Package(
    name: "feather-mail",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "FeatherMail", targets: ["FeatherMail"]),
        .library(name: "FeatherMailTesting", targets: ["FeatherMailTesting"]),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "FeatherMail",
            dependencies: [],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "FeatherMailTesting",
            dependencies: [
                .target(name: "FeatherMail"),
            ],
            path: "Sources/FeatherMailTesting",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "FeatherMailTests",
            dependencies: [
                .target(name: "FeatherMail"),
            ],
            resources: [
                .copy("Assets/feather.png")
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "FeatherMailTestingTests",
            dependencies: [
                .target(name: "FeatherMail"),
                .target(name: "FeatherMailTesting"),
            ],
            swiftSettings: swiftSettings
        ),
    ],
    
)
