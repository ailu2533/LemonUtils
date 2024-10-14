// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
        name: "LemonUtils",
        defaultLocalization: "en",
        platforms: [.iOS(.v17)],
        products: [
            // Products define the executables and libraries a package produces, making them visible to other packages.
            .library(
                    name: "LemonUtils",
                    targets: ["LemonUtils"])

        ],
        dependencies: [
//            .package(url: "https://github.com/airbnb/HorizonCalendar", exact: "2.0.0"),
            .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.1.0")),
//            .package(url: "https://github.com/melvitax/DateHelper", .upToNextMajor(from: "5.0.1")),
//            .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.55.1"),
                .package(url: "https://github.com/ailu2533/LemonDateUtils.git", branch: "main"),
        ],
        targets: [
            // Targets are the basic building blocks of a package, defining a module or a test suite.
            // Targets can depend on other targets in this package and products from dependencies.

            .target(
                    name: "LemonUtils",
                    dependencies: [
//                        .product(name: "HorizonCalendar", package: "HorizonCalendar"),
                        .product(name: "Collections", package: "swift-collections"),
//                        .product(name: "DateHelper", package: "DateHelper"),
                        .product(name: "LemonDateUtils", package: "LemonDateUtils")
                    ]
//                    ,
//                    plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
            ),

            .testTarget(
                    name: "LemonUtilsTests",
                    dependencies: ["LemonUtils"])

        ]
)
