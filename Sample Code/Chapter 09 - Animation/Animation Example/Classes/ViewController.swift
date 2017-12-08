import UIKit

final class ViewController: UIViewController {
    private var centeredView: UIView! {
        didSet {
            centeredView.translatesAutoresizingMaskIntoConstraints = false
            centeredView.backgroundColor = UIColor.orange
        }
    }
    private var button: UIButton! {
        didSet {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Toggle", for: .normal)
            button.addTarget(self, action: #selector(toggle(_:)), for: .touchUpInside)
        }
    }
    
    private var centerWidthConstraint: NSLayoutConstraint!
    private var centerHeightConstraint: NSLayoutConstraint!
    
    private var isZoomed: Bool = false
    
    // MARK: View Lifecycle
    // ====================================
    // View Lifecycle
    // ====================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centeredView = UIView(frame: .zero)
        view.addSubview(centeredView)
        
        button = UIButton(type: .system)
        view.addSubview(button)
        
        // Establishing the width to be half the view width
        centerWidthConstraint = NSLayoutConstraint(item: centeredView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.5, constant: 0.0)
        view.addConstraint(centerWidthConstraint)
        
        // Establishing the height to be 25% of the view height
        centerHeightConstraint = NSLayoutConstraint(item: centeredView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.25, constant: 0.0)
        view.addConstraint(centerHeightConstraint)

        // We want our view to be centered horizontally
        centeredView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // We want our view to be centered vertically
        centeredView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let views: [String: Any] = [
            "button" : button
        ]
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[button]-|", options: .alignAllRight, metrics: nil, views: views))
        
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc private func toggle(_ sender: UIButton)
    {
        var constant: CGFloat = 0.0
        if isZoomed == false {
            constant = 100.0
        }
        
        centerWidthConstraint.constant = constant
        centerHeightConstraint.constant = constant

        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
            }) { _ in
            self.isZoomed = !self.isZoomed
        }
    }
}

