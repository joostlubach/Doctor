import Foundation

public extension NSData {

  /// Retrieves the data as a hexadecimal encoded string.
  var hexString: String {
    var buffer = [UInt8](count: length, repeatedValue: 0x00)
    getBytes(&buffer, length: length)

    let string = NSMutableString()
    for byte in buffer {
      string.appendFormat("%02hhX", byte)
    }

    return string as String
  }

}