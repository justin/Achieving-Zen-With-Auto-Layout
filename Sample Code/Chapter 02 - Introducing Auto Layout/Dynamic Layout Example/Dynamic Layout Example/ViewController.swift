import UIKit

class ViewController: UIViewController
{
    lazy var centeredView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
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

        // Establishing the width to be half the view width
        self.view.addConstraint(centeredView.widthAnchor.constraintEqualToConstant(width))

        // Establishing the width to be 1/4 the view height
        self.view.addConstraint(centeredView.heightAnchor.constraintEqualToConstant(height))

        // We want our view to be centered horizontally.
        self.view.addConstraint(centeredView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor))

        // And vertically.
        self.view.addConstraint(centeredView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor))


        centeredView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: UILayoutConstraintAxis.Horizontal)
    }
}
