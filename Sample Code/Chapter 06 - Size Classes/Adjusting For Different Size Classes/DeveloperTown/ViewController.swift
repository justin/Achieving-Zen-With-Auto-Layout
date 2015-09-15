import UIKit

class ViewController: UIViewController
{
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        print("self.view.constraints = \(self.view.constraints)")
    }

}

