import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var box1:UIView!
    @IBOutlet weak var box2:UIView!
    @IBOutlet weak var box3:UIView!
    @IBOutlet weak var box4:UIView!
    
    let topGuide = UILayoutGuide()
    let centerGuide = UILayoutGuide()
    let bottomGuide = UILayoutGuide()
    
    
    // MARK: View Lifecycle
    // ====================================
    // View Lifecycle
    // ====================================
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.addLayoutGuide(topGuide)
        view.addLayoutGuide(centerGuide)
        view.addLayoutGuide(bottomGuide)
        
        view.addConstraint(box1.bottomAnchor.constraintEqualToAnchor(topGuide.topAnchor))
        
        view.addConstraint(box2.topAnchor.constraintEqualToAnchor(topGuide.bottomAnchor))
        view.addConstraint(box2.bottomAnchor.constraintEqualToAnchor(centerGuide.topAnchor))

        view.addConstraint(box3.topAnchor.constraintEqualToAnchor(centerGuide.bottomAnchor))
        view.addConstraint(box3.bottomAnchor.constraintEqualToAnchor(bottomGuide.topAnchor))
        
        view.addConstraint(box4.topAnchor.constraintEqualToAnchor(bottomGuide.bottomAnchor))
        
        view.addConstraint(topGuide.heightAnchor.constraintEqualToAnchor(centerGuide.heightAnchor))
        view.addConstraint(centerGuide.heightAnchor.constraintEqualToAnchor(bottomGuide.heightAnchor))
    }
}

