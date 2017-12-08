import UIKit

extension UIView {
    func usesAutoLayout(_ usesAutoLayout: Bool) {
        translatesAutoresizingMaskIntoConstraints = !usesAutoLayout
    }
}
