import UIKit
import Tailor

/// Text field with more settings, like text edge insets and placeholder attributes.
public class TextView: UITextView {

  override public init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)

    setup()
  }

  required public init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  deinit {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.removeObserver(self)
  }

  // MARK: Placeholder attributes.

  /// Attributes for the placeholder.
  public var placeholderAttributes = [String: AnyObject]() {
    didSet {
      updatePlaceholder()
    }
  }

  public var placeholder: String? {
    didSet {
      updatePlaceholder()
    }
  }

  public var attributedPlaceholder: NSAttributedString? {
    didSet {
      updatePlaceholder()
    }
  }

  private var shouldShowPlaceholder: Bool {
    return text == nil || text == ""
  }

  public override var attributedText: NSAttributedString! {
    didSet {
      updatePlaceholder()
    }
  }

  // MARK: Set up

  let placeholderLabel = UILabel()

  public func setup() {
    addSubview(placeholderLabel)

    textContainer.lineFragmentPadding = 0

    updatePlaceholder()

    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.addObserver(self, selector: "textDidChange", name: UITextViewTextDidChangeNotification, object: self)
  }

  public override func layoutSubviews() {
    placeholderLabel.width = width - textContainerInset.left - textContainerInset.right
    placeholderLabel.sizeToFit()
    placeholderLabel.position.x = textContainerInset.left
    placeholderLabel.position.y = textContainerInset.top
  }

  // MARK: Change handling

  func textDidChange() {
    updatePlaceholder()
  }

  /// Updates the placeholder to include default placeholder attributes.
  private func updatePlaceholder() {
    placeholderLabel.hidden = !shouldShowPlaceholder

    if let placeholder = attributedPlaceholder {
      placeholderLabel.attributedText = placeholder
    } else if let placeholder = placeholder {
      placeholderLabel.attributedText = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
    } else {
      placeholderLabel.text = nil
    }

    setNeedsLayout()
  }

}

// MARK: - Tailor extensions

extension TextView: EdgeInsetsStyleable {
  public var style_edgeInsets: UIEdgeInsets {
    get { return textContainerInset }
    set { textContainerInset = newValue }
  }
}