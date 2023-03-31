// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UniversalVaultMigration",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(name: "UniversalVaultMigration",
                 targets: ["UniversalVaultMigration"]),
        .library(name: "UniversalVaultMigrationUI",
                 targets: ["UniversalVaultMigrationUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-crypto.git", "1.0.0" ..< "3.0.0"),
    ],
    targets: [
        .target(
            name: "UniversalVaultMigration"),
        .target(
            name: "UniversalVaultMigrationUI",
            dependencies: ["UniversalVaultMigration"]),
        .testTarget(
            name: "UniversalVaultMigrationTests",
            dependencies: ["UniversalVaultMigration"])
    ]
)
