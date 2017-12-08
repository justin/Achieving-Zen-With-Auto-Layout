import UIKit

final class ViewController: UIViewController
{
    @IBOutlet private weak var greenBox: UIView! {
        didSet {
            greenBox.layoutMargins = UIEdgeInsetsMake(10, 10, 10, 10)
        }
    }
    @IBOutlet private weak var redBox: UIView!
}

