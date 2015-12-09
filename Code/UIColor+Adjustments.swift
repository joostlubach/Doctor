import UIKit

public extension UIColor {

  /// Returns a color that is this color, darkened by a certain factor.
  func colorByDarkeningWithFactor(factor: Double) -> UIColor {
    let multiplier = CGFloat(1.0 - factor)

    var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
    var alpha: CGFloat = 0
    getRed(&red, green: &green, blue: &blue, alpha: &alpha)

    red *= multiplier
    green *= multiplier
    blue *= multiplier

    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
  }

  /// Returns a color that is this color, lightened by a certain factor.
  func colorByLighteningWithFactor(factor: Double) -> UIColor {
    let multiplier = CGFloat(1.0 + factor)

    var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
    var alpha: CGFloat = 0
    getRed(&red, green: &green, blue: &blue, alpha: &alpha)

    red = min(1.0, red * multiplier)
    green = min(1.0, green * multiplier)
    blue = min(1.0, blue * multiplier)

    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
  }

}