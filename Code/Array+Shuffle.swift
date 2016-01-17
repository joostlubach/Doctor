import Foundation

public extension Array {

  /// Returns a new array with all elements from this array, but in random order.
  func shuffle() -> Array {
    return self.sort { _,_ in arc4random() % 2 == 0 }
  }

}