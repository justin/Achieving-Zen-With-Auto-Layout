Chapter 07 - Using Auto Layout In Code
====================================

### Constraint References

Throughout this book, I have tried to pound into your head that Interface Builder is the best way to interact with and use Auto Layout. It's a visual way to see how your constraints render on screen, it works well with size classes on iOS, and it helps you quickly find and diagnose ambiguity and missing constraints in your layouts without having to go through an entire app compilation.

There are still times, however, when we need to either work with existing constraints or add new constraints in code. If you are planning to animate any of the constraints you create in Interface Builder, for instance, having a reference to that constraint in your view controller code makes a lot of sense. We'll cover animation in chapter 9, but for now, let's focus on creating a reference to one of our constraints from Interface Builder.

Let's go back to our DeveloperTown sample project. Open the `ViewController.swift` file and add the following snippet of code to it.

~~~swift
class ViewController: UIViewController
{
  @IBOutlet weak var logoWidthConstraint: NSLayoutConstraint!
}
~~~

Seasoned developers should understand what most of this means, but we will walk through it for the sake of thoroughness. We are creating an `@IBOutlet` that will host a reference to our logo's width constraint in our storyboard scene. We are marking it as `weak`, since it is being pulled from Interface Builder. We're also setting it as an explicitly unwrapped optional with the exclamation point at the end, since we guarantee that it will be connected by the time we interact with it in code.

Now, let's connect it to the actual constraint in our storyboard. Open the "Main.storyboard" file and expose the constraints attached to our image view. If you remember from a few chapters ago, we set an explicit width constraint saying the view should always be 96 points and have a 1:1 aspect ratio so that the height and width always match.

![Constraint Relationships](./images/ch07-ss01.png)

Next, connect that width constraint to our `@IBOutlet` Hold down the Control key and click and drag from our View Controller object to the width constraint. You should get a black semi-transparent overlay that lists our `logoWidthConstraint` as an option. Click on it. If things are connected properly, the constraint should be renamed in Interface Builder to "Logo Width Constraint."

Let's go back to our `ViewController.swift` file and put a bit of code in to check the value of our constraint when we run our application.

~~~swift
override func viewDidLayoutSubviews()
{
    super.viewDidLayoutSubviews()
    print("logoWidthConstraint = \(logoWidthConstraint)")
}
~~~

All we are doing here is adding a `print()` statement that will print out the value of our constraint whenever we lay out the view on screen. Build and run the application. In the Console, you should see the printed value of our `logoWidthConstraint`, assuming you connected everything together.

    logoWidthConstraint =
      <NSLayoutConstraint:0x7fdaebca48b0 H:[UIImageView:0x7fdaebca6000(96)]>

What if we decide we want to change the size of the logo constraint? We should probably be doing that in Interface Builder because we are adjusting the constant value, but for the sake of this exercise, let's do it in code. Override `viewDidLoad()` in your view controller and add the following snippet of code:

~~~swift
override func viewDidLoad()
{
    super.viewDidLoad()
    logoWidthConstraint.constant = 128
}
~~~

When you build and run the application, you'll see that the logo is now bigger than what we defined in our storyboard.

### Active and Inactive Constraints

 The one thing about our logo width constraint is that it is always active, regardless of what our trait collection is. What about holding a reference to a constraint that is only active in certain scenarios, such as when the device is rotated to the landscape orientation? Let's test that out and see what happens. Go ahead and add another `@IBOutlet` to your class.

~~~swift
class ViewController: UIViewController
{
  @IBOutlet weak var logoWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var logoCenterXConstraint: NSLayoutConstraint!
}
~~~

This time we are adding a reference to our logo's center X constraint, which keeps the logo centered horizontally when we are viewing the app in portrait mode.

Jump back into Interface Builder and make a connection to the "Image View.centerX = centerX" constraint from our View Controller object so that it is attached to the new `logoCenterXConstraint` object. Next, let's go back to our override of `viewDidLayoutSubviews()` and change its implementation to tell us the constraint's activation status.

~~~swift
override func viewDidLayoutSubviews()
{
  super.viewDidLayoutSubviews()
  print("logoCenterXConstraint.active = \(logoCenterXConstraint.active)")
}
~~~

Build and run your application now. Try rotating the device between portrait and landscape orientations. You should see in the debugging console that the constraint's active state changes between rotations.

### Creating Constraints in Code

Keeping references to the constraints we have created in a storyboard or XIB is only part of the equation. To really see how we can make Auto Layout work in our source code, let's recreate our DeveloperTown sign-in screen from previous chapters in code.

