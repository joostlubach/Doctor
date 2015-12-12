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