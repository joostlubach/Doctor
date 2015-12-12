import UIKit

/// Adds a rounded rectangle to the current context.
public func CGContextAddRoundedRect(ctx: CGContext?, _ rect: CGRect, _ radius: CGFloat) {
  CGContextMoveToPoint(ctx, rect.midX, rect.minY)
  CGContextAddArcToPoint(ctx, rect.maxX, rect.minY, rect.maxX, rect.midY, radius)
  CGContextAddArcToPoint(ctx, rect.maxX, rect.maxY, rect.midX, rect.maxY, radius)
  CGContextAddArcToPoint(ctx, rect.minX, rect.maxY, rect.minX, rect.midY, radius)
  CGContextAddArcToPoint(ctx, rect.minX, rect.minY, rect.midX, rect.minY, radius)
  CGContextAddLineToPoint(ctx, rect.midX, rect.minY)
}

/// Fills a rounded rectangle in the current context.
public func CGContextFillRoundedRect(ctx: CGContext?, _ rect: CGRect, _ radius: CGFloat) {
  CGContextAddRoundedRect(ctx, rect, radius)
  CGContextFillPath(ctx)
}

/// Strokes a rounded rectangle in the current context.
public func CGContextStrokeRoundedRect(ctx: CGContext?, _ rect: CGRect, _ radius: CGFloat) {
  CGContextAddRoundedRect(ctx, rect, radius)
  CGContextStrokePath(ctx)
}