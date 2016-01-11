import Foundation

extension String {

  /// Shortcut to `componentsSeparatorByString`.
  func split(separator: String) -> [String] {
    return componentsSeparatedByString(separator)
  }

}