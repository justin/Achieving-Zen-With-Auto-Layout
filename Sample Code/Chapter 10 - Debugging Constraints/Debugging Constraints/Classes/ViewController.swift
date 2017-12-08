import UIKit

final class ViewController: UIViewController {

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("view.constraints = \(view.constraints)")
        if let constraint = view.constraints.first {
            print("HI")
        }
    }
}

