import Foundation
import SwiftyJSON

public extension NSDate {

  convenience init?(json: JSON) throws {
    if json.type == .Null {
      return nil
    }

    if let string = json.string {
      try self.init(iso8601String: string)
    } else if let double = json.double {
      self.init(timeIntervalSince1970: double)
    } else {
      throw JSONError.InvalidType
    }
  }

  enum JSONError: ErrorType {
    case InvalidType
  }

}