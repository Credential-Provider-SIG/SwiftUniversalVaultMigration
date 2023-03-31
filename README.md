# Swift Universal Vault Migration 

Implementation of the [Universal Vault Migration proposal](https://github.com/Credential-Provider-SIG/Universal-Vault-Migration) for Swift.

The package contains a complete Swift implementation of the data transfer flow, utilising Apple's CryptoKit library for cryptographic operations.

## Usage
To use UniversalVaultMigration in your project, add the following line to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/dashlane/SwiftUniversalVaultMigration.git", branch: "main")
]
```

then in target dependencies add

```swift
 .product(name: "UniversalVaultMigration", package: "UniversalVaultMigration"),
```

## Demo apps

The repository features a demo Xcode project that demonstrates how to transfer data between two applications using drag and drop on apple platforms.

It includes two mock apps that simulate password/passkey managers, one of which is pre-filled with data to serve as a demo provider. The vault from the DemoProvider can be moved to the other Demo app via drag and drop.

Most of the UI flow is defined within the `UniversalVaultMigrationUI` library in the package and can  be used to quickly bootstrap the flow in iOS or macOS apps.
