import Foundation

public extension SequenceType {

  /// Creates a tuple from this sequence. Useful in destructuring.
  func tuple() -> (Self.Generator.Element, Self.Generator.Element) {
    var first: Self.Generator.Element?
    var last: Self.Generator.Element?

    for (index, element) in self.enumerate() {
      if index == 0 {
        first = element
      }
      if index == 1 {
        last = element
        break
      }
    }

    precondition(first != nil && last != nil, "Sequence must contain at least two elements")
    return (first!, last!)
  }

}