import UIKit

final class ViewController: UIViewController {
    private var imageView: UIImageView!
    private var emailLabel: UILabel!
    private var emailField: UITextField!
    private var passwordLabel: UILabel!
    private var passwordField: UITextField!
    private var signinButton: UIButton!
    
    // MARK: View Lifecycle
    // ====================================
    // View Lifecycle
    // ====================================
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = UIImageView()
        imageView.usesAutoLayout(true)
        imageView.backgroundColor = UIColor.red
        view.addSubview(imageView)
        
        emailLabel = UILabel()
        emailLabel.usesAutoLayout(true)
        emailLabel.text = NSLocalizedString("Email:", comment: "Email Label")
        view.addSubview(emailLabel)
        
        emailField = UITextField()
        emailField.usesAutoLayout(true)
        emailField.keyboardType = .emailAddress
        emailField.placeholder = "justin@autolayoutzen.com"
        view.addSubview(emailField)
        
        passwordLabel = UILabel()
        passwordLabel.usesAutoLayout(true)
        passwordLabel.text = NSLocalizedString("Password:", comment: "Password Label")
        view.addSubview(passwordLabel)
        
        passwordField = UITextField()
        passwordField.usesAutoLayout(true)
        passwordField.isSecureTextEntry = true
        view.addSubview(passwordField)
        
        signinButton = UIButton(type: .system)
        signinButton.usesAutoLayout(true)
        signinButton.setTitle(NSLocalizedString("Sign In", comment: "Sign In Button"), for: .normal)
        view.addSubview(signinButton)
        
        setupConstraints()
    }
    
    // MARK: Private/Convenience
    // ====================================
    // Private/Convenience
    // ====================================
    private func setupConstraints()
    {
        // Configuring our image view with single constraints
        let logoCenterXConstraint = NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        view.addConstraint(logoCenterXConstraint)
        
        let logoTopPadding = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 20.0)
        view.addConstraint(logoTopPadding)
        
        let logoWidth = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 96.0)
        view.addConstraint(logoWidth)

        let logoHeight = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 96.0)
        view.addConstraint(logoHeight)
        
        // We want to horizontally center our email field in its parent view.
        let emailFieldCenterXConstraint = emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        view.addConstraint(emailFieldCenterXConstraint)
        
        // Email label's leading edge should equal the leading edge of the email text field.
        let emailLeadingEdgeConstraint = emailLabel.leadingAnchor.constraint(equalTo: emailField.leadingAnchor)
        view.addConstraint(emailLeadingEdgeConstraint)
        
        // Email label's trailing edge should equal the trailing edge of the email text field.
        let emailTrailingEdgeConstraint = emailLabel.trailingAnchor.constraint(equalTo: emailField.trailingAnchor)
        view.addConstraint(emailTrailingEdgeConstraint)

        // The top of the text field should be 10 points from the bottom of the email label.
        let emailVerticalPaddingConstraint = emailLabel.bottomAnchor.constraint(equalTo: emailField.topAnchor, constant: 0.0)
        view.addConstraint(emailVerticalPaddingConstraint)

        // Email text field's width should be 200 points.
        let emailFieldWidthConstraint = emailField.widthAnchor.constraint(equalToConstant: 200)
        view.addConstraint(emailFieldWidthConstraint)
        
        let views: [String: Any] = [
            "logo" : imageView,
            "emailLabel" : emailLabel,
            "emailField" : emailField,
            "passwordLabel" : passwordLabel,
            "passwordField" : passwordField,
            "signinButton" : signinButton
        ]
        
        let verticalLogoConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[logo]-[emailLabel]", options: .alignAllCenterX, metrics: nil, views: views)
        view.addConstraints(verticalLogoConstraints)

        let verticalPasswordConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[emailField]-[passwordLabel][passwordField]-[signinButton]", options: .alignAllLeading, metrics: nil, views: views)
        view.addConstraints(verticalPasswordConstraints)

        let passwordWidthConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:[passwordField(==emailField)]", options: .alignAllCenterX, metrics: nil, views: views)
        view.addConstraints(passwordWidthConstraint)
        
        // We want to horizontally center our password field in its parent view.
        let passwordFieldCenterXConstraint = passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        view.addConstraint(passwordFieldCenterXConstraint)

    }
}

