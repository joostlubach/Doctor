import UIKit
import UIKit.UIGestureRecognizerSubclass

public class ThresholdedPanGestureRecognizer: UIPanGestureRecognizer {

  public var minimumDistance: CGSize = CGSize(width: 4, height: 4)

  private var firstPoint: CGPoint?

  public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
    if state >= .Began {
      return
    }

    super.touchesBegan(touches, withEvent: event)
    if let touch = touches.first, let view = self.view {
      firstPoint = touch.locationInView(view)
    }
  }

  public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
    super.touchesMoved(touches, withEvent: event)
    if state >= .Began {
      return
    }

    if let touch = touches.first, let view = self.view, let firstPoint = self.firstPoint {
      let point = touch.locationInView(view)

      if abs(firstPoint.x - point.x) > minimumDistance.width || abs(firstPoint.y - point.y) > minimumDistance.height {
        state = .Began
      }
    }

  }

  public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
    firstPoint = nil
    super.touchesEnded(touches, withEvent: event)
  }
  
}