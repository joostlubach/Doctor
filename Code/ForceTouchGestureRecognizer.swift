import UIKit.UIGestureRecognizerSubclass

@available(iOS 9.0, *)
public class ForceTouchGestureRecognizer: UIGestureRecognizer {

  public weak var forceTouchDelegate: ForceTouchGestureRecognizerDelegate?

  public var minimumForce: CGFloat = 0

  public var cancelsOtherRecognizersWhenBegan = true

  private(set) public var averageForce: CGFloat = 0 {
    didSet {
      forceTouchDelegate?.forceTouchRecognizer?(self, didUpdateAverageForce: averageForce)
    }
  }

  public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
    super.touchesBegan(touches, withEvent: event)
    checkForceForTouches(touches)
  }

  public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
    super.touchesMoved(touches, withEvent: event)
    checkForceForTouches(touches)
  }

  public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
    super.touchesEnded(touches, withEvent: event)
    state = .Ended
    averageForce = 0.0
  }

  public override func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent) {
    super.touchesCancelled(touches, withEvent: event)
    state = .Cancelled
    averageForce = 0.0
  }

  @available(iOS 9.1, *)
  public override func touchesEstimatedPropertiesUpdated(touches: Set<NSObject>) {
    super.touchesEstimatedPropertiesUpdated(touches)
    checkForceForTouches(touches as! Set<UITouch>)
  }

  private func checkForceForTouches(touches: Set<UITouch>) {
    averageForce = averageForceForTouches(touches)

    if (state == .Possible || state == .Ended) && averageForce >= minimumForce {
      if cancelsOtherRecognizersWhenBegan, let recognizers = self.view?.gestureRecognizers {
        for otherRecognizer in recognizers where otherRecognizer !== self {
          // 'Cancel' the other recognizers by disabling and enabling them.
          otherRecognizer.enabled = false
          otherRecognizer.enabled = true
        }
      }

      state = .Began
    }
    if state == .Began && averageForce < minimumForce {
      state = .Ended
    }
  }

}

@available(iOS 9.0, *)
private func averageForceForTouches(touches: Set<UITouch>) -> CGFloat {
  let total = touches.reduce(CGFloat(0)) { $0 + $1.force / $1.maximumPossibleForce }
  return total / CGFloat(touches.count)
}


@objc
@available(iOS 9.0, *)
public protocol ForceTouchGestureRecognizerDelegate {

  optional func forceTouchRecognizer(recognizer: ForceTouchGestureRecognizer, didUpdateAverageForce averageForce: CGFloat)

}