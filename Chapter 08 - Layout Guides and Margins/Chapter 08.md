Chapter 08 - Working With Layout Guides and Margins
=====================================================

### Layout Guides

When Apple made the transition from the skeuomorphic textures of iOS 6 to the flat style of iOS 7, they also introduced the concept of having content that extended to the full edges of an interface's screen. Designers then had to account for the extra 20 points of the status bar in their designs. Developers also had to account for the fact that their content could theoretically scroll under a navigation bar or toolbar, causing it to blur the contents as it scrolled by.

You obviously didn't want content that was always extended under those bars and unreachable by the user. To get around that, Apple introduced the concept of the `topLayoutGuide` and `bottomLayoutGuide` on `UIViewController`. These two guides allow you to pin your Auto Layout constraints to the highest vertical extent so that it is always in focus for the user.

As an example, let's say you have a `UITableView` as the main view inside a `UINavigationController`. If you pin the constraints of the table view to the top and bottom edges of the parent view, the first row (or more) is going to be hidden underneath the navigation bar when the user opens the app. To get around that, you instead create a constraint that pins the top of the tableView to the bottom of the `topLayoutGuide` like so:

~~~swift
let topTableConstraint = tableView.topAnchor.constraintEqualToAnchor
  (topLayoutGuide.bottomAnchor)
~~~

You'd want to do something similar for the `bottomLayoutGuide` when you have a toolbar or tab bar along the bottom, as well.

The concept around the top and bottom layout guides is great because you get a definitive object to pin your constraints to without having to muck up your view hierarchy with extra views to pin against or, worse, magic numbers to ensure that your content is never underneath something else.

### Custom Layout Guides

With iOS 9, Apple has opened up the concept of layout guides to all developers with the new `UILayoutGuide` class. This lets you establish an invisible rectangle on your view, which you can pin your actual views against to accomplish more advanced layouts. Previously, if you wanted to evenly distribute a group of views within a view, you'd need to have additional empty `UIView` instances to use as spacers between the visible views. These spacers would show up in your view hierarchy and add memory overhead to your application. With iOS 9, you can create layout guides instead.

Let's test out layout guides by building this exact scenario. Our manager has asked us to create a view controller that has four green boxes evenly distributed from top to bottom. Let's use our knowledge of Auto Layout and layout guides to do just that.

To get started, open Xcode and create a new 'Single View Application' project. Name the product whatever you'd like, set the organization name and identifier to your preferred settings, and set the language to Swift. Save the project wherever you keep your source code.

Next, open _Main.storyboard_ and a `UIView` instance to your view. Add a width constraint of 200 points to the box and a height constraint of 100 points. Set the background color of the view to your color of choice. I've chosen green. Let's also add a constraint that horizontally centers the view in its parent.

![Little boxes made of ticky-tacky](./images/ch08-ss01.png)

Next, hold down the Option key and click and drag the green view to create a duplicate copy of the view. You should now have two instances of the colored box on your canvas now. We need to create a few different constraints to associate some relationships between the view.

1. Each box should have the same height.
2. Each box should have the same width.
3. Each box should have the same horizontal center.

We can add all of these constraints at once. Press the Control key and click and drag from the original box you created to the new one to expose the semi-transparent constraints popover. With that popover visible, press the Shift key and select _Center Horizontally,_ _Equal Widths,_ and _Equal Heights._ Each one should now have a checkmark next to it. Finally, click _Add Constraints_ to create the constraints in your view.

![Adding multiple constraints at once](./images/ch08-ss02.png)

Repeat the last few steps twice. Hold down the Option key and click and drag the green view to create a duplicate copy of the view and add the same set of constraints to each one.

At this point, you might have noticed that our view is still marked with a red arrow in the document outline on the left side. If you click on the arrow, you'll see that Interface Builder is complaining that we are missing constraints. Specifically, it is saying that we have no y-position constraints for our boxes. If we were to run our application right now, each of the views would be clumped together at the top.

We can resolve this by adding vertical spacing constraints between each view. For the top and bottom views, pin to the `topLayoutGuide` and `bottomLayoutGuide` respectively. This will give our views their top and bottom framing. For the views in the middle, however, we want to use our custom layout guides to help evenly distribute the spacing between the views. Unfortunately, Interface Builder doesn't currently support adding layout guides, so we need to do those in code. I'm not a fan of leaving these warnings in Interface Builder, though, so let's add these extra constraints anyway. I'll show you how we can remove them at build time.

