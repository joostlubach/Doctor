import Foundation

public extension NSDate {

  convenience init(iso8601String: String) throws {

    // Try without milliseconds, with time zone.
    if let timeInterval = tryParse(iso8601String, withFormat: "yyyy-MM-dd'T'HH:mm:ssZZZZZ") {
      self.init(timeIntervalSince1970: timeInterval)

    // Try with milliseconds, with time zone.
    } else if let timeInterval = tryParse(iso8601String, withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ") {
      self.init(timeIntervalSince1970: timeInterval)

    // Try without milliseconds, without time zone.
    } else if let timeInterval = tryParse(iso8601String, withFormat: "yyyy-MM-dd'T'HH:mm:ss") {
      self.init(timeIntervalSince1970: timeInterval)

    // Try with milliseconds, without time zone.
    } else if let timeInterval = tryParse(iso8601String, withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS") {
      self.init(timeIntervalSince1970: timeInterval)
    } else {
      throw ISO8601Error.InvalidFormat
    }
  }

  enum ISO8601Error: ErrorType {
    case InvalidFormat
  }

}

private func tryParse(string: String, withFormat format: String) -> NSTimeInterval? {
  let formatter = NSDateFormatter()
  formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
  formatter.dateFormat = format

  if let date = formatter.dateFromString(string) {
    return date.timeIntervalSince1970
  } else {
    return nil
  }
}