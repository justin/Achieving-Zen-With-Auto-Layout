import UIKit

class ViewController: UIViewController
{
    lazy var centeredView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.orangeColor()
        return view
    }()

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .LightContent
    }

    // MARK: View Lifecycle
    // ====================================
    // View Lifecycle
    // ====================================
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.view.addSubview(centeredView)

        // Setup the orange box.
        let viewFrame = self.view.bounds

        // Half the width of the view frame.
        let width = round(CGRectGetWidth(viewFrame) / 2)

        // 1/4 the height of the view frame.
        let height = round(CGRectGetHeight(viewFrame) / 4)

        // Centered horizontally and vertically
        let centeredX = round((CGRectGetWidth(viewFrame) - width) / 2)
        let centeredY = round((CGRectGetHeight(viewFrame) - height) / 2)
        self.centeredView.frame = CGRectMake(centeredX, centeredY, width, height)
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        let viewFrame = self.view.frame
        let width = round(CGRectGetWidth(viewFrame) / 2)
        let height = round(CGRectGetHeight(viewFrame) / 4)
        let centeredX = round((CGRectGetWidth(viewFrame) - width) / 2)
        let centeredY = round((CGRectGetHeight(viewFrame) - height) / 2)

        self.centeredView.frame = CGRectMake(centeredX, centeredY, width, height)
    }
}