1. Click on the top box and open the _Pin_ popover at the bottom of the canvas.
2. Click on the top red line so that we create a constraint from the box to our top layout guide. Ensure that the value in the text field box is 0.
3. Click _Add Constraint._

We've now set our top box to be pinned to the bottom of our top layout guide. Next, let's repeat these steps but for our bottom layout guide.

1. Click on the bottom box and open the _Pin_ popover at the bottom of the canvas.
2. Click on the bottom red line so that we create a constraint from the box to our top layout guide. Ensure that the value in the text field box is 10.
3. Click _Add Constraint._

These two constraints we want to keep. These are setting the top and bottom edges of our view. What about those two views in the middle? Let's add vertical spacing constraints that are removed at build time.

1. Click on the top box.
2. Control-drag from the top box to the one directly below it to show the semi-transparent constraints popover.
3. Click on _Vertical Spacing._

At this point, we should have a new vertical spacing constraint between our top and second view box. This stops Interface Builder from complaining about the second box not having a y-position, but we don't want this constraint to actually exist when we launch the app. Select the new constraint and open the attributes inspector on the right side. Check the box next to _Remove at build time._

![Removing constraints at build time](./images/ch08-ss03.png)

This tells our application that we are going to add this constraint at design time to appease the Interface Builder gods, but we don't want it to be installed when we actually run our application on a device or simulator.

Go ahead and add this same vertical spacing constraint between the second and third box, and the third and fourth as well. Make sure that you check _Remove at build time_ for each of these newly created constraints.

At this point, we shouldn't be throwing any errors in Interface Builder because we've added enough constraints to satisfy it. If you were to run the application, however, you'd notice that the middle boxes are shoved towards the top of the view. Since we removed those vertical spacing constraints at build time, running the application leaves those center boxes without any y-position. This is where we start writing code to add our layout guides.

Open `ViewController.swift`, which should be empty. First up, we need to add a few `@IBOutlet` instances for our four boxes.

~~~swift
class ViewController: UIViewController {
  @IBOutlet var box1:UIView!
  @IBOutlet var box2:UIView!
  @IBOutlet var box3:UIView!
  @IBOutlet var box4:UIView!
}
~~~

Next, go back to our storyboard and connect those outlets to their respective views, so we can interact with them in our view controller file.

Once those outlets are connected, let's create our layout guides and add the relationships for them in our `viewDidLoad()` method. Add this code below to the view controller file.

~~~swift
@IBOutlet weak var box4:UIView!

let topGuide = UILayoutGuide()
let centerGuide = UILayoutGuide()
let bottomGuide = UILayoutGuide()

override func viewDidLoad() {
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

  view.addConstraint(topGuide.heightAnchor.
      constraintEqualToAnchor(centerGuide.heightAnchor))
  view.addConstraint(centerGuide.heightAnchor.
      constraintEqualToAnchor(bottomGuide.heightAnchor))
}
~~~

The first three things we add are read-only variables called `topLayoutGuide`, `bottomLayoutGuide`, and `bottomGuide`, respectively. These are the three layout guides we are going to work with in our view controller. We are creating them as read-only and instantiating them early, solely to keep the `viewDidLoad()` method a bit more sane.

Speaking of, in the `viewDidLoad()` method, you'll notice the first thing we are doing is adding our layout guides to the view itself. One key difference between a standard view and a layout guide is that a layout guide doesn't have a user-adjustable frame value. The frame is instead calculated by the constraints you apply to it (see the `layoutFrame` property on `UILayoutGuide`). The next chunk of code actually goes about defining the constraints that make relationships between our layout guides and the green box views themselves.

Since layout guides are rectangular, we need enough constraints to be able to define that rectangular size. Our first constraint is telling us that we want our `topGuide` layout guide's top anchor to be equal to our first box's bottom anchor—or edge. Next, we pin the second box's top anchor to the `topGuide`'s bottom anchor. At this point, we create spacing between the first two boxes using this first layout guide.

