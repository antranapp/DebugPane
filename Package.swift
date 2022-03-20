// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "DebugPane",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "DebugPane",
            targets: ["DebugPane"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/antranapp/TweakPane", .branch("master")),
    ],
    targets: [
        .target(
            name: "DebugPane",
            dependencies: ["TweakPane"]
        ),
    ]
)
