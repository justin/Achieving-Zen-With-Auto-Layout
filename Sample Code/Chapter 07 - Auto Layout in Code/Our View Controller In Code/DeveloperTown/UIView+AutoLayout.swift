import UIKit

extension UIView
{
    func usesAutoLayout(usesAutoLayout: Bool)
    {
        translatesAutoresizingMaskIntoConstraints = !usesAutoLayout
    }
}