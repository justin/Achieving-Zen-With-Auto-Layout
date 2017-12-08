import UIKit

final class ViewController: UIViewController {
    lazy var centeredView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.orange
        return view
        }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: View Lifecycle
    // ====================================
    // View Lifecycle
    // ====================================
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(centeredView)

        // Setup the orange box.
        let viewFrame = view.bounds

        // Half the width of the view frame.
        let width = round(viewFrame.width / 2)

        // 1/4 the height of the view frame.
        let height = round(viewFrame.height / 4)

        // Establishing the width to be half the view width
        view.addConstraint(centeredView.widthAnchor.constraint(equalToConstant: width))

        // Establishing the width to be 1/4 the view height
        view.addConstraint(centeredView.heightAnchor.constraint(equalToConstant: height))

        // We want our view to be centered horizontally.
        view.addConstraint(centeredView.centerXAnchor.constraint(equalTo: view.centerXAnchor))

        // And vertically.
        view.addConstraint(centeredView.centerYAnchor.constraint(equalTo: view.centerYAnchor))

        centeredView.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
    }
}
