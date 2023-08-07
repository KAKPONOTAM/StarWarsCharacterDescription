import UIKit

extension UIImage {
    enum DefaultImages: String {
        case launchImage
        case favouriteImage
    }
}

extension UIImage {
    convenience init?(defaultImage: DefaultImages) {
        self.init(named: defaultImage.rawValue)
    }
}
