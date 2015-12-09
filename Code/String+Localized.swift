import Foundation

public extension String {

  /// Retrieves a localized string. If extra arguments are passed, these are interpolated using formatting
  /// rules.
  ///
  /// - parameter key:        The localization key.
  /// - parameter arguments:  Optional interpolation arguments.
  static func localized(key: String, _ arguments: AnyObject?...) -> String {
    let format = NSLocalizedString(key, comment: "")

    if arguments.count > 0 {
      return String.format(format, arguments: arguments)
    } else {
      return format
    }
  }

  /// Retrieves a localized string. The given arguments are interpolated using formatting rules.
  ///
  /// - parameter key:        The localization key.
  /// - parameter arguments:  Interpolation arguments.
  static func localized(key: String, arguments: [AnyObject?]) -> String {
    let format = NSLocalizedString(key, comment: "")
    return String.format(format, arguments: arguments)
  }


}