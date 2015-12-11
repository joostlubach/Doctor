import UIKit
import Tailor

class ModalActivityIndicatorView: ThemedView {

  init(activityIndicatorStyle: UIActivityIndicatorViewStyle) {
    activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: activityIndicatorStyle)
    super.init()
  }

  override init() {
    activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    super.init()
  }

  required init?(coder: NSCoder) {
    activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    super.init(coder: coder)
  }

  var edgeInsets = UIEdgeInsetsZero {
    didSet {
      setNeedsLayout()
    }
  }

  let activityIndicatorView: UIActivityIndicatorView

  override func setup() {
    addSubview(activityIndicatorView)
    activityIndicatorView.startAnimating()

    clipsToBounds = false
  }

  override func sizeThatFits(size: CGSize) -> CGSize {
    let indicatorSize = activityIndicatorView.sizeThatFits(size)

    return CGSize(
      width: indicatorSize.width + edgeInsets.left + edgeInsets.right,
      height: indicatorSize.height + edgeInsets.top + edgeInsets.bottom
    )
  }

  override func layoutSubviews() {
    activityIndicatorView.width = width - edgeInsets.left - edgeInsets.right
    activityIndicatorView.height = height - edgeInsets.top - edgeInsets.bottom

    activityIndicatorView.position.x = edgeInsets.left
    activityIndicatorView.position.y = edgeInsets.top
  }

  func animatePresent(completion: (Bool) -> Void) {
    transform = CGAffineTransformMakeScale(0.2, 0.2)
    alpha = 0

    UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2.0, options: [], animations: {
      self.transform = CGAffineTransformIdentity
      self.alpha = 1.0
    }, completion: completion)
  }

  func animateDismiss(completion: (Bool) -> Void) {
    UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2.0, options: [], animations: {
      self.transform = CGAffineTransformMakeScale(0.2, 0.2)
      self.alpha = 0.0
    }, completion: completion)
  }

}

extension ModalActivityIndicatorView: EdgeInsetsStyleable {
  var style_edgeInsets: UIEdgeInsets {
    get { return edgeInsets }
    set { edgeInsets = newValue }
  }
}

public struct ModalActivityIndicator {

  static let view = ModalActivityIndicatorView()

  private static var timer: NSTimer?

  public static var theme: Theme?

  public static func show() {
    guard view.superview == nil else {
      return
    }
    guard let appWindow = UIApplication.sharedApplication().keyWindow else {
      preconditionFailure("Unable to obtain key window for application.")
    }

    timer?.invalidate()
    timer = nil

    theme?.applyTo(view)
    appWindow.addSubview(view)
    view.sizeToFit()
    view.centerInSuperview()
    view.animatePresent { _ in }
  }

  public static func showAfter(interval: NSTimeInterval) {
    guard view.superview == nil else {
      return
    }

    timer?.invalidate()
    timer = Timer.after(interval, block: show)
  }

  public static func hide() {
    timer?.invalidate()
    timer = nil

    if view.superview != nil {
      view.animateDismiss { _ in
        view.removeFromSuperview()
      }
    }
  }

}