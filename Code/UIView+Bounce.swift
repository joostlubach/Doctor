import UIKit

public extension UIView {

  func bounce(scale scale: CGFloat = 1.2, duration: NSTimeInterval = 0.3) {
    layer.bounce(scale: scale, duration: duration)
  }


}

public extension CALayer {

  func bounce(scale scale: CGFloat, duration: CFTimeInterval) {
    let anim = CAKeyframeAnimation(keyPath: "transform.scale")
    anim.duration = duration
    anim.keyTimes = [0.0, 0.3, 1.0]
    anim.values = [1.0, scale, 1.0]
    anim.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)]
    addAnimation(anim, forKey: "pulsate")
  }

}