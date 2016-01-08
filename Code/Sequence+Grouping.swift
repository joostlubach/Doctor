import Foundation

public extension SequenceType {

  /// Groups elements in this sequence by the result of some block that is applied to all.
  /// The result is a dictionary.
  ///
  /// - parameter block:  A block that transforms each element into a key by which to group.
  /// - returns:          A dictionary of grouped arrays of elements of this sequence.
  ///
  /// ### Example
  ///
  /// Given an array of names (`String`):
  ///
  /// ```
  /// let names = ["John", "Joe", "Mary"]
  /// let namesByCharacterCount = names.groupBy { $0.characters.count }
  /// // => [3: ["Joe"], 4: ["John", "Mary"]]
  /// ```
  func groupIntoDictionary<T: Hashable>(block: (Self.Generator.Element) throws -> T) rethrows -> [T: [Self.Generator.Element]] {
    var result: [T: [Self.Generator.Element]] = [:]

    for element in self {
      let indexKey = try block(element)
      if result[indexKey] == nil {
        result[indexKey] = []
      }

      result[indexKey]!.append(element)
    }

    return result
  }

  /// Groups elements in this sequence by the result of some block that is applied to all.
  /// The result is an array of tuples, where the first element is the group key, and the
  /// second element is the array of elements in that group.
  ///
  /// - parameter block:  A block that transforms each element into a key by which to group.
  /// - returns:          A dictionary of grouped arrays of elements of this sequence.
  ///
  /// ### Example
  ///
  /// Given an array of names (`String`):
  ///
  /// ```
  /// let names = ["John", "Joe", "Mary"]
  /// let namesByCharacterCount = names.groupBy { $0.characters.count }
  /// // => [(3, ["Joe"]), (4, ["John", "Mary"])]
  /// ```
  func groupIntoTupleArray<T: Equatable>(block: (Self.Generator.Element) throws -> T) rethrows -> [(T, [Self.Generator.Element])] {
    var result: [(T, [Self.Generator.Element])] = []

    for element in self {
      let indexKey = try block(element)

      if let index = result.indexOf({ $0.0 == indexKey }) {
        result[index].1.append(element)
      } else {
        result.append((indexKey, [element]))
      }
    }

    return result
  }


}