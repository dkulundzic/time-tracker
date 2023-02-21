// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "TimeTrackerPersistence",
  platforms: [.iOS(.v16)],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "TimeTrackerPersistence",
      targets: ["TimeTrackerPersistence"]),
  ],
  dependencies: [
    .package(path: "../TimeTrackerModel"),
    .package(url: "https://github.com/groue/GRDB.swift.git", from: "6.7.0"),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "TimeTrackerPersistence",
      dependencies: [
        "TimeTrackerModel",
        .product(name: "GRDB", package: "GRDB.swift")
      ]),
    .testTarget(
      name: "TimeTrackerPersistenceTests",
      dependencies: ["TimeTrackerPersistence"]),
  ]
)
