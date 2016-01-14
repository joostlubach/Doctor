import UIKit

public extension UIColor {

  convenience init(hex: Int) {
    let red   = CGFloat(hex >> 16 % 256) / 255.0
    let green = CGFloat(hex >> 8 % 256) / 255.0
    let blue  = CGFloat(hex >> 0 % 256) / 255.0

    self.init(red: red, green: green, blue: blue, alpha: 1.0)
  }

  var hex: Int {
    var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
    var alpha: CGFloat = 0
    getRed(&red, green: &green, blue: &blue, alpha: &alpha)

    return Int(red*255) << 16 | Int(green*255) << 8 | Int(blue*255)
  }

  var hexString: String {
    var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
    var alpha: CGFloat = 0
    getRed(&red, green: &green, blue: &blue, alpha: &alpha)

    let string = NSMutableString()
    string.appendFormat("%02hhX", Int(red * 255))
    string.appendFormat("%02hhX", Int(green * 255))
    string.appendFormat("%02hhX", Int(blue * 255))

    return string as String
  }
  
}