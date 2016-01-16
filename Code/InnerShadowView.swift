import UIKit
import Tailor

/// A view that has an inner shadow.
public class InnerShadowView: View {

  public override init() {
    super.init()
    opaque = false
    contentMode = .Redraw
  }
  public override init(frame: CGRect) {
    super.init(frame: frame)
    opaque = false
    contentMode = .Redraw
  }
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  /// The color of the inner shadow.
  public var innerShadowColor: UIColor? {
    didSet {
      setNeedsDisplay()
    }
  }

  /// The offset of the inner shadow.
  public var innerShadowOffset = CGSizeZero {
    didSet {
      setNeedsDisplay()
    }
  }

  /// The radius of the inner shadow.
  public var innerShadowRadius = CGFloat(0) {
    didSet {
      setNeedsDisplay()
    }
  }

  public override func drawRect(rect: CGRect) {
    super.drawRect(rect)

    if let color = innerShadowColor?.CGColor {
      let context = UIGraphicsGetCurrentContext()
      CGContextAddRoundedRect(context, bounds, layer.cornerRadius)
      CGContextDrawInnerShadow(context, offset: innerShadowOffset, radius: innerShadowRadius, color: color)
    }
  }

}