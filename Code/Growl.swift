import UIKit
import Tailor

/// Displays quick messages modally for a short time.
public class Growl {

  // MARK: - Initialization

  /// Initializes a new Growl overlay with the given icon and message.
  ///
  /// - parameter icon:    An icon to display.
  /// - parameter message: A message to display.
  public init(icon: UIImage, message: String) {
    self.message = message
    self.icon = icon
    view.label.text = message
  }

  /// Initializes a new Growl overlay with the given icon and message.
  ///
  /// - parameter iconName:  The name of an icon to display.
  /// - parameter message:   A message to display.
  public init(iconName: String, message: String) {
    self.message = message
    self.icon = UIImage(named: iconName)!
    view.label.text = message
  }

  /// Initializes a new Growl overlay with the given message.
  ///
  /// - parameter message:   A message to display.
  public init(message: String) {
    self.message = message
    self.icon = nil
    view.label.text = message
  }

  // MARK: Properties

  /// The message to display.
  public var message: String

  /// An optional icon to display.
  public var icon: UIImage? {
    didSet {
      view.iconView.image = icon?.imageWithRenderingMode(.AlwaysTemplate)
    }
  }

  var appWindow: UIWindow! {
    let app = UIApplication.sharedApplication()
    return app.keyWindow!
  }

  /// The Growl view.
  public let view = GrowlView()

  // MARK: - Theming

  /// Provide a theme for this growl.
  public static var theme: Theme?

  // MARK: - Showing

  /// Shows this Growl.
  public func show() {
    // Add the view to the window.
    appWindow.addSubview(view)

    // Size & position the view.
    view.size = appWindow.size
    view.sizeToFit()
    view.center = appWindow.center

    Growl.theme?.applyTo(view)

    animateIn()
  }

  private func animateIn() {
    view.transform = CGAffineTransformMakeScale(0.5, 0.5)
    view.alpha = 1.0

    UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [], animations: {
      self.view.transform = CGAffineTransformIdentity
    }, completion: nil)

    UIView.animateWithDuration(0.4, delay: 1.5, usingSpringWithDamping: 1, initialSpringVelocity: 2.0, options: [], animations: {
      self.view.alpha = 0.0
    }, completion: nil)

    UIView.animateWithDuration(0.6, delay: 1.5, usingSpringWithDamping: 1, initialSpringVelocity: 2.0, options: [], animations: {
      self.view.transform = CGAffineTransformMakeScale(3, 3)
    }, completion: { _ in
      self.view.removeFromSuperview()
    })
  }

}

public class GrowlView: ThemedView {

  public let iconView = UIImageView()
  public let label = UILabel()

  public override func setup() {
    label.textAlignment = .Center
    label.numberOfLines = 0
    userInteractionEnabled = false

    addSubview(iconView)
    addSubview(label)
  }

  public override func sizeThatFits(size: CGSize) -> CGSize {
    let iconSize = iconView.sizeThatFits(size)
    let labelSize = label.sizeThatFits(CGSize(width: size.width - 4 * 16, height: size.height))

    var fitSize = CGSize()
    fitSize.width = max(iconSize.width, labelSize.width) + 2 * 16

    if iconView.image != nil {
      fitSize.height = iconSize.height + 8 + labelSize.height + 2 * 16
    } else {
      fitSize.height = labelSize.height + 2 * 16
    }

    return fitSize
  }

  public override func layoutSubviews() {
    iconView.sizeToFit()

    label.size = size
    label.width -= 2 * 16
    label.sizeToFit()

    if iconView.image != nil {
      column([16, iconView, 8, label, 16], align: .Center)
    } else {
      column([16, label, 16], align: .Center)
    }
    
  }
  
}

public func growl(icon icon: UIImage, message: String) {
  Growl(icon: icon, message: message).show()
}

public func growl(iconName iconName: String, message: String) {
  Growl(iconName: iconName, message: message).show()
}

public func growl(message message: String) {
  Growl(message: message).show()
}