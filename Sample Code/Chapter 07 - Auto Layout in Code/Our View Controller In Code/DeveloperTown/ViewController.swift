import UIKit

class ViewController: UIViewController
{
    var imageView:UIImageView!
    var emailLabel:UILabel!
    var emailField:UITextField!
    var passwordLabel:UILabel!
    var passwordField:UITextField!
    var signinButton:UIButton!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
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
        imageView = UIImageView()
        imageView.usesAutoLayout(true)
        imageView.backgroundColor = UIColor.redColor()
        view.addSubview(imageView)
        
        emailLabel = UILabel()
        emailLabel.usesAutoLayout(true)
        emailLabel.text = NSLocalizedString("Email:", comment: "Email Label")
        view.addSubview(emailLabel)
        
        emailField = UITextField()
        emailField.usesAutoLayout(true)
        emailField.keyboardType = .EmailAddress
        emailField.placeholder = "justin@autolayoutzen.com"
        view.addSubview(emailField)
        
        passwordLabel = UILabel()
        passwordLabel.usesAutoLayout(true)
        passwordLabel.text = NSLocalizedString("Password:", comment: "Password Label")
        view.addSubview(passwordLabel)
        
        passwordField = UITextField()
        passwordField.usesAutoLayout(true)
        passwordField.secureTextEntry = true
        view.addSubview(passwordField)
        
        signinButton = UIButton(type: .System)
        signinButton.usesAutoLayout(true)
        signinButton.setTitle(NSLocalizedString("Sign In", comment: "Sign In Button"), forState: .Normal)
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
        let logoCenterXConstraint = NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        view.addConstraint(logoCenterXConstraint)
        
        let logoTopPadding = NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 20.0)
        view.addConstraint(logoTopPadding)
        
        let logoWidth = NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 96.0)
        view.addConstraint(logoWidth)

        let logoHeight = NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 96.0)
        view.addConstraint(logoHeight)
        
        // We want to horizontally center our email field in its parent view.
        let emailFieldCenterXConstraint = emailField.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
        view.addConstraint(emailFieldCenterXConstraint)
        
        // Email label's leading edge should equal the leading edge of the email text field.
        let emailLeadingEdgeConstraint = emailLabel.leadingAnchor.constraintEqualToAnchor(emailField.leadingAnchor)
        view.addConstraint(emailLeadingEdgeConstraint)
        
        // Email label's trailing edge should equal the trailing edge of the email text field.
        let emailTrailingEdgeConstraint = emailLabel.trailingAnchor.constraintEqualToAnchor(emailField.trailingAnchor)
        view.addConstraint(emailTrailingEdgeConstraint)

        // The top of the text field should be 10 points from the bottom of the email label.
        let emailVerticalPaddingConstraint = emailLabel.bottomAnchor.constraintEqualToAnchor(emailField.topAnchor, constant: 0.0)
        view.addConstraint(emailVerticalPaddingConstraint)

        // Email text field's width should be 200 points.
        let emailFieldWidthConstraint = emailField.widthAnchor.constraintEqualToConstant(200)
        view.addConstraint(emailFieldWidthConstraint)
        
        let views = [
            "logo" : imageView,
            "emailLabel" : emailLabel,
            "emailField" : emailField,
            "passwordLabel" : passwordLabel,
            "passwordField" : passwordField,
            "signinButton" : signinButton
        ]
        
        let verticalLogoConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[logo]-[emailLabel]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: views)
        view.addConstraints(verticalLogoConstraints)

        let verticalPasswordConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[emailField]-[passwordLabel][passwordField]-[signinButton]", options: .AlignAllLeading, metrics: nil, views: views)
        view.addConstraints(verticalPasswordConstraints)

        let passwordWidthConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:[passwordField(==emailField)]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: views)
        view.addConstraints(passwordWidthConstraint)
        
        // We want to horizontally center our password field in its parent view.
        let passwordFieldCenterXConstraint = passwordField.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
        view.addConstraint(passwordFieldCenterXConstraint)

    }
}

