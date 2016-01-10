
Chapter 09 - Animation and Auto Layout
====================================

With the advent of iOS and modern versions of OS X, animation has become a staple of the development experience. Animations give users a sense of movement and help guide them through the user interfaces we craft. Whether it is the built-in sliding animation when pushing and popping between two view controllers in a navigation stack or something more custom, such as your own keyframe animations between two views, users expect to have smooth transitions between different states in your app.

With Auto Layout, the rules of animation have changed slightly.

### Adjusting Constants

In earlier chapters, I explained how modifying the frame of our views was a no-no. Instead, we want to focus on adjusting our constant values to achieve the movement we have in mind.

The constant is the one value in our Auto Layout equation that can be changed without removing and re-adding the constraint to our view. Using this, we can do many of the things we did previously by passing a new `CGRect` value to `setFrame:`, such as adjust the height and width of the view or move a view from one portion of the screen to another.

In the old days, you'd wrap your new `CGRect` frame value in an animation block like this:

~~~swift
UIView.animateWithDuration(0.1, animations: { () -> Void in
    myView.frame = CGRectMake(0.0, 0.0, 300.0, 300.0)
}, completion: nil)
~~~

Core Animation would then adjust the frame of `myView` to match our new value, while animating from the previous frame value.

With Auto Layout, however, we need to do something like this:

~~~swift
// Pre-defined to set the height of our myView view.
heightConstraint.constant = 300.0

UIView.animateWithDuration(0.1, animations: { () -> Void in
    myView.layoutIfNeeded()
}, completion: nil)
~~~

The `layoutIfNeeded` call is what tells the Auto Layout engine that it should do a new layout pass on our view. Once it completes that and calculates the new `frame` value to match our constraints, it will animate to match the new value.

To make this stick a bit more, let's work through an example.

Go ahead and create a new single view iOS Project in Xcode. Call it whatever you'd like. You now have a base project with your `AppDelegate`, `ViewController`, and storyboard.

For this example, we are going to bypass the storyboard and create all our constraints and adjustments using code. To do that, let's open the `ViewController.swift` file and add the following snippet of code:

~~~swift
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
          button.addTarget(self, action: "toggle:",
            forControlEvents: .TouchUpInside)
        }
    }

    var centerWidthConstraint:NSLayoutConstraint!
    var centerHeightConstraint:NSLayoutConstraint!

    var zoomed:Bool = false
}
~~~

The first two properties will be the pieces of interface we want on the screen: a `UIView` that we'll animate and the button to toggle the animation. The next grouping has two strongly held `NSLayoutConstraint` objects, which we will use to adjust the height and width of our view.

The final item is a boolean property we will use to keep track of whether our `centeredView` object has been zoomed in or out.

One thing I want to point out is my use of `didSet` when defining the `centeredView` and `button` variables. This is a trick I like to use when defining interface objects that need to be configured after being instantiated. The `didSet` call will only be hit once in our use case, so it's a great place to add any customization to the view's styling without crufting up our `viewDidLoad()` method.

Both of these methods `didSet` calls should be fairly straightforward. The important thing to note in both declarations is that we have set `translatesAutoresizingMaskIntoConstraints` to a value of `false` because we are going to define our own set of constraints and do not want to conflict with the auto-resizing constraints that can be created.

You'll notice in the `button` that we also define our target and action—a `toggle:` method. Let's add that to our implementation:

~~~swift
func toggle(sender: UIButton!)
{
    var constant:CGFloat = 0.0
    if zoomed == true
    {
        constant = 100.0
    }

    centerWidthConstraint.constant = constant
    centerHeightConstraint.constant = constant

    UIView.animateWithDuration(0.1, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
    { (finished) -> Void in
      self.zoomed = !self.zoomed
    }
}
~~~

In the first line, we define our constant value to be a `CGFloat` value of 0.0. If we are in an unzoomed state, we will adjust that value to be 100.0.

The two lines below that set the constant value of both the `centerWidthConstraint` and `centerHeightConstraint` constraints to be the `constant` value.

Finally, we wrap a call of `self.view.layoutIfNeeded()` in a `UIView` animation block so that the Auto Layout engine will recalculate our views frames and lay them out on the screen for us. In that animation block's completion handler, we adjust the `zoomed` property to be the inverse of what it was previously, so the toggle works as expected the next time the user taps the button.

You'll notice we haven't defined what `centeredWidthConstraint` and `centeredHeightConstraint` are just yet. We'll do that in our `viewDidLoad` method as well as some other constraints we need to get the `centeredView` where we want it on the screen.

~~~swift
override func viewDidLoad()
{
    super.viewDidLoad()

    centeredView = UIView(frame: CGRectZero)
    view.addSubview(centeredView)

    button = UIButton(type: .System)
    view.addSubview(button)

    // Establish the width to be one-half the view width.
    centerWidthConstraint = NSLayoutConstraint(item: centeredView, attribute:
        .Width, relatedBy: .Equal, toItem: view, attribute: .Width,
        multiplier: 0.5, constant: 0.0)
    view.addConstraint(centerWidthConstraint)

    // Establish the height to be 25% of the view height.
    centerHeightConstraint = NSLayoutConstraint(item: centeredView,
        attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height,
        multiplier: 0.25, constant: 0.0)
    view.addConstraint(centerHeightConstraint)

    // We want our view to be centered horizontally.
    centeredView.centerXAnchor.constraintEqualToAnchor
      (view.centerXAnchor).active = true

    // We want our view to be centered vertically.
    centeredView.centerYAnchor.constraintEqualToAnchor
      (view.centerYAnchor).active = true

    let views = [
        "button" : button
    ]

    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat
        ("H:[button]-|", options: .AlignAllRight, metrics: nil, views: views))
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat
        ("V:[button]-|", options: .AlignAllLastBaseline, metrics: nil,
        views: views))
}
~~~

