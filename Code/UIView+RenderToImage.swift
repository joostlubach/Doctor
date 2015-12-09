import UIKit

public extension UIView {

  /// Renders the view to a static image.
  func renderToImage() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.mainScreen().scale)
    defer { UIGraphicsEndImageContext() }

    if let context = UIGraphicsGetCurrentContext() {
      layer.renderInContext(context)
    }

    return UIGraphicsGetImageFromCurrentImageContext()
  }

}