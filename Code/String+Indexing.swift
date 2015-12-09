import Foundation

public extension String {

  /// Obtains the character at the given integer index.
  subscript(int: Int) -> Character {
    let index = startIndex.advancedBy(int)
    return self[index]
  }

  /// Obtains the substring at the given integer index range.
  subscript(range: Range<Int>) -> String {
    let start = startIndex.advancedBy(range.startIndex)
    let end   = startIndex.advancedBy(range.endIndex)

    return self.substringWithRange(Range(start: start, end: end))
  }

}