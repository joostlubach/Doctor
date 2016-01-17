import Foundation

public extension SequenceType {

  /// Determines whether all elements in this sequence match the given predicate.
  func all(@noescape predicate: (Self.Generator.Element) throws -> Bool) rethrows -> Bool {
    for element in self {
      if try !predicate(element) {
        return false
      }
    }

    return true
  }

  /// Determines whether any element in this sequence matches the given predicate.
  func any(@noescape predicate: (Self.Generator.Element) throws -> Bool) rethrows -> Bool {
    for element in self {
      if try predicate(element) {
        return true
      }
    }

    return false
  }

  /// Determines whether none of the elements in this sequence match the given predicate.
  func none(@noescape predicate: (Self.Generator.Element) throws -> Bool) rethrows -> Bool {
    return try !any(predicate)
  }

  /// Finds the first element in this sequence matching the given predicate.
  func findFirst(@noescape predicate: (Self.Generator.Element) throws -> Bool) rethrows -> Self.Generator.Element? {
    for element in self {
      if try predicate(element) {
        return element
      }
    }

    return nil
  }

  /// Finds the first element in this sequence matching the given predicate.
  func findLast(@noescape predicate: (Self.Generator.Element) throws -> Bool) rethrows -> Self.Generator.Element? {
    for element in self.reverse() {
      if try predicate(element) {
        return element
      }
    }

    return nil
  }

}


extension CollectionType where Self.Index.Distance == Int {

  /// Finds the first index in this sequence matching the given predicate.
  func findIndex(predicate: (Self.Generator.Element) throws -> Bool) rethrows -> Self.Index? {
    for (i, element) in enumerate() {
      if try predicate(element) {
        return startIndex.advancedBy(i)
      }
    }

    return nil
  }

  /// Finds the last index in this sequence matching the given predicate.
  func findLastIndex(predicate: (Self.Generator.Element) throws -> Bool) rethrows -> Self.Index? {
    for (i, element) in reverse().enumerate() {
      if try predicate(element) {
        return endIndex.advancedBy(-i)
      }
    }

    return nil
  }

}