This is a pretty elaborate method with quite a few constraints. Let's tackle each one.

~~~swift
centerWidthConstraint = NSLayoutConstraint(item: centeredView,
    attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width,
    multiplier: 0.5, constant: 0.0)
~~~

In our `centerWidthConstraint` constraint, we are telling the Auto Layout engine that we want our `centeredView` to have a width that is one-half of its parent view's width. We do this by setting the multiplier of the constraint to be 0.5 (or 50%).

~~~swift
centerHeightConstraint = NSLayoutConstraint(item: centeredView,
    attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height,
    multiplier: 0.25, constant: 0.0)
~~~

We do something similar with our `centerHeightConstraint` constraint. Here, we are telling the Auto Layout engine that we want our `centeredView` to have a height that is one-quarter of its parent view's width. We do this by setting the multiplier of the constraint to be 0.25 (or 25%).

~~~swift
centeredView.centerXAnchor.constraintEqualToAnchor
  (view.centerXAnchor).active = true
centeredView.centerYAnchor.constraintEqualToAnchor
  (view.centerYAnchor).active = true
~~~

The next two constraints merely state that we want our `centeredView` to be both vertically and horizontally centered in our super view. We are using layout anchors, which we learned about in a previous chapter, to create and activate these constraints.

~~~swift
let views = [
    "button" : button
]

view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat
    ("H:[button]-|", options: .AlignAllRight, metrics: nil, views: views))
view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat
    ("V:[button]-|", options: .AlignAllLastBaseline, metrics: nil,
    views: views))
~~~

Finally, we want to add a bit of padding for our `button` along the bottom and right edges of our superview. We do this using the ASCII formatting language provided by Auto Layout.

Run our sample project. You'll see our orange box centered in the screen, matching our constraints.

![Our animation sample](./images/ch09-ss01.png)

When you press the toggle button at the bottom of the screen, you should see the orange box expand to be larger, thanks to the constant of 100 we passed in our `toggle:` method.

![Zoomed in](./images/ch09-ss02.png)

For a bit of extra credit, try adjusting the `multiplier` value of the `centeredWidthConstraint` and `centeredHeightConstraint` constraints; then, run the application again. This will give you a good idea of how working with a multiplier can change how the interface is laid out on screen.

### Transforms and Auto Layout

With iOS 7, a major gotcha when working with Auto Layout animations is dealing with transforms like `CGAffineTransformMakeScale` and its siblings. Transforms work by adjusting the frame of the view to match the transform you want, while also maintaining the center of the view.

In iOS 7, using constraints to define the position and sizing of the view along with a transform to adjust the `frame` value caused things to get out of sync. This was fixed as of iOS 8, so this is no longer an issue you need to worry about as long as you are targeting 8 as your minimum.

If you are still required to support 7, however, the current recommended method is to wrap your Auto Layout-derived view in [a container view][container]; you can then manually adjust its center value to match the transformation you've applied.

In the container view, you'd want to override `layoutSubviews` to adjust the center value after the transform has been applied and the layout operation has made its pass.

~~~swift
override func layoutSubviews()
{
    super.layoutSubviews()
    let fixedCenter:CGPoint = {0};
    if (CGPointEqualToPoint(fixedCenter, CGPointZero))
    {
        fixedCenter = myView.center
    }
    else
    {
        myView.center = fixedCenter
    }
}
~~~

If you are using iOS 8 or newer, you can ignore this entire section because transforms work as expected.

### Summary

We covered how to take advantage of animation while using Auto Layout in our OS X and iOS apps. We addressed reasons why we can no longer animate the frames of our views as well as some gotchas with working with transforms for legacy releases of iOS.

In our final chapter, I will walk you through each item in my layout debugging tool belt for those times when your layouts aren't positioning things exactly how you wished.

[container]: http://stackoverflow.com/questions/12943107/how-do-i-adjust-the-anchor-point-of-a-calayer-when-auto-layout-is-being-used/14119154#14119154

\pagebreak
