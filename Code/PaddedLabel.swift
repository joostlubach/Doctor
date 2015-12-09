import UIKit
import Tailor

public class PaddedLabel: UILabel {

  public var edgeInsets = UIEdgeInsetsZero {
    didSet {
      setNeedsDisplay()
    }
  }

  public override func sizeThatFits(size: CGSize) -> CGSize {
    let textSize = super.sizeThatFits(size)
    return CGSize(
      width: textSize.width + edgeInsets.left + edgeInsets.right,
      height: textSize.height + edgeInsets.top + edgeInsets.bottom
    )
  }

  public override func drawTextInRect(rect: CGRect) {
    let innerRect = UIEdgeInsetsInsetRect(rect, edgeInsets)
    super.drawTextInRect(innerRect)
  }

}

extension PaddedLabel: EdgeInsetsStyleable {
  public var style_edgeInsets: UIEdgeInsets {
    get { return edgeInsets }
    set { edgeInsets = newValue }
  }
}