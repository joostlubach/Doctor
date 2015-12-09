import Foundation
import SwiftyJSON

/// Push handling. When a push message comes in, this class handles it. At any time, handlers can be added that can handle a specific
/// kind of message, or all messages. All handlers are given the opportunity to handle the push message.
///
/// Handlers may be prepended or appended to the list. Handlers are processed in the order they are registered.
///
/// ### User interaction
///
/// Handlers can indicate whether they want to provide user interaction. The first handler to do so is given this opportunity. All
/// subsequent handlers are requested not to provide user interaction. They are however allowed to perform some background handling.
/// This makes sure that there is only one way the user is notified of the incoming message.
///
/// **Example**: the 'default' interaction is for a notification to appear at the top of the screen. However, there is a main list view
/// controller that wishes to present an alert to the user. In that case, the notification at the top of the screen is not necessary.
public struct PushHandling {

  // MARK: - Handler registration

  /// The currently registered push handlers.
  private static var handlers = [(PushHandler, String?)]()

  /// Prepends a handler, meaning that it is consulted before all other registered handlers. If this handler already exists, it is moved.
  ///
  /// - parameter handler:  The handler to register.
  public static func prependHandler(handler: PushHandler) {
    handlers = handlers.filter { $0.0 !== handler }
    handlers.insert((handler, nil), atIndex: 0)
  }

  /// Prepends a handler, meaning that it is consulted before all other registered handlers. If this handler already exists, it is moved.
  ///
  /// - parameter handler:  The handler to register.
  /// - parameter category: A category to register the handler in, so that it can be removed easily later on.
  public static func prependHandler(handler: PushHandler, inCategory category: String) {
    handlers = handlers.filter { $0.0 !== handler || $0.1 != category }
    handlers.insert((handler, category), atIndex: 0)
  }

  /// Appends a handler, meaning that it is consulted after all other registered handlers. If this handler already exists, it is moved.
  ///
  /// - parameter handler:  The handler to register.
  public static func appendHandler(handler: PushHandler) {
    handlers = handlers.filter { $0.0 !== handler }
    handlers.append((handler, nil))
  }

  /// Appends a handler, meaning that it is consulted after all other registered handlers. If this handler already exists, it is moved.
  ///
  /// - parameter handler:  The handler to register.
  /// - parameter category: A category to register the handler in, so that it can be removed easily later on.
  public static func appendHandler(handler: PushHandler, inCategory category: String) {
    handlers = handlers.filter { $0.0 !== handler || $0.1 != category }
    handlers.append((handler, category))
  }

  /// Removes a handler from the list.
  public static func removeHandler(handler: PushHandler) {
    handlers = handlers.filter { $0.0 !== handler }
  }

  /// Removes all handlers in a category from the list.
  public static func removeHandlersInCategory(category: String) {
    handlers = handlers.filter { $0.1 != category }
  }


  // MARK: - Handling

  /// Handles an incoming push notification with the given payload.
  ///
  /// - param applicationWasLaunched:   Specify `true` if the application was made active through the push notification.
  public static func handleNotificationWithPayload(payload: [NSObject: AnyObject], applicationWasLaunched: Bool) {
    let json = JSON(payload)
    var interactive = true

    for (handler, _) in handlers {
      if !handler.shouldHandlePushWithJSON(json, applicationWasLaunched: applicationWasLaunched) {
        continue
      }
      if !interactive && handler.interactive {
        // Don't handle this if we're not supposed to use an interactive handler, but the hander is interactive.
        continue
      }

      handler.handlePushWithJSON(json, applicationWasLaunched: applicationWasLaunched)
      if handler.interactive {
        // From now on, don't use interactive handlers anymore.
        interactive = false
      }
    }
  }

}