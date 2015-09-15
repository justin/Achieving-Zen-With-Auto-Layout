import UIKit

class ViewController: UIViewController
{
    var centeredView:UIView! {
        didSet {
            centeredView.translatesAutoresizingMaskIntoConstraints = false
            centeredView.backgroundColor = UIColor.orangeColor()
        }
    }
    var button:UIButton! {
        didSet {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Toggle", forState: .Normal)
            button.addTarget(self, action: "toggle:", forControlEvents: .TouchUpInside)
        }
    }
    
    var centerWidthConstraint:NSLayoutConstraint!
    var centerHeightConstraint:NSLayoutConstraint!
    
    var zoomed:Bool = false

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    // MARK: View Lifecycle
    // ====================================
    // View Lifecycle
    // ====================================
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        centeredView = UIView(frame: CGRectZero)
        view.addSubview(centeredView)
        
        button = UIButton(type: .System)
        view.addSubview(button)
        
        // Establishing the width to be half the view width
        centerWidthConstraint = NSLayoutConstraint(item: centeredView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.5, constant: 0.0)
        view.addConstraint(centerWidthConstraint)
        
        // Establishing the height to be 25% of the view height
        centerHeightConstraint = NSLayoutConstraint(item: centeredView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.25, constant: 0.0)
        view.addConstraint(centerHeightConstraint)

        // We want our view to be centered horizontally
        centeredView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        
        // We want our view to be centered vertically
        centeredView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        
        let views = [
            "button" : button
        ]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[button]-|", options: .AlignAllRight, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[button]-|", options: .AlignAllLastBaseline, metrics: nil, views: views))
        
    }
    
    func toggle(sender: UIButton!)
    {
        var constant:CGFloat = 0.0
        if zoomed == false
        {
            constant = 100.0
        }
        
        centerWidthConstraint.constant = constant
        centerHeightConstraint.constant = constant

        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { (finished) -> Void in
            self.zoomed = !self.zoomed
        }
    }
}

