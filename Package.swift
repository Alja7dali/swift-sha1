// swift-tools-version:5.0
import PackageDescription

let package = Package(
  name: "SHA1",
  products: [
    .library(name: "SHA1", targets: ["SHA1"]),
  ],
  dependencies: [
    .package(url: "https://github.com/alja7dali/swift-bits.git", from: "1.0.0"),
    .package(url: "https://github.com/alja7dali/swift-base16.git", from: "1.0.0"),
  ],
  targets: [
    .target(name: "SHA1", dependencies: ["Bits", "Base16"]),
    .testTarget(name: "SHA1Tests", dependencies: ["SHA1"]),
  ]
)
