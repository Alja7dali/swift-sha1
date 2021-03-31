###### This is an implementation of [SHA1](https://en.wikipedia.org/wiki/SHA-1) `hash` algorithm.

#### Example:

```swift
import SHA1

/// Hash to SHA1
/// 1. convert string to bytes (utf8 format)
let bytes = "Hello, World!".makeBytes()
/// 2. hash bytes using sha1 digesting algorithm
let hashedBytes = SHA1.hash(bytes)
/// 3. converting bytes back to string
let hashedString = try String(hashedBytes) // "0a0a9f2a6772942557ab5355d76af442f8f65e01"
```

#### Importing SHA1:

To include `SHA1` in your project, you need to add the following to the `dependencies` attribute defined in your `Package.swift` file.
```swift
dependencies: [
  .package(url: "https://github.com/alja7dali/swift-sha1.git", from: "1.0.0")
]
```