To get started, open Xcode and create a new "Single View Application" project. Name the product DeveloperTown again, set the organization name and identifier to your preferred settings, and set the language to Swift. Save the project wherever you keep your source code.

We're back to square one with our project. Rather than jumping right into Interface Builder to lay out our UI, let's open `ViewController.swift` instead and define our interface elements.

~~~swift
class ViewController: UIViewController
{
    var imageView:UIImageView!
    var emailLabel:UILabel!
    var emailField:UITextField!
    var passwordLabel:UILabel!
    var passwordField:UITextField!
    var signinButton:UIButton!

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}
~~~

As you can see, we have created six different interface elements. You'll also notice that I have marked each one as an implicitly unwrapped optional. When working with an optional value in Swift, you generally want to perform an `if` statement to see if there's a value set. In our case, however, we know that each of these interface elements will exist on our UI when it's rendered on-screen. We can save ourselves some extra typing by marking each one as implicitly unwrapped with the exclamation mark.

Let's follow through on that contract, and define each of our elements in `viewDidLoad`.

~~~swift
override func viewDidLoad()
{
  super.viewDidLoad()
  imageView = UIImageView()
  imageView.translatesAutoresizingMaskIntoConstraints = false
  imageView.backgroundColor = UIColor.redColor()
  view.addSubview(imageView)

  emailLabel = UILabel()
  emailLabel.translatesAutoresizingMaskIntoConstraints = false
  emailLabel.text = NSLocalizedString("Email:", comment: "Email Label")
  view.addSubview(emailLabel)

  emailField = UITextField()
  emailField.translatesAutoresizingMaskIntoConstraints = false
  emailField.keyboardType = .EmailAddress
  emailField.placeholder = "justin@autolayoutzen.com"
  view.addSubview(emailField)

  passwordLabel = UILabel()
  passwordLabel.translatesAutoresizingMaskIntoConstraints = false
  passwordLabel.text = NSLocalizedString("Password:", comment: "Password Label")
  view.addSubview(passwordLabel)

  passwordField = UITextField()
  passwordField.translatesAutoresizingMaskIntoConstraints = false
  passwordField.secureTextEntry = true
  view.addSubview(passwordField)

  signinButton = UIButton(type: .System)
  signinButton.translatesAutoresizingMaskIntoConstraints = false
  signinButton.setTitle(NSLocalizedString("Sign In", comment: "Sign In Button"),
    forState: .Normal)
  view.addSubview(signinButton)
}
~~~

We have a lot of boilerplate code here to create our different views. Pay the most attention to the lines that contain `translatesAutoresizingMaskIntoConstraints`—this property generates a set of constraints to duplicate the behavior specified by the view’s autoresizing mask. This allows you to use our departed friends like `setFrame()` on those views rather than modifiying their constraints explicitly.

We are setting this value to false for each of our controls because we want to define our own constraints rather than allowing the system to use a view's autoresizing mask to generate them.  I'm not really a fan of how verbose that method is, however. It also makes me think for a split second each time about what I'm actually doing.  For bonus points, let's create an extension on `UIView` that will define a more explicit method to enable Auto Layout for these views.

Go ahead and add a new Swift file to your project called `UIView+AutoLayout.swift` and add the following snippet of code to it.

~~~swift
extension UIView
{
    func usesAutoLayout(usesAutoLayout: Bool)
    {
        translatesAutoresizingMaskIntoConstraints = !usesAutoLayout
    }
}
~~~

What we're doing above is creating a new function on `UIView` called `usesAutoLayout()` that we can use to toggle the `translatesAutoresizingMaskIntoConstraints` value for any view in our application. If we apply it to our code, it's a bit easier to understand what we're trying to accomplish.

~~~swift
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
  signinButton.setTitle(NSLocalizedString("Sign In", comment: "Sign In Button"),
    forState: .Normal)
  view.addSubview(signinButton)
}
~~~

Now each of our views calls `usesAutoLayout()` and sets its value to `true`. It's a small change, but I think it makes reading the code a bit more understandable.

Now let's go ahead and run our application and see what we have thus far. Oh look. A mess.

![What "no constraints" looks like.](./images/ch07-ss02.png)

iOS is doing exactly what we've told it to do thus far. Create a few different views and throw them on screen. We haven't given it any information whatsoever about where to place those views on screen, so it defaults to the upper-left corner.

To get things placed on screen where we want, we need to define our layout constraints. In code, there are three ways to do this:

1. One-by-one with single constraints.
2. One-by-one with layout anchors.
3. Using the visual format language.

Let's try using all three to get our view how we want it.

### Single Constraints

