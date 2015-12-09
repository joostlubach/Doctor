import UIKit

public extension UIBarButtonItem {

  /// Creates a standard Cancel item.
  static func cancelItem(target target: AnyObject, action: Selector) -> UIBarButtonItem {
    return UIBarButtonItem(barButtonSystemItem: .Cancel, target: target, action: action)
  }

  /// Creates a standard Done item.
  static func doneItem(target target: AnyObject, action: Selector) -> UIBarButtonItem {
    return UIBarButtonItem(barButtonSystemItem: .Done, target: target, action: action)
  }

}