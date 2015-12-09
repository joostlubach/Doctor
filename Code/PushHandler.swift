import UIKit
import SwiftyJSON

public protocol PushHandler: class {

  /// Indicates whether this handler provides user interaction.
  var interactive: Bool { get }

  /// Indicates whether this handler should handle a given push notification. If `false` is returned, this handler is skipped.
  ///
  /// - parameter json:  The payload JSON of the push notification.
  /// - param applicationWasLaunched:   Specify `true` if the application was made active through the push notification.
  func shouldHandlePushWithJSON(json: JSON, applicationWasLaunched: Bool) -> Bool

  /// Handles the notification with the given payload as JSON. The interactive flag indicates whether the handler is allowed
  /// to provide user interaction.
  ///
  /// - parameter json:  The payload JSON of the push notification.
  /// - param applicationWasLaunched:   Specify `true` if the application was made active through the push notification.
  func handlePushWithJSON(json: JSON, applicationWasLaunched: Bool)

}