import UIKit

public extension UIColor {

  /// Returns a color that is this color, darkened by a certain factor.
  func colorByDarkeningWithFactor(factor: CGFloat) -> UIColor {
    var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
    var alpha: CGFloat = 0
    getRed(&red, green: &green, blue: &blue, alpha: &alpha)

    red   *= (1.0 - factor)
    green *= (1.0 - factor)
    blue  *= (1.0 - factor)

    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
  }

  /// Returns a color that is this color, lightened by a certain factor.
  func colorByLighteningWithFactor(factor: CGFloat) -> UIColor {
    var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
    var alpha: CGFloat = 0
    getRed(&red, green: &green, blue: &blue, alpha: &alpha)

    red   = min(1.0, red + (1 - red) * factor)
    green = min(1.0, green + (1 - green) * factor)
    blue  = min(1.0, blue + (1 - blue) * factor)

    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
  }

}