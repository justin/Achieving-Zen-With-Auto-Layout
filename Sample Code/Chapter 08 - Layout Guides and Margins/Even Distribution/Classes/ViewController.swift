import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var box1: UIView!
    @IBOutlet private weak var box2: UIView!
    @IBOutlet private weak var box3: UIView!
    @IBOutlet private weak var box4: UIView!
    
    private let topGuide = UILayoutGuide()
    private let centerGuide = UILayoutGuide()
    private let bottomGuide = UILayoutGuide()
    
    // MARK: View Lifecycle
    // ====================================
    // View Lifecycle
    // ====================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addLayoutGuide(topGuide)
        view.addLayoutGuide(centerGuide)
        view.addLayoutGuide(bottomGuide)
        
        view.addConstraint(box1.bottomAnchor.constraint(equalTo: topGuide.topAnchor))
        
        view.addConstraint(box2.topAnchor.constraint(equalTo: topGuide.bottomAnchor))
        view.addConstraint(box2.bottomAnchor.constraint(equalTo: centerGuide.topAnchor))

        view.addConstraint(box3.topAnchor.constraint(equalTo: centerGuide.bottomAnchor))
        view.addConstraint(box3.bottomAnchor.constraint(equalTo: bottomGuide.topAnchor))
        
        view.addConstraint(box4.topAnchor.constraint(equalTo: bottomGuide.bottomAnchor))
        
        view.addConstraint(topGuide.heightAnchor.constraint(equalTo: centerGuide.heightAnchor))
        view.addConstraint(centerGuide.heightAnchor.constraint(equalTo: bottomGuide.heightAnchor))
    }
}

