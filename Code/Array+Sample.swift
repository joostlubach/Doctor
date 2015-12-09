import Foundation

public extension Array {

  /// Returns a sample of this collection of the given type.
  func sample(size: Int) -> Array {
    var allIndices = [Int](indices)
    var sample = [Element]()

    for _ in 0..<size {
      if let index = allIndices.popLast() {
        sample.append(self[index])
      }
    }

    return sample
  }

  /// Returns a random element from this collection.
  func sample() -> Array.Element {
    let index = random() % count
    return self[index]
  }

}