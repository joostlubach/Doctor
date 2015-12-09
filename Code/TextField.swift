import UIKit
import Tailor

/// Text field with more settings, like text edge insets and placeholder attributes.
public class TextField: UITextField {

  // MARK: Text edge instets

  /// The edge insets for the text rect.
  public var textEdgeInsets = UIEdgeInsetsZero {
    didSet {
      setNeedsLayout()
    }
  }

  public override func textRectForBounds(bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, textEdgeInsets)
  }

  public override func editingRectForBounds(bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, textEdgeInsets)
  }

  // MARK: Placeholder attributes.

  /// Attributes for the placeholder.
  public var placeholderAttributes = [String: AnyObject]() {
    didSet {
      updatePlaceholder()
    }
  }

  /// When an unattributed placeholder is set, it is stored here.
  private var unattributedPlaceholder: String?

  public override var placeholder: String? {
    didSet {
      unattributedPlaceholder = placeholder
    }
  }

  public override var attributedPlaceholder: NSAttributedString? {
    didSet {
      unattributedPlaceholder = nil
    }
  }

  /// Updates the placeholder to include default placeholder attributes.
  private func updatePlaceholder() {
    if let placeholder = unattributedPlaceholder {
      super.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
    } else {
      super.attributedPlaceholder = nil
    }
  }

  public override func drawPlaceholderInRect(rect: CGRect) {
    let textRect = textRectForBounds(bounds)
    super.drawPlaceholderInRect(textRect)
  }

}

// MARK: - Tailor extensions

extension TextField: EdgeInsetsStyleable {
  public var style_edgeInsets: UIEdgeInsets {
    get { return textEdgeInsets }
    set { textEdgeInsets = newValue }
  }
}