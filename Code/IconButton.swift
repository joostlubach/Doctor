import UIKit
import Tailor

public class IconButton: Button {

  public init(icon: UIImage) {
    self.icon = icon
    super.init(frame: CGRectZero)

    reflectIcon()
  }

  public convenience init(iconName: String) {
    self.init(icon: UIImage(named: iconName)!)
    self.iconName = iconName
  }

  public required init(coder: NSCoder) {
    fatalError("IconButton does not support coding")
  }

  public override var highlighted: Bool {
    didSet {
      reflectState()
    }
  }

  public override var selected: Bool {
    didSet {
      reflectState()
    }
  }

  public var iconName: String? {
    didSet {
      if let name = iconName {
        icon = UIImage(named: name)!
      } else {
        icon = nil
      }
    }
  }

  public var icon: UIImage? {
    didSet {
      reflectIcon()
    }
  }

  public var normalColor = UIColor.whiteColor() {
    didSet {
      reflectState()
    }
  }

  public var highlightedColor = UIColor.whiteColor() {
    didSet {
      reflectState()
    }
  }

  public var selectedColor = UIColor.whiteColor() {
    didSet {
      reflectState()
    }
  }

  private func reflectIcon() {
    let image = icon?.imageWithRenderingMode(.AlwaysTemplate)
    setImage(image, forState: .Normal)
  }

  private func reflectState() {
    if selected {
      tintColor = selectedColor
    } else if highlighted {
      tintColor = highlightedColor
    } else {
      tintColor = normalColor
    }
  }
  
}