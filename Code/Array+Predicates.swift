import Foundation

public extension Array {

  /// Removes elements matching the predicate, and returns those element.
  ///
  /// - parameter predicate:
  ///   A predicate block to check each element. Return `true` to have this element removed.
  /// - returns:            
  ///   The removed elements.
  mutating func reject(predicate: (Generator.Element) -> Bool) -> [Generator.Element] {
    var result = Array<Generator.Element>()
    var indices = Array<Int>()

    for (index, element) in self.enumerate() {
      if predicate(element) {
        result.append(element)
        indices.append(index)
      }
    }

    for index in indices.reverse() {
      removeAtIndex(index)
    }

    return result
  }

}