import Foundation

public extension Comparable {

  func clamp(min: Self, _ max: Self) -> Self {
    if self < min {
      return min
    } else if self > max {
      return max
    } else {
      return self
    }
  }

}