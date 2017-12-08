import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var logoWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var logoCenterXConstraint: NSLayoutConstraint!
    
    // MARK: View Lifecycle
    // ====================================
    // View Lifecycle
    // ====================================

    override func viewDidLoad() {
        super.viewDidLoad()
        logoWidthConstraint.constant = 128
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("logoCenterXConstraint.active = \(logoCenterXConstraint.isActive)")
    }
}