The main class we have to interface with when creating constraints in code is `NSLayoutConstraint`. This has a single convenience initializer of `init(item:attribute:relatedBy:toItem:attribute:multiplier:constant:)`, which we can use to define a single constraint on our views.

Let's use this method to define the constraints related to our logo image view. We have four different things we need to define to start:

1. The logo should horizontally centered in its parent view.
2. The logo should be 20 points from the top of its parent view.
3. The width should be 96 points.
4. The height should also be 96 points.

First up, let's create a constraint to horizontally center the image view.

~~~swift
override func viewDidLoad()
{
    super.viewDidLoad()

    // Our previously defined views should still be here. Hiding them now for brevity.

    setupConstraints()
}

private func setupConstraints()
{
    let logoCenterXConstraint = NSLayoutConstraint(item: imageView, attribute:
        .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX,
        multiplier: 1.0, constant: 0.0)
    view.addConstraint(logoCenterXConstraint)
}
~~~

In this example, I'm starting by creating a private function called `setupConstraints()` that will be the home to our constraint definitions. I'm calling this method at the end of the `viewDidLoad()` method we previously used to define our views and add them on-screen. The first line of our `setupConstraints()` method creates a variable called `logoCenterXConstraint` that defines our horizontal centering constraint. There are quite a few parameters in this `NSLayoutConstraint` initializer, so let's walk through them.

The first attribute, `item`, defines the first view that we want to apply the constraint with. In our case, this is the `imageView` property on our view. Next, we set the first `attribute` property to `NSLayoutAttribute.CenterX` to say we are concerned with this view's horizontal centering. Next up is `relatedBy`, which lets us establish the quality of the constraint. In our case, we are using `NSLayoutRelation.Equal`, but it could also be `.GreaterThanOrEqual` or `.LessThanOrEqual`.

The next few attributes are related to the view that we want to constrain against. The `toItem` attribute says that we want to define `imageView`'s `CenterX` relationship against its parent view, `view`. Next we have our second `attribute` property in this initializer. In this case, it is also `NSLayoutAttribute.CenterX`.

