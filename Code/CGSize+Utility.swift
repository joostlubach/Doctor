import UIKit

public extension CGSize {

  /// Expands this size by an offset.
  func expand(offset: CGSize) -> CGSize {
    return CGSize(
      width: width + offset.width,
      height: height + offset.height
    )
  }

  /// Expands this size by an offset in both directions.
  func expand(offset: CGFloat) -> CGSize {
    return CGSize(
      width: width + offset,
      height: height + offset
    )
  }

  /// Contracts this size by an offset.
  func contract(offset: CGSize) -> CGSize {
    return CGSize(
      width: width - offset.width,
      height: height - offset.height
    )
  }

  /// Contracts this size by an offset in both directions.
  func contract(offset: CGFloat) -> CGSize {
    return CGSize(
      width: width - offset,
      height: height - offset
    )
  }

}

// MARK: - Operators

func +(lhs: CGSize, rhs: CGSize) -> CGSize {
  return lhs.expand(rhs)
}

func +=(inout lhs: CGSize, rhs: CGSize) -> CGSize {
  lhs = lhs + rhs
  return lhs
}

func -(lhs: CGSize, rhs: CGSize) -> CGSize {
  return lhs.contract(rhs)
}

func -=(inout lhs: CGSize, rhs: CGSize) -> CGSize {
  lhs = lhs - rhs
  return lhs
}