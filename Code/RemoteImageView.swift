import UIKit
import BrightFutures

/// An image view that supports loading its image from a remote URL. A placeholder image can be used for when
/// the image view is loading or when a remote image was not loaded.
public class RemoteImageView: UIImageView {

  // MARK: - Types

  public enum Error: ErrorType {
    case DownloadError(NSError)
    case InvalidData
  }

  // MARK: - Initialization

  public init() {
    super.init(frame: CGRectZero)
    setup()
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  public init(url: NSURL?) {
    super.init(frame: CGRectZero)
    setup()

    imageURL = url
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  // MARK: Properties

  /// A delegate which is informed when the download failed or completed.
  weak var delegate: RemoteImageViewDelegate?

  /// The URL of the remote image. This is `nil` if the image view does not contain a remote image.
  public var imageURL: NSURL? {
    didSet {
      if imageURL != oldValue {
        update()
      }
    }
  }

  /// Sets an image to use for a placeholder while loading or when the image is not set.
  public var placeholderImage: UIImage? {
    didSet {
      updatePlaceholder()
    }
  }

  /// Set to true to show a loading indicator while loading.
  public var showsIndicatorWhileLoading = false {
    didSet {
      updateLoading()
    }
  }

  /// Set to false to prevent using the image cache.
  public var cacheImages = true

  /// Keeps track of the last request, to make sure only the last request is handled.
  private var lastRequest: NSURLRequest?

  /// Whether the image view is currently loading.
  private var loading = false {
    didSet {
      updateLoading()
    }
  }

  /// The loading indicator view that is displayed while loading.
  public let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)

  // MARK: - Set up & layout

  public func setup() {
    addSubview(indicatorView)
  }

  override public func layoutSubviews() {
    super.layoutSubviews()

    indicatorView.sizeToFit()
    indicatorView.centerInSuperview()
  }


  // MARK: - Interface

  /// Sets the image, specifying from which URL it came.
  public func setImage(image: UIImage, fromURL url: NSURL) {
    self.imageURL = url
    self.image = image

    if cacheImages {
      Cache.storeImage(image, forURL: url)
    }
  }

  /// Preloads and caches the image for the given URL.
  public static func preloadImageFromURL(url: NSURL) -> Future<UIImage, Error> {
    let request = NSURLRequest(URL: url)
    let promise = Promise<UIImage, Error>()

    NSURLConnection.sendAsynchronousRequest(request, queue: SharedLoadQueue) { response, dataOrNil, errorOrNil in
      if let error = errorOrNil {
        promise.failure(Error.DownloadError(error))
      } else if let data = dataOrNil, let image = UIImage(data: data) {
        Cache.storeImage(image, forURL: url)
        promise.success(image)
      } else {
        promise.failure(Error.InvalidData)
      }
    }

    return promise.future
  }


  // MARK: - Private

  private func update() {
    // 'Unset' the image by restoring the placeholder image while loading.
    image = placeholderImage

    if let url = imageURL {
      if let cachedImage = Cache.fetchImageForURL(url) {
        // Load the image from a cache.
        image = cachedImage
      } else {
        // Load the remote image from the current URL.
        downloadImageFromURL(url)
      }
    }
  }

  /// Downloads the image from the given URL.
  private func downloadImageFromURL(url: NSURL) {
    let request = NSURLRequest(URL: url)
    lastRequest = request

    loading = true

    if showsIndicatorWhileLoading {
      addSubview(indicatorView)
      indicatorView.frame = bounds
      indicatorView.startAnimating()
    }

    NSURLConnection.sendAsynchronousRequest(request, queue: SharedLoadQueue) { [weak self] response, data, error in
      Queue.main.async {
        self?.request(request, completedWithResponse: response, data: data, error: error)
      }
    }
  }

  private func request(request: NSURLRequest, completedWithResponse response: NSURLResponse?, data: NSData?, error: NSError?) {
    // Make sure only to process the last request.
    if lastRequest !== request {
      return
    }

    let url = request.URL!

    if let err = error {
      // Error loading data.
      delegate?.remoteImageView(self, didFailLoadingImageFromURL: url, withError: .DownloadError(err))
    } else if let d = data, let image = UIImage(data: d) {
      // OK.
      setImage(image, fromURL: url)
      delegate?.remoteImageView(self, didFinishLoadingImage: image, fromURL: url)
    } else {
      // Data could not be converted into an image.
      delegate?.remoteImageView(self, didFailLoadingImageFromURL: url, withError: .InvalidData)
    }

    loading = false
  }

  private func updatePlaceholder() {
    if image == nil {
      image = placeholderImage
    }
  }

  private func updateLoading() {
    let shouldShow = showsIndicatorWhileLoading && loading
    if shouldShow != indicatorView.hidden {
      return
    }

    if shouldShow {
      indicatorView.startAnimating()
    } else {
      indicatorView.stopAnimating()
    }
  }

}

protocol RemoteImageViewDelegate: class {

  /// The remote image view has finished loading an image from the given URL.
  func remoteImageView(remoteImageView: RemoteImageView, didFinishLoadingImage image: UIImage, fromURL url: NSURL)

  /// The remote image view failed loading an image from the given URL.
  func remoteImageView(remoteImageView: RemoteImageView, didFailLoadingImageFromURL url: NSURL, withError error: RemoteImageView.Error)

}

/// A shared load queue for the images.
private let SharedLoadQueue = NSOperationQueue()

/// A cache to hold images by URL.
private var Cache = RemoteImageCache()