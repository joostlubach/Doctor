import UIKit
import Tailor

/// A push button with loading indicator.
public class PushButton: Button {

  public enum IconPlacement {
    /// The icon is on the left. The text is placed in the remaining space.
    case Left

    /// The icon is on the right. The text is placed in the remaining space.
    case Right

    /// The icon is directly to the left of the text, with some spacing inbetween.
    case LeftOfText(spacing: CGFloat)

    /// The icon is directly to the right of the text, with some spacing inbetween.
    case RightOfText(spacing: CGFloat)

    /// The icon is above the text, with some spacing inbetween.
    case AboveText(spacing: CGFloat)
  }

  /// The placement of the icon.
  public var iconPlacement = IconPlacement.Left {
    didSet {
      setNeedsLayout()
    }
  }

  public var normalStyle: StyleType? {
    didSet {
      reflectStyle()
    }
  }
  public var highlightedStyle: StyleType? {
    didSet {
      reflectStyle()
    }
  }
  public var selectedStyle: StyleType? {
    didSet {
      reflectStyle()
    }
  }

  /// The foreground color of the button (both tint color and text color).
  public var foregroundColor: UIColor? {
    get {
      return tintColor
    }
    set {
      tintColor = newValue
      setTitleColor(newValue, forState: state)
    }
  }

  /// Whether the button should be in 'loading' state.
  public var loading = false {
    didSet {
      loadingView.hidden = !loading
      enabled = !loading

      if loading != oldValue {
        if loading {
          titleLabel?.removeFromSuperview()
          imageView?.removeFromSuperview()
        } else {
          if let v = titleLabel { addSubview(v) }
          if let v = imageView { addSubview(v) }
        }
      }
    }
  }

  /// Inner shadow color.
  public var innerShadowColor: UIColor? {
    get { return innerShadowView.innerShadowColor }
    set { innerShadowView.innerShadowColor = newValue }
  }

  /// Inner shadow offset.
  public var innerShadowOffset: CGSize {
    get { return innerShadowView.innerShadowOffset }
    set { innerShadowView.innerShadowOffset = newValue }
  }

  /// Inner shadow radius.
  public var innerShadowRadius: CGFloat {
    get { return innerShadowView.innerShadowRadius }
    set { innerShadowView.innerShadowRadius = newValue }
  }

  /// Quick accessor for the button title.
  public var title: String? {
    get { return titleForState(.Normal) }
    set { setTitle(newValue, forState: .Normal) }
  }

  /// Setting the icon sets the image with a rendering mode of always template, so that the color can be changed.
  public var icon: UIImage? {
    didSet {
      let image = icon?.imageWithRenderingMode(.AlwaysTemplate)
      setImage(image, forState: .Normal)
    }
  }

  /// The font for the button title.
  public var titleFont: UIFont? {
    didSet {
      titleLabel?.font = titleFont
      setNeedsLayout()
    }
  }

  public var cornerRadius: CGFloat {
    get { return layer.cornerRadius }
    set {
      layer.cornerRadius = newValue
      innerShadowView.layer.cornerRadius = newValue
      loadingView.layer.cornerRadius = newValue
    }
  }

  public override var highlighted: Bool {
    didSet {
      reflectStyle()
    }
  }

  public override var enabled: Bool {
    didSet {
      reflectStyle()
    }
  }

  public override var selected: Bool {
    didSet {
      reflectStyle()
    }
  }

  /// A view displaying an inner shadow for the button.
  public let innerShadowView = InnerShadowView()

  /// The loading view containing the loading indicator.
  public let loadingView = LoadingView(activityIndicatorStyle: .White)

  public override func setup() {
    cornerRadius = layer.cornerRadius
    adjustsImageWhenHighlighted = false
    adjustsImageWhenDisabled = false

    addSubview(innerShadowView)
    innerShadowView.backgroundColor = UIColor.clearColor()
    innerShadowView.layer.cornerRadius = cornerRadius
    innerShadowView.userInteractionEnabled = false

    addSubview(loadingView)
    loadingView.userInteractionEnabled = false

    loadingView.hidden = true
    loadingView.backgroundColor = UIColor.clearColor()
    loadingView.layer.cornerRadius = cornerRadius

    self.titleFont = titleLabel?.font

    super.titleEdgeInsets = UIEdgeInsetsZero
    super.imageEdgeInsets = UIEdgeInsetsZero
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    innerShadowView.fillSuperview()
    loadingView.fillSuperview()
  }

  private var titleAndImageSize: (CGSize, CGSize) {
    let image = imageForState(state)
    let title = titleForState(state)

    let titleSize: CGSize, imageSize: CGSize
    if let title = title, let font = titleFont {
      titleSize = title.sizeWithAttributes([NSFontAttributeName: font])
    } else {
      titleSize = CGSizeZero
    }
    if let image = image {
      imageSize = image.size
    } else {
      imageSize = CGSizeZero
    }

    return (titleSize, imageSize)
  }

