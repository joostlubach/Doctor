import UIKit

/// Draws an inner shadow int he given context, inside the current path in the given context.
///
/// - parameter context:   The context to draw the shadow into.
/// - parameter offset:    The shadow offset (x and y).
/// - parameter radius:    The shadow radius.
/// - parameter color:     The shadow color. The alpha component is respected here.
public func CGContextDrawInnerShadow(context: CGContext?, offset: CGSize, radius: CGFloat, color: CGColor) {
  // See http://blog.helftone.com/demystifying-inner-shadows-in-quartz/ for the trick.

  let path = CGContextCopyPath(context)
  let opaqueColor = CGColorCreateCopyWithAlpha(color, 1.0)

  CGContextClip(context)

  CGContextSetAlpha(context, CGColorGetAlpha(color))

  CGContextBeginTransparencyLayer(context, nil)

  CGContextSetShadowWithColor(context, offset, radius, opaqueColor)
  CGContextSetBlendMode(context, .SourceOut)
  CGContextSetFillColorWithColor(context, opaqueColor)

  CGContextAddPath(context, path)
  CGContextFillPath(context)

  CGContextEndTransparencyLayer(context)
}