import UIKit
import Tailor

/// Generic loading view. Shows an activity indicator in the center, which animates when the view is shown.
public class LoadingView: ContainerView {

  public init(activityIndicatorStyle: UIActivityIndicatorViewStyle = .Gray) {
    activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: activityIndicatorStyle)
    super.init()
  }
  public required init?(coder: NSCoder) {
    activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    super.init(coder: coder)
  }

  public let activityIndicator: UIActivityIndicatorView

  public override var hidden: Bool {
    didSet {
      if hidden {
        activityIndicator.stopAnimating()
      } else {
        activityIndicator.startAnimating()
      }
    }
  }

  public override func setup() {
    addSubview(activityIndicator)
    activityIndicator.hidesWhenStopped = false
    activityIndicator.startAnimating()
  }

  public override func layoutSubviews() {
    activityIndicator.sizeToFit()
    activityIndicator.centerInSuperview()
  }
  
}
