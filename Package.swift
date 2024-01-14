// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CocoaCoordinator",
    platforms: [.macOS(.v10_13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CocoaCoordinator",
            targets: ["CocoaCoordinator"]
        ),
        .library(
            name: "RxCocoaCoordinator",
            targets: ["RxCocoaCoordinator"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/ReactiveX/RxSwift",
            .upToNextMajor(from: "6.0.0")
        ),
    ],
    targets: [
        .target(
            name: "CocoaCoordinator"
        ),

        .target(
            name: "RxCocoaCoordinator", dependencies: [
                "CocoaCoordinator",
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
            ]
        ),
    ]
)