The `multiplier` property applies to the second attribute participating in the constraint and allows us to do things like have dynamically sized values. In our case, the multiplier will be 1.0. (We'll cover some more interesting use cases of the multiplier in later chapters.) Finally, the `constant` value in this case will be 0.0, because we want our logo to be exactly centered in our parent view.

Yes, that was a lot. Now you know why I prefer writing constraints in Interface Builder!

After we've defined the constraint, we need to add it to our parent view. In this case, it is `ViewController`'s view. We do that on the `view.addConstraint(logoCenterXConstraint)` line.

That was a single constraint. We still need to add another three for our logo view. Let's define those in our `setupConstraints()` function.

~~~swift
// Set the top of our image view to be 20 points off the top of our parent view.
let logoTopPadding = NSLayoutConstraint(item: imageView, attribute: .Top,
    relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0,
    constant: 20.0)
view.addConstraint(logoTopPadding)

// We want the logo view to be 96 points wide.
let logoWidth = NSLayoutConstraint(item: imageView, attribute: .Width,
    relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute,
    multiplier: 1.0, constant: 96.0)
view.addConstraint(logoWidth)

// We want the logo view to be 96 points tall.
let logoHeight = NSLayoutConstraint(item: imageView, attribute: .Height,
    relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: nil, attribute:
    .NotAnAttribute, multiplier: 1.0, constant: 96.0)
view.addConstraint(logoHeight)
~~~

I won't walk through the code for each one of these constraints, since they are fairly similar to our first example. You can see that we've created a constraint defining the top of our image view's relationship to its parent view's top edge, as well as the height and width of our logo image view.

If you run the application now, you can see we've made a bit of progress in getting to the point where we wouldn't be embarrassed to show this to someone.

![We've made a mess.](./images/ch07-ss03.png)

Next let's define our constraints for the e-mail address and password text fields and labels.

### Layout Anchors

You will no doubt have nightmares about the verbosity of creating constraints using the `NSLayoutConstraint` initializer method. As of iOS 9 and OS X El Capitan, however, there is a better way that can get around that repetitiveness. Apple added a new feature to views called layout anchors.

All of the magic of layout anchors is provided by the `NSLayoutAnchor` class, which handles the work of creating individual `NSLayoutConstraint` objects under the hood. Using layout anchors to generate your constraints also provides you an additional piece of type-checking in that it won't allow you to create an invalid constraint—such as constraining the top edge of a view to another attribute in a view that's not in the same hierarchy. If you try to do so, you'll get a compile error.

You shouldn't ever need to interact directly with the `NSLayoutAnchor` class. Both `UIView` on iOS and `NSView` on OS X provide an instance that you can work directly with. Let's see how this works by defining five new constraints for our e-mail address text field and label.

1. The e-mail address text field should be horizontally centered in its parent view.
2. The e-mail address label's leading edge should equal the leading edge of the e-mail address text field.
3. The e-mail address label's trailing edge should equal the trailing edge of the e-mail address text field.
4. The top of the text field should be 10 points from the bottom of the e-mail address label.
5. The e-mail address text field's width should be 200 points.

Let's create the first constraint to horizontally center the text field in its parent view, since that is similar to a constraint we created above for the image logo.

~~~swift
let emailFieldCenterXConstraint = emailField.centerXAnchor.
  constraintEqualToAnchor(view.centerXAnchor)
view.addConstraint(emailFieldCenterXConstraint)
~~~

As you can see, this is way more concise than what we were doing in the previous section! The constraint being built from the layout anchor is fairly understandable. It says we want the `centerXAnchor` of `emailField` to be equal to the `centerXAnchor` of `view`. While this is visually more condensed for us in code, it's actually doing the exact same constraint creation we manually did before. In fact, it'd look something like this:

~~~swift
let emailFieldCenterXConstraint = NSLayoutConstraint(item: emailField,
    attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX,
    multiplier: 1.0, constant: 0.0)
view.addConstraint(logoCenterXConstraint)
view.addConstraint(emailFieldCenterXConstraint)
~~~

Let's create the rest of our e-mail address field and label constraints.

~~~swift
let emailLeadingEdgeConstraint = emailLabel.leadingAnchor.
  constraintEqualToAnchor(emailField.leadingAnchor)
view.addConstraint(emailLeadingEdgeConstraint)

let emailTrailingEdgeConstraint = emailLabel.trailingAnchor.
  constraintEqualToAnchor(emailField.trailingAnchor)
view.addConstraint(emailTrailingEdgeConstraint)

let emailVerticalPaddingConstraint = emailLabel.bottomAnchor.
  constraintEqualToAnchor(emailField.topAnchor, constant: 10.0)
view.addConstraint(emailVerticalPaddingConstraint)

let emailFieldWidthConstraint = emailField.WidthAnchor.
  constraintEqualToConstant(200)
view.addConstraint(emailFieldWidthConstraint)
~~~

We're using layout anchors for each of these additional constraints, but the last two offer a few different variations of what I have already shown you. For example, the `emailVerticalPaddingConstraint` constraint shows that we can use layout anchors while also adding a constant value. We are pinning the top anchor of our email text field to the bottom anchor of our e-mail address label with ten points of padding. We also set an explicit width constraint on our text field using its `widthAnchor` that we are constraining to a constant value of 200.

Let's run the application again and check our progress. Getting closer.

![Getting better . . .](./images/ch07-ss04.png)

We still haven't accounted for our password or sign-in views, however. Let's use the visual format language to define those.

### Using the Visual Format Language

Probably the most powerful feature of Auto Layout is its visual format language. Using a small vocabulary of ASCII keywords and strings, you can define an array of constraints at once with a single line of code. This is useful for scenarios where Interface Builder may not make sense for defining your layout. Rather than having to define a large number of constraints one-by-one, you can instead use the visual format language to not only define those constraints but also give you a fairly readable way of understanding those constraints when looking at the code later on.

The visual format language is fairly simple compared to something like regular expressions, but it does require a bit of upfront knowledge to understand what it's doing. Rather than giving you a table full of individual commands and what they mean, let's just create some constraints and walk through them. If you want the full visual format language reference, you can find it on Apple's site. I'd link to it for you, but Apple changes their URLs so frequently, it's easier for you just to Google "Auto Layout Visual Format Language" to find it.

The first constraint we want to define is a simple one that defines the vertical padding between our logo and the e-mail address label.

~~~swift
let views = [
    "logo" : imageView,
    "emailLabel" : emailLabel,
    "emailField" : emailField,
    "passwordLabel" : passwordLabel,
    "passwordField" : passwordField,
    "signinButton" : signinButton
]

let verticalLogoConstraints = NSLayoutConstraint.constraintsWithVisualFormat
  ("V:[logo]-[emailLabel]", options: NSLayoutFormatOptions.AlignAllCenterX,
  metrics: nil, views: views)
view.addConstraints(verticalLogoConstraints)
~~~

What's going on here? First we are defining a dictionary with value references to each of our interface elements we want to use when working with the visual format language. The keys can be any value you want. Just make sure they are easy for you to understand.

The main line we want to focus on is the `verticalLogoConstraints` variable. We are using a new (to us) method on `NSLayoutConstraint` called `constraintsWithVisualFormat()` that returns an array of constraints. The first parameter of `constraintsWithVisualFormat()` defines the constraints we are going to be creating. There are a few things to point out here.

First, you'll notice the first portion of the constraint definition is "V:". What this is telling Auto Layout is that we are wanting to define constraints on the vertical axis. If we wanted to work with the horizontal axis, we'd use "H:" instead. Next you see a reference to our "logo" key from the `views` dictionary, wrapped inside square brackets. There's also "emailLabel" wrapped in square brackets. Between those two views is a single hyphen "-". The hyphen tells Auto Layout that you want to have the standard amount of space between those two views on our vertical axis. The standard amount of space is defined and managed by iOS and OS X respectively.

If you wanted to define a different amount of space between the logo and emailField, you could replace the hyphen with something like `V:[logo]-10-[emailLabel]`, which would add ten points of padding between the two controls on the vertical axis.

After defining our format string, we set the `options` parameter to align all the controls we are working with along the CenterX axis. If you take a look at `NSLayoutFormatOptions`, you can see a variety of different options for how you can lay things out. The next parameter is `metrics`, which we are leaving nil in this instance. The `metrics` parameter takes a dictionary similar to the `views` dictionary we already defined, except with numeric values we can use in our constraint format strings. Finally, we actually tell our method call about our `views` dictionary with the `views` parameter.

The last line is adding our constraints array to the view. Notice how we are calling `addConstraints` rather than `addConstraint` which we have used in the past. We are using the plural version of this method because it takes an array of constraints rather than a single one.

If we were to define these constraints with layout anchors instead of the visual format language, this is what we'd be creating:

~~~swift
let paddingConstraint = imageView.bottomAnchor.
  constraintEqualToAnchor(emailLabel.topAnchor, constant: 8.0)
let centerXConstraint = imageView.centerXAnchor.
  constraintEqualToAnchor(emailLabel.centerXAnchor)
~~~

Instead of having to define those two constraints manually, we defined everything instead with that single line of visual formatting. This is a fairly basic example between two views, though. What if we wanted to define something a bit more complex? Let's define the vertical padding between the rest of our sign-in form fields.

~~~swift
let verticalPasswordConstraints = NSLayoutConstraint.constraintsWithVisualFormat
  ("V:[emailField]-[passwordLabel][passwordField]-[signinButton]",
  options: .AlignAllLeading, metrics: nil, views: views)
view.addConstraints(verticalPasswordConstraints)
~~~

There's nothing much new here that we didn't see in the previous example, except that we are defining relationships between four different views rather than just two. Can you imagine creating the equatable constraints one-by-one for this visual format string?  I'll leave that as an exercise for the reader. Needless to say, this is much less code to write.

Let's continue adding some more constraints visually.

~~~swift
let passwordWidthConstraint = NSLayoutConstraint.constraintsWithVisualFormat
  ("H:[passwordField(==emailField)]", options: .AlignAllCenterX,
  metrics: nil, views: views)
view.addConstraints(passwordWidthConstraint)
~~~

The `passwordWidthConstraint` is using our horizontal axis to define a width equality between the password and e-mail address fields. By enclosing a value in parentheses on `[passwordField]`, we can make the width value equal to another view in our `views` dictionary, a value from a `metrics` dictionary, or any arbitrary number.

If we wanted to define the height of a view using the visual format language, we'd swap out the `H:` axis call with `V:` instead.

The final thing we need to do is horizontally center our password field in its parent view. Unfortunately, there's no way to define the vertical or horizontal centering of a view using the visual format language. Instead, you'll have to opt for using layout anchors or individual constraint definitions. Let's add that single constraint.

~~~swift
// We want to horizontally center our password field in its parent view.
let passwordFieldCenterXConstraint = passwordField.centerXAnchor.
  constraintEqualToAnchor(view.centerXAnchor)
view.addConstraint(passwordFieldCenterXConstraint)
~~~

Now if we run our application, we can see that everything is laid out exactly how we want.

![Our final layout](./images/ch07-ss05.png)

### Summary

In this chapter, we looked at recreating our sign-in screen using Auto Layout constraints defined in code rather than Interface Builder. We started by holding strong references to individual constraints, so we can adjust their constant values or activated status on the fly. We followed up by defining individual `NSLayoutConstraint` instances. We then simplified things using the new layout anchors feature in iOS 9 and OS X El Capitan. Finally, we covered the visual format language that allows us to easily define multiple constraints in a single line.

In the next chapter, we are going to cover a few more advanced code-based uses of Auto Layout: layout guides and margins.

\pagebreak
