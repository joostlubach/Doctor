import UIKit

public extension UIColor {

  convenience init(hex: Int) {
    let red   = CGFloat(hex >> 16 % 256) / 255.0
    let green = CGFloat(hex >> 8 % 256) / 255.0
    let blue  = CGFloat(hex >> 0 % 256) / 255.0

    self.init(red: red, green: green, blue: blue, alpha: 1.0)
  }
  
}