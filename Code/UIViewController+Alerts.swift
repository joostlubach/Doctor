import UIKit

public extension UIViewController {

  /// Displays a alert with a single cancel button.
  func displayAlert(title title: String?, message: String, cancelButtonTitle: String = "Cancel") -> AlertResult<NSObject> {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    controller.addAction(UIAlertAction(title: cancelButtonTitle, style: .Cancel, handler: nil))
    presentViewController(controller, animated: true, completion: nil)

    return AlertResult<NSObject>(alertController: controller)
  }

  /// Displays a prompt with multiple buttons. The result is returned as a future.
  ///
  /// - parameter title:
  ///   The title of the prompt.
  /// - parameter message:
  ///   The message of the prompt.
  /// - parameter actions:
  ///   The actions (buttons) to display. As keys, specify either a simple String, or a `.TitleAndStyle` enum value,
  ///   to also specify the style of the button. For values, specify any value (may be `Void`) for this action.
  /// - parameter completion:
  ///   An optional completion handler that is called with the result of the tapped action. You can also use the
  ///   returned future.
  /// - returns
  ///   A future that will resolve with the value of the action that was tapped.
  func displayPrompt<T: Hashable>(title title: String?, message: String, actions: [T: AlertAction]) -> AlertResult<T> {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    let result = AlertResult<T>(alertController: controller)

    for (actionResult, action) in actions {
      let handler: (UIAlertAction) -> Void = { _ in
        result.resolve(actionResult)
      }

      switch action {
      case let .Title(title):
        controller.addAction(UIAlertAction(title: title, style: .Default, handler: handler))
      case let .TitleAndStyle(title, style):
        controller.addAction(UIAlertAction(title: title, style: style, handler: handler))
      }
    }

    presentViewController(controller, animated: true, completion: nil)

    return result
  }

}

// MARK: - AlertResponse

public class AlertResult<T: Hashable> {

  init(alertController: UIAlertController) {
    self.alertController = alertController
  }

  /// Obtains the presented alert controller.
  public let alertController: UIAlertController

  /// A list of handlers by result value.
  private var handlers = Dictionary<T, () -> Void>()

  /// A list of overall completion handlers.
  private var completionHandlers = Array<() -> Void>()

  /// Assigns a handler to a specific response value.
  public func on(value: T, handler: () -> Void) {
    handlers[value] = handler
  }

  /// Assigns an overall completion handler.
  public func complete(handler: () -> Void) {
    completionHandlers.append(handler)
  }

  func resolve(value: T) {
    if let handler = handlers[value] {
      handler()
    }
    for handler in completionHandlers {
      handler()
    }
  }



}

// MARK: - AlertAction

public enum AlertAction {
  case Title(String)
  case TitleAndStyle(String, UIAlertActionStyle)
}

extension AlertAction: UnicodeScalarLiteralConvertible {
  public init(unicodeScalarLiteral value: String) {
    self = .Title(value)
  }
}

extension AlertAction: ExtendedGraphemeClusterLiteralConvertible {
  public init(extendedGraphemeClusterLiteral value: String) {
    self = .Title(value)
  }
}

extension AlertAction: StringLiteralConvertible {
  public init(stringLiteral value: String) {
    self = .Title(value)
  }
}
//
//extension AlertActionKey: Hashable {
//  public var hashValue: Int {
//    switch self {
//    case let .Title(title): return title.hashValue
//    case let .TitleAndStyle(title, style): return title.hashValue | style.hashValue
//    }
//  }
//}
//
//extension AlertActionKey: Equatable {}
//
//public func ==(lhs: AlertActionKey, rhs: AlertActionKey) -> Bool {
//  let lhsTitle: String
//  let rhsTitle: String
//  let lhsStyle: UIAlertActionStyle?
//  let rhsStyle: UIAlertActionStyle?
//
//  switch lhs {
//  case let .Title(title):
//    lhsTitle = title
//    lhsStyle = nil
//  case let .TitleAndStyle(title, style):
//    lhsTitle = title
//    lhsStyle = style
//  }
//
//  switch rhs {
//  case let .Title(title):
//    rhsTitle = title
//    rhsStyle = nil
//  case let .TitleAndStyle(title, style):
//    rhsTitle = title
//    rhsStyle = style
//  }
//
//  return lhsTitle == rhsTitle && lhsStyle == rhsStyle
//}