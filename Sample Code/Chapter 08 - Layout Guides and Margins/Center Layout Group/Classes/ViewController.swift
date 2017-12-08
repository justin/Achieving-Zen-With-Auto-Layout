import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.startAnimating()
        }
    }
    
    @IBOutlet private weak var label: UILabel!
    
    private let layoutContainer = UILayoutGuide()
    
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
        
        spinner.topAnchor.constraint(equalTo: layoutContainer.topAnchor).isActive = true
        label.lastBaselineAnchor.constraint(equalTo: layoutContainer.bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: layoutContainer.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: layoutContainer.trailingAnchor).isActive = true
        
        layoutContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        layoutContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

