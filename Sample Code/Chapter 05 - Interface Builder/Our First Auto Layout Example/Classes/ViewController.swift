import UIKit

final class ViewController: UIViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("self.view.constraints = \(view.constraints)")
    }
}
