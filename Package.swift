// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
    name: "ApolloCLITools",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "DownloadSchema", targets: ["DownloadSchema"]),
        .executable(name: "GenerateCode", targets: ["GenerateCode"])
    ],
    dependencies: [
        .package(url: "https://github.com/apollographql/apollo-ios.git", exact: "1.9.1"),
        .package(url: "https://github.com/apollographql/apollo-ios-codegen.git", exact: "1.9.1"),
        .package(url: "https://github.com/apple/swift-argument-parser", exact: "1.3.1")
    ],
    targets: [
        .executableTarget(name: "DownloadSchema", dependencies: [
            .product(name: "Apollo", package: "apollo-ios"),
            .product(name: "ApolloCodegenLib", package: "apollo-ios-codegen"),
            .product(name: "ArgumentParser", package: "swift-argument-parser")
        ]),
        .executableTarget(name: "GenerateCode", dependencies: [
            .product(name: "Apollo", package: "apollo-ios"),
            .product(name: "ApolloCodegenLib", package: "apollo-ios-codegen"),
            .product(name: "ArgumentParser", package: "swift-argument-parser")
        ])
    ]
)
