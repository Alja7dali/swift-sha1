/// Hashing bytes using the SHA1 alghorithm
///
/// https:///en.wikipedia.org/wiki/SHA-1

import Base16

public func hash(_ bytes: Bytes, encoding using: (Bytes) -> Bytes = Base16.encode) -> Bytes {
  var message = bytes

  var h0 = UInt32(littleEndian: 0x67452301)
  var h1 = UInt32(littleEndian: 0xEFCDAB89)
  var h2 = UInt32(littleEndian: 0x98BADCFE)
  var h3 = UInt32(littleEndian: 0x10325476)
  var h4 = UInt32(littleEndian: 0xC3D2E1F0)

  /// ml = message length in bits (always a multiple of the number of bits in a character).

  let ml = UInt64(message.count * 8)

  /// append the bit '1' to the message e.g. by adding 0x80 if message length is a multiple of 8 bits.

  message.append(0x80)

  /// append 0 ≤ k < 512 bits '0', such that the resulting message length in bits is congruent to −64 ≡ 448 (mod 512)

  let padBytesCount = ( message.count + 8 ) % 64

  message.append(contentsOf: [UInt8](repeating: 0, count: 64 - padBytesCount))

  /// append ml, in a 64-bit big-endian integer. Thus, the total length is a multiple of 512 bits.

  var mlBigEndian = ml.bigEndian
  withUnsafePointer(to: &mlBigEndian) {
    message.append(contentsOf: Array(UnsafeBufferPointer<UInt8>(start: UnsafePointer(OpaquePointer($0)), count: 8)))
  }

  /// Process the message in successive 512-bit chunks ( 64 bytes chunks ):

  for chunkStart in 0..<message.count/64 {
    var words = [UInt32]()
    let chunk = message[chunkStart*64..<chunkStart*64+64]

    /// break chunk into sixteen 32-bit big-endian words w[i], 0 ≤ i ≤ 15

    for i in 0...15 {
      let value = chunk.withUnsafeBufferPointer({ UnsafePointer<UInt32>(OpaquePointer($0.baseAddress! + (i*4))).pointee})
      words.append(value.bigEndian)
    }

    /// Extend the sixteen 32-bit words into eighty 32-bit words:

    for i in 16...79 {
      let value: UInt32 = ((words[i-3]) ^ (words[i-8]) ^ (words[i-14]) ^ (words[i-16]))
      words.append(rotateLeft(value, by: 1))
    }

    /// Initialize hash value for this chunk:

    var a = h0
    var b = h1
    var c = h2
    var d = h3
    var e = h4

    for i in 0..<80 {
      var f = UInt32(0)
      var k = UInt32(0)
      switch i {
      case 0...19:
        f = (b & c) | ((~b) & d)
        k = 0x5A827999
      case 20...39:
        f = b ^ c ^ d
        k = 0x6ED9EBA1
      case 40...59:
        f = (b & c) | (b & d) | (c & d)
        k = 0x8F1BBCDC
      case 60...79:
        f = b ^ c ^ d
        k = 0xCA62C1D6
      default: break
      }
      let temp = (rotateLeft(a, by: 5) &+ f &+ e &+ k &+ words[i]) & 0xFFFFFFFF
      e = d
      d = c
      c = rotateLeft(b, by: 30)
      b = a
      a = temp
    }

    /// Add this chunk's hash to result so far:

    h0 = ( h0 &+ a ) & 0xFFFFFFFF
    h1 = ( h1 &+ b ) & 0xFFFFFFFF
    h2 = ( h2 &+ c ) & 0xFFFFFFFF
    h3 = ( h3 &+ d ) & 0xFFFFFFFF
    h4 = ( h4 &+ e ) & 0xFFFFFFFF
  }

  /// Produce the final hash value (big-endian) as a 160 bit number:

  var digest = [UInt8]()

  [h0, h1, h2, h3, h4].forEach { value in
    var bigEndianVersion = value.bigEndian
    withUnsafePointer(to: &bigEndianVersion) {
      digest.append(contentsOf: Array(UnsafeBufferPointer<UInt8>(start: UnsafePointer(OpaquePointer($0)), count: 4)))
    }
  }

  return using(digest)
}