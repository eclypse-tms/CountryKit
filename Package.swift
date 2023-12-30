// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CountryKit",
    platforms: [
            .iOS(.v14)
        ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CountryKit",
            targets: ["CountryKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/madebybowtie/FlagKit.git", from: "2.4.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        Target.target(name: "CountryKit",
                      dependencies: ["FlagKit"],
                      resources: [Resource.process("country/Locales.csv"),
                                  Resource.process("country/Wiki.csv")]),
        .testTarget(
            name: "CountryKitTests",
            dependencies: ["CountryKit", "FlagKit"]),
    ]
)
