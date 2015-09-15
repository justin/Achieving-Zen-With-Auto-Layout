import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var greenBox:UIView! {
        didSet {
            greenBox.layoutMargins = UIEdgeInsetsMake(10, 10, 10, 10)
        }
    }
    @IBOutlet weak var redBox:UIView!
}

