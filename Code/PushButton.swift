import UIKit
import Tailor

/// A push button with loading indicator.
public class PushButton: Button {

  /// The space between the button icon and text.
  public var interSpacing: CGFloat = 8 {
    didSet {
      updateInterspacing()
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
      updateInterspacing()
    }
  }

  public override var enabled: Bool {
    didSet {
      reflectStyle()
      updateInterspacing()
    }
  }

  public override var selected: Bool {
    didSet {
      reflectStyle()
      updateInterspacing()
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

    updateInterspacing()
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    innerShadowView.fillSuperview()
    loadingView.fillSuperview()
  }

  public override func setImage(image: UIImage?, forState state: UIControlState) {
    super.setImage(image, forState: state)
    updateInterspacing()
  }

  public override func setTitle(title: String?, forState state: UIControlState) {
    super.setTitle(title, forState: state)
    updateInterspacing()
  }

  public override func sizeThatFits(size: CGSize) -> CGSize {
    var fittingSize = super.sizeThatFits(size)

    if imageForState(state) != nil && titleForState(state) != nil {
      fittingSize.width += interSpacing
    }
    return fittingSize
  }

  /// Updates the interspacing between the image and the text.
  private func updateInterspacing() {
    if imageForState(state) != nil && titleForState(state) != nil {
      imageEdgeInsets.left = -interSpacing / 2
      imageEdgeInsets.right = interSpacing / 2
      titleEdgeInsets.left = interSpacing / 2
      titleEdgeInsets.right = -interSpacing / 2
    } else {
      imageEdgeInsets.left = 0
      imageEdgeInsets.right = 0
      titleEdgeInsets.left = 0
      titleEdgeInsets.right = 0
    }
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