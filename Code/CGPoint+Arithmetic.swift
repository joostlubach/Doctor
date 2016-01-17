import UIKit

public func +(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

public func -(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

public func +=(inout left: CGPoint, right: CGPoint) -> CGPoint {
  left = left + right
  return left
}

public func -=(inout left: CGPoint, right: CGPoint) -> CGPoint {
  left = left - right
  return left
}

public extension CGPoint {

  /// Creates a point that is directly between this point and the given other point, at the given factor.
  /// A factor 0.5 will give the point exactly halfway, a factor of 0.25 will give a point that's a quarter
  /// the way to the other point.
  func pointCloserTo(otherPoint: CGPoint, at: CGFloat) -> CGPoint {
    return CGPoint(
      x: x * (1 - at) + otherPoint.x * at,
      y: y * (1 - at) + otherPoint.y * at
    )
  }

}