import UIKit

final class ViewController: UIViewController {
    lazy var centeredView: UIView = {
        let view = UIView(frame: CGRect.zero)
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

        // Centered horizontally and vertically
        let centeredX = round((viewFrame.width - width) / 2)
        let centeredY = round((viewFrame.height - height) / 2)
        centeredView.frame = CGRect(x: centeredX, y:centeredY, width: width, height: height)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let viewFrame = view.frame
        let width = round(viewFrame.width / 2)
        let height = round(viewFrame.height / 4)
        let centeredX = round((viewFrame.width - width) / 2)
        let centeredY = round((viewFrame.height - height) / 2)
        centeredView.frame = CGRect(x: centeredX, y:centeredY, width: width, height: height)
    }
}
