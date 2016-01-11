public protocol Emptyable {

  var empty: Bool { get }
  
}

extension String: Emptyable {
  public var empty: Bool {
    return self == ""
  }
}

extension Array: Emptyable {
  public var empty: Bool {
    return count == 0
  }
}

extension Dictionary: Emptyable {
  public var empty: Bool {
    return count == 0
  }
}

extension Optional where Wrapped: Emptyable {

  /// Determines whether the value is nil or 'empty'.
  var empty: Bool {
    if let value = self {
      return value.empty
    } else {
      return true
    }
  }

}

