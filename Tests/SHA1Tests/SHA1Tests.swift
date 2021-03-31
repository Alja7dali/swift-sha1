import XCTest
@testable import SHA1

final class SHA1Tests: XCTestCase {
  func testSHA1() {
    do {
      let hashed = SHA1.hash("Hello, World!".makeBytes())
      let hashedString = try String(hashed)
      XCTAssertEqual(hashedString, "0a0a9f2a6772942557ab5355d76af442f8f65e01")
    } catch {
      print(error)
      XCTFail()
    }
  }

  static var allTests = [
    ("testSHA1", testSHA1),
  ]
}
