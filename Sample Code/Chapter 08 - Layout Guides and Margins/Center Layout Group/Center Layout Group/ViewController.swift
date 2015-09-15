import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var spinner:UIActivityIndicatorView! {
        didSet {
            spinner.startAnimating()
        }
    }
    
    let layoutContainer = UILayoutGuide()
    
    @IBOutlet weak var label:UILabel!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(layoutContainer.layoutFrame)
    }

    // MARK: View Lifecycle
    // ====================================
    // View Lifecycle
    // ====================================
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.addLayoutGuide(layoutContainer)
        
        spinner.topAnchor.constraintEqualToAnchor(layoutContainer.topAnchor).active = true
        label.lastBaselineAnchor.constraintEqualToAnchor(layoutContainer.bottomAnchor).active = true
        label.leadingAnchor.constraintEqualToAnchor(layoutContainer.leadingAnchor).active = true
        label.trailingAnchor.constraintEqualToAnchor(layoutContainer.trailingAnchor).active = true
        
        layoutContainer.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        layoutContainer.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true        
    }
}

