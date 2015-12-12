import Foundation

public extension Array {

  /// Returns a sample of this collection of the given type.
  func sample(size: Int) -> Array {
    var allIndices = [Int](indices)
    var sample = [Element]()

    srand(UInt32(NSDate().timeIntervalSinceReferenceDate))

    for _ in 0..<size {
      if allIndices.count > 0 {
        let index = Int(arc4random_uniform(UInt32(allIndices.count)))
        sample.append(self[allIndices.removeAtIndex(index)])
      }
    }

    return sample
  }

  /// Returns a random element from this collection.
  func sample() -> Array.Element {
    let index = Int(arc4random_uniform(UInt32(count)))
    return self[index]
  }

}