import UIKit

public extension UIImage {

  class func imageWithSolidColor(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
    var rect = CGRect()
    rect.size = size

    var image: UIImage?

    UIGraphicsBeginImageContext(size)
    color.setFill()
    CGContextFillRect(UIGraphicsGetCurrentContext(), rect)
    image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return image!
  }

}