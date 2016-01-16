import Foundation

public extension String {

  /// Shortcut to `componentsSeparatorByString`.
  func splitWithSeparator(separator: String) -> [String] {
    return componentsSeparatedByString(separator)
  }

}