Next, we assign the second box's bottom anchor to the `centerGuide`'s top edge while pinning the third box's `topAnchor` to the center layout guide's bottom. Now our middle anchor is properly defined.  After that, we repeat these steps by pinning the bottom of box three to the top of our `bottomGuide` and the top of box four to the bottom of `bottomGuide`. If we were to run our application at this point, we'd have spacing between our boxes, but it wouldn't be exactly what we want. Our manager said he wants the boxes to be evenly distributed.

To accomplish this, we need to make sure that our layout guides all have the same height; that is what we are accomplishing with our last two constraints. We are saying we want the `heightAnchor` of the top guide to be equal to the height of the `centerGuide` property. We also want `centerGuide`'s height to be equal to the height of `bottomGuide`. Now, we have our views laid out exactly how we wish.

![Everything in its right place](./images/ch08-ss04.png)

### Grouping Views With Layout Guides

Another useful scenario where we can take advantage of layout guides is when centering a group of items in our view. If you've worked with Auto Layout in the past, you've likely been frustrated when you wanted to vertically center a button and a label together in the view. With `UILayoutGuide` on iOS 9, it's a piece of cake.

In our scenario, let's create an application with a `UIActivityIndicator` and a `UILabel` that need to be grouped and centered in our parent view.  Create a new single-view Xcode project to house this new interface.

Next, open `Main.storyboard` and add an activity indicator and label to your view controller's canvas. It doesn't really matter where you place them on the view, save for having the activity indicator directly above the label.  You can also set the text of your label to whatever you wish. I opted for "Important Things Happening."

We are going to create our layout guides in code, but we can add some base constraints to our two views in Interface Builder to save us some typing.

1. Add a vertical padding constraint between the activity indicator and label with about 8 points of padding.
2. Constrain the top of the `UIActivityIndicator` to the bottom of the `topLayoutGuide` with 10 points of padding from the top. Select the constraint and check _Remove at build time_ on it in its inspector. We'll be using our layout guides to properly place the views.
3. Horizontally center the activity indicator inside its super view. Make sure to check _Remove at build time_ on this constraint as well.
4. Finally, horizontally center the label with the activity indicator.

Once you've added these four constraints, select both controls in your view, go down to the _Resolve Auto Layout Issues_ menu (lower-right corner) and select _Update Frames_ to get everything placed where it should be.