  public override func sizeThatFits(size: CGSize) -> CGSize {
    let (titleSize, imageSize) = titleAndImageSize

    var size = CGSize()

    if titleForState(state) != nil && imageForState(state) != nil {
      switch iconPlacement {
      case let .LeftOfText(spacing: spacing):
        size.width = imageSize.width + spacing + titleSize.width
        size.height = max(imageSize.height, titleSize.height)
      case let .RightOfText(spacing: spacing):
        size.width = imageSize.width + spacing + titleSize.width
        size.height = max(imageSize.height, titleSize.height)
      case let .AboveText(spacing: spacing):
        size.width = max(imageSize.width, titleSize.width)
        size.height = imageSize.height + spacing + titleSize.height
      case .Left, .Right:
        size.width = imageSize.width + titleSize.width
        size.height = max(imageSize.height, titleSize.height)
      }
    } else {
      size.width = imageSize.width + titleSize.width
      size.height = imageSize.height + titleSize.height
    }

    size.width += contentEdgeInsets.left + contentEdgeInsets.right
    size.height += contentEdgeInsets.top + contentEdgeInsets.bottom

    size.width = ceil(size.width)
    size.height = ceil(size.height)

    return size
  }

  public override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
    guard titleForState(state) != nil else {
      return super.imageRectForContentRect(contentRect)
    }

    let (titleSize, imageSize) = titleAndImageSize

    var rect = CGRect()
    rect.size = imageSize

    switch iconPlacement {
    case .Left:
      rect.origin.x = contentRect.minX
      rect.origin.y = contentRect.midY - rect.height / 2
    case .Right:
      rect.origin.x = contentRect.maxX - rect.width
      rect.origin.y = contentRect.midY - rect.height / 2
    case let .LeftOfText(spacing: spacing):
      rect.origin.x = (contentRect.midX - (titleSize.width + spacing + imageSize.width) / 2)
      rect.origin.y = contentRect.midY - rect.height / 2
    case let .RightOfText(spacing: spacing):
      rect.origin.x = (contentRect.midX + (titleSize.width + spacing + imageSize.width) / 2 - imageSize.width)
      rect.origin.y = contentRect.midY - rect.height / 2
    case let .AboveText(spacing: spacing):
      rect.origin.x = contentRect.midX - rect.width / 2
      rect.origin.y = contentRect.midY - (titleSize.height + spacing + imageSize.height) / 2
    }

    return rect
  }

  public override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
    guard imageForState(state) != nil else {
      return super.titleRectForContentRect(contentRect)
    }

    let (titleSize, imageSize) = titleAndImageSize

    var rect = CGRect()
    rect.size = titleSize

    switch iconPlacement {
    case .Left:
      rect.origin.x = imageSize.width + (contentRect.width - imageSize.width) / 2
      rect.origin.y = contentRect.midY - rect.height / 2
    case .Right:
      rect.origin.x = (contentRect.width - imageSize.width) / 2
      rect.origin.y = contentRect.midY - rect.height / 2
    case let .LeftOfText(spacing: spacing):
      rect.origin.x = (contentRect.midX - (titleSize.width + spacing + imageSize.width) / 2 + imageSize.width + spacing)
      rect.origin.y = contentRect.midY - rect.height / 2
    case let .RightOfText(spacing: spacing):
      rect.origin.x = (contentRect.midX - (titleSize.width + spacing + imageSize.width) / 2)
      rect.origin.y = contentRect.midY - rect.height / 2
    case let .AboveText(spacing: spacing):
      rect.origin.x = contentRect.midX - rect.width / 2
      rect.origin.y = (contentRect.midY - (titleSize.height + spacing + imageSize.height) / 2 + imageSize.height + spacing)
    }

    return rect
  }

  /// Updates the background color to reflect the current state.
  private func reflectStyle() {
    alpha = 1.0

    if selected {
      selectedStyle?.applyTo(self)
    } else if highlighted {
      highlightedStyle?.applyTo(self)
    } else if !enabled && !loading {
      alpha = 0.6
    } else {
      normalStyle?.applyTo(self)
    }
  }

}

/// Override for ForegroundStyleable and CornerStyleable.
extension PushButton {

  public override var style_foregroundColor: UIColor? {
    get { return foregroundColor }
    set { foregroundColor = newValue }
  }

  public override var style_font: UIFont? {
    get { return titleFont }
    set { titleFont = newValue }
  }

  public override var style_cornerRadius: CGFloat {
    get { return cornerRadius }
    set { cornerRadius = newValue }
  }

}

extension PushButton: InnerShadowStyleable {

  public var style_innerShadowColor: UIColor? {
    get { return innerShadowColor }
    set { innerShadowColor = newValue }
  }

  public var style_innerShadowOffset: CGSize {
    get { return innerShadowOffset }
    set { innerShadowOffset = newValue }
  }

  public var style_innerShadowRadius: CGFloat {
    get { return innerShadowRadius }
    set { innerShadowRadius = newValue }
  }

}