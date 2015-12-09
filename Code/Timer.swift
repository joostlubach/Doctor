import Foundation

/// Static utility interface to create timer objects.
public struct Timer {

  /// Executes the given block after the given number of seconds.
  public static func after(seconds: NSTimeInterval, block: TimerBlock) -> NSTimer {
    let target = TimerTarget(block: block)
    return NSTimer.scheduledTimerWithTimeInterval(seconds, target: target, selector: "fire", userInfo: nil, repeats: false)
  }

  /// Executes the given block every given number of seconds.
  public static func every(seconds: NSTimeInterval, block: TimerBlock) -> NSTimer {
    let target = TimerTarget(block: block)
    return NSTimer.scheduledTimerWithTimeInterval(seconds, target: target, selector: "fire", userInfo: nil, repeats: true)
  }
  
}

public typealias TimerBlock = (Void) -> Void

private class TimerTarget {

  init(block: TimerBlock) {
    self.block = block
  }

  let block: TimerBlock

  dynamic func fire() {
    block()
  }
  
}