![Our new sample's layout](./images/ch08-ss05.png)

If you run the application, you'll see our two views pinned to the top of the screen but nudged to the upper-left corner. Since our last three constraints are removed at build time, the Auto Layout engine only knows that we want eight points of padding between the activity indicator and the label.

We need to get into code to actually center our view how we want. Open up our view controller file and add the following snippet of code.

~~~swift
class ViewController: UIViewController {
  @IBOutlet var spinner:UIActivityIndicatorView! {
    didSet {
      spinner.startAnimating()
    }
  }

  @IBOutlet var label:UILabel!

  let layoutContainer = UILayoutGuide()
}
~~~

Before we go over what this code does, go back to the storyboard and make the outlet connections from our new variables to their respective items in the view controller canvas.

Our first line is defining an `@IBOutlet` instance for our activity indicator called "spinner." We are overriding its `didSet` handler, so we can start animating it as soon as the view is instantiated. Next, we define an `@IBOutlet` for our label, conveniently called "label." Finally, we add a single `UILayoutGuide` instance called "layoutContainer," which will contain our two views when we are centering them.

Next, we need to override `viewDidLoad()` to add our layout guide to the view and assign our constraints to it.

~~~swift
override func viewDidLoad() {
  super.viewDidLoad()

  view.addLayoutGuide(layoutContainer)

  spinner.topAnchor.constraintEqualToAnchor
    (layoutContainer.topAnchor).active = true
  label.lastBaselineAnchor.constraintEqualToAnchor
    (layoutContainer.bottomAnchor).active = true
  label.leadingAnchor.constraintEqualToAnchor
    (layoutContainer.leadingAnchor).active = true
  label.trailingAnchor.constraintEqualToAnchor
    (layoutContainer.trailingAnchor).active = true

  layoutContainer.centerXAnchor.constraintEqualToAnchor
    (view.centerXAnchor).active = true
  layoutContainer.centerYAnchor.constraintEqualToAnchor
    (view.centerYAnchor).active = true
}
~~~

Our first step is to add the layout guide to our view controller. Next, we use layout anchors to place our spinner inside the container. The first constraint says we want the activity indicator's top to be equal to the top of the layout guide. We also want the last baseline of the label to be equal to the bottom of our layout guide. Since the label is a text-heavy control, we are aligning it with baselines rather than just the `bottomAnchor`. That gives Auto Layout a bit of guidance when working with text, so it can give a better layout for text heavy interfaces. Somewhat related, we are using the leading and trailing anchors to confirm that our label control should stretch the length of the layout guide, as well.

The final two constraints are where we tell Auto Layout that we want our `layoutContainer` guide to be vertically and horizontally centered in our view.

One thing to make note of is that we are setting each of these constraints to `active` as we define this. This saves us a bit of time: we don't have to explicitly call `addConstraint()` for each one; setting them to `active` does that for us.

Go ahead and run the application. You should notice that everything is properly placed in center of the view. As an exercise for the reader, try to think about how you would accomplish this without layout guides. Doesn't sound like much fun, does it?

### Layout Margins

One of the less heralded things about iOS 8 is added support for margins on `UIView`. Before layout margins, you had to explicitly define padding levels for each of your constraints. So for example, if your design guidelines dictated that every view should have ten points of padding along the edges, each constraint would need to explicitly define a constant value of ten to account for that. If your designer pushed up his wooden glasses and decided 11 points was better, you'd have a lot of constraint updating to do. With layout margins, you can deal with your fussy designer's whims much easier by establishing your view's margin values and assigning constraints against those values instead.

The one caveat to layout margins is that you can't set them on a `UIViewController`'s view; those are hardcoded and set to eight points. Any other view on your canvas is fair game, however.

To test this out, create a new single view Xcode project called "Layout Margins" and open its `Main.storyboard` file.

Inside the storyboard, create two `UIView` instances. On the first box, set the background color to your favorite shade of green. The second box should be your favorite shade of red.  Next, we need to add constraints to our green box.

Select the green box and add a width constraint to a constant value of 212. Also, add an aspect ratio constraint that makes it a 1:1 ratio. For the red box, only set a 1:1 aspect ratio constraint.

Now, drag the red box on top of the green box. Make sure that you don't make the red box a subview of the green view; you just want them stacked on top of each other while we are adding new constraints. Add the following constraints:

1. Horizontally center the green box in its parent view.
2. Horizontally center the red box with the green box.
3. The top of the green box should be equal to the bottom of the `topLayoutGuide`.
4. Pin the bottom of the red box to the `bottomMargin` of the green box. You can ensure that you are working with the margins in the constraint's identity inspector. Ensure that _Green Box_ references _Bottom Margin_ instead of just _Bottom._
5. Pin the leading edge of the red box to the green box's leading edge margin.
6. Pin the trailing edge of the red box to the green box's trailing edge margin.
7. Pin the top of the red box to the green box's top margin.

Run your application now. You should see that the red box is on top of the green box but with about eight points of padding on each edge. By default, the `layoutMargins` value on a `UIView` is eight points on each edge.

![Laid out with default margins](./images/ch08-ss06.png)

We can adjust these margin values in two different ways. There are options in Interface Builder when you are customizing the view to set explicit margin values. Another way, however, is to adjust them in code. For the sake of this example, let's do it in code.

Open `ViewController.swift` and add the following snippet of code to your class.

~~~swift
@IBOutlet var greenBox:UIView! {
  didSet {
    greenBox.layoutMargins = UIEdgeInsetsMake(10, 10, 10, 10)
  }
}
@IBOutlet var redBox:UIView!
~~~

Next, go back to the storyboard and connect those outlets to their respective views, so we can interact with them in our view controller file.

Notice that we are again overriding `didSet` to customize our view. In this case, we are saying we want the `layoutMargins` property of our green box to have ten points of padding. Adjust that value to be something more extreme (20 for instance) and run the application again. Notice how the padding amount changed in our view, even though we didn't change our constraints at all? That is the power of layout margins.

### Summary

We unpacked a few of the more advanced features of working with Auto Layout. We covered working with the built-in `topLayoutGuide` and `bottomLayoutGuide` properties on a view controller. We also worked with custom layout guides, a new feature of iOS 9 that helps us more easily align our views on screen. Finally, we covered working with layout margins to make adjusting our views easier—without needing to constantly tweak our constraints.

In the next chapter, we will begin animating our Auto Layout-powered views.

\pagebreak
