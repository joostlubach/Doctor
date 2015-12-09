import UIKit

/// A cache to store images by URL. Used by `RemoteImageView`.
class RemoteImageCache {

  /// The actual cache.
  private let cache = NSCache()

  /// Fetches an image for the given URL.
  func fetchImageForURL(url: NSURL) -> UIImage? {
    return cache.objectForKey(url) as? UIImage
  }

  /// Stores an image for the given URL.
  func storeImage(image: UIImage, forURL url: NSURL) {
    cache.setObject(image, forKey: url)
  }

}

