import Foundation

/// Swift native implementation of `String(format:arguments:)`, as the ObjC one is buggy!
public extension String {

  /// Formats a string using the given format and arguments. Works exactly like `String(format:arguments:)`.
  ///
  /// - parameter format:
  ///   The string format (using "%@" for interpolation placeholders).
  /// - parameter arguments:
  ///   Interpolation arguments.
  /// - returns
  ///   A formatted string.
  static func format(format: String, arguments: AnyObject?...) -> String {
    return String.format(format, arguments: arguments)
  }

  /// Formats a string using the given format and arguments. Works exactly like `String(format:arguments:)`.
  ///
  /// - parameter format:
  ///   The string format (using "%@" for interpolation placeholders).
  /// - parameter arguments:
  ///   Interpolation arguments.
  /// - returns
  ///   A formatted string.
  static func format(format: String, arguments: [AnyObject?]) -> String {
    let result = NSMutableString()

    // State variables.
    var escaped = false
    var percent = false
    var named = false

    var rangeStart = 0
    var rangeEnd = 0
    var argumentIndex = -1

    func interpolate() {
      let replacement: String
      if ++argumentIndex < arguments.count {
        replacement = arguments[argumentIndex]?.description ?? ""
      } else {
        replacement = ""
      }

      // Interpolate here.
      result.appendString(format[rangeStart..<rangeEnd])
      result.appendString(replacement)
    }

    for (i, char) in format.characters.enumerate() {
      if char == "{" && percent {
        rangeEnd = i - 1
        named = true
      }
      if char == "}" && named {
        interpolate()
        named = false
        rangeStart = i + 1
      }

      if char == "@" && percent {
        rangeEnd = i - 1
        interpolate()
        rangeStart = i + 1
      }

      percent = char == "%" && !escaped
      escaped = char == "\\" && !escaped
    }

    // Append the last bit and return the result.
    result.appendString(format[rangeStart..<format.characters.count])
    return result.copy() as! String
  }
  
}