
Chapter 03 - Key Terminology
====================================

### Building a Foundation

Before we can dive into building interfaces using constraints and Auto Layout, it's important that we establish a foundation of key terminology and concepts we can build on in the forthcoming chapters. An important step to achieving zen with Auto Layout is understanding what is actually happening when you're describing and working with a constraint-based layout system.

One of the reasons people become frustrated when first approaching Auto Layout is a lack of understanding of these core concepts. As developers, our natural inclination is to jump headfirst into developing with sample projects. Most of the time, we can figure it out as we go, but Auto Layout has a pretty steep cliff you can fall off of after you get past the first few elementary examples.

#### The Auto Layout Equation

The basis of the entire Auto Layout process is in mathematics. In fact, it's rooted in a fifteen-year-old algorithm called the [Cassowary algorithm][cassowary]. The Cassowary algorithm was created by Greg J. Badros and Alan Borning of the University of Washington, as well as Peter Stuckey from the University of Melbourne.

The original implementation of Cassowary was to more easily define layouts in HTML and CSS using constraints. The goal of [Constraint CSS][css] was to make it more expressive and easy to lay out a web page using the relationships that different views had with each other. Sadly, CCSS never took off, but that doesn't mean that Cassowary died. It has been ported to multiple platforms such as Java, .Net, and of course, Apple's platforms with Auto Layout.

When you decide to define your interface using Auto Layout, you're no longer explicitly setting the frame values for your controls and views. Instead, you're defining relationships between attributes on two views. Those constraints-based relationships are actually a system of linear equations that use Cassowary to calculate the respective values.

![The Auto Layout Equation](./images/ch03-ss01.png)

When you define a Cassowary constraint-based relationship between two views, you are actually defining them around the basis on one of the following linear equations:

    y = mx + b

In high school algebra, this was called slope-intercept form, but for our purposes, we can just think of it as the basis of Cassowary—and thus, Auto Layout.

* _viewA.attribute = viewB.attribute x multiplier + constant_
* _viewA.attribute >= viewB.attribute x multiplier + constant_
* _viewA.attribute <= viewB.attribute x multiplier + constant_

Looking at our `y = mx + b` equation in this form, the 'x' and 'y' represent the views being related in the constraint, 'm' is our multiplier, and 'b' is the constant.

Let's break this equation down further. On the far left side, we are working with an _attribute_ of our 'A' view. In Auto Layout the attribute refers to a value from the `NSLayoutAttribute` enum. As of iOS 7, those are:

*   `NSLayoutAttribute.Left` - The left side of the view's alignment rectangle.
*   `NSLayoutAttribute.Right` - The right side of the view's alignment rectangle.
*   `NSLayoutAttribute.Top` - The top of the view's alignment rectangle.
*   `NSLayoutAttribute.Bottom` - The bottom of the view's alignment rectangle.
*   `NSLayoutAttribute.Leading` - Similar to `NSLayoutAttribute.Left`, except the interface flips in a right-to-left environment like Hebrew or Arabic. If you're working with text, this is what you should be using.
*   `NSLayoutAttribute.Trailing` - Similar to `NSLayoutAttribute.Right`, except the interface flips in a right-to-left environment like Hebrew or Arabic. Like `NSLayoutAttribute.Leading`, you should use this when working with text.
*   `NSLayoutAttribute.Width` - The width of the view's alignment rectangle.
*   `NSLayoutAttribute.Height` - The height of the view's alignment rectangle.
*   `NSLayoutAttribute.CenterX` - The horizontal center based along the x-axis for the view's alignment rectangle.
*   `NSLayoutAttribute.CenterY` - The vertical center based along the y-axis for the view's alignment rectangle.
*   `NSLayoutAttribute.Baseline` - The baseline of a view's alignment rectangle. A **baseline** is a typographic term that defines the imaginary line that all text rests on. This is mostly useful for things like buttons and labels when you are working with text.
*   `NSLayoutAttribute.FirstBaseline` - New in iOS 8, you can lay out your view relative to the first baseline it encounters when working with the topmost line of text.
*   `NSLayoutAttribute.LastBaseline` - This is similar to `.Baseline` but allows you to lay out your text relative to the first baseline encountered on the bottommost line of text.  Both this and `NSLayoutAttribute.FirstBaseline` will provide a better layout visually when working with text rather than working with `NSLayoutAttribute.Top` or `NSLayoutAttribute.Bottom`, especially when working with dynamic text.
*   `NSLayoutAttribute.NotAnAttribute` - A non-existent attribute. This is useful when you aren't establishing a relationship between two views but are instead defining an attribute on the single view—for instance, defining a view's height or width.

Another new concept introduced in iOS 8 is the `layoutMargins` property on `UIView`, which lets you explicitly define the whitespace that your views use to guide where portions of the interface should be placed.

~~~swift
let label = UILabel()
label.translatesAutoresizingMaskIntoConstraints = false
label.layoutMargins = UIEdgeInsetsMake(-18, -18, -18, -18)
~~~

To go with the new layout margins functionality, there are new attributes added exclusively for iOS 8.

*   `NSLayoutAttribute.LeftMargin` - The left margin value of the view.
*   `NSLayoutAttribute.RightMargin` - The right margin value of the view.
*   `NSLayoutAttribute.TopMargin` - The top margin value of the view.
*   `NSLayoutAttribute.BottomMargin` - The bottom margin value of the view.
*   `NSLayoutAttribute.LeadingMargin` - Similar to `.LeftMargin`, except the interface flips in a right-to-left environment like Hebrew or Arabic.
*   `NSLayoutAttribute.TrailingMargin` - Similar to `.RightMargin`, except the interface flips in a right-to-left environment like Hebrew or Arabic.
*   `NSLayoutAttribute.CenterXWithinMargins` - This is similar to `.CenterX`, but it takes into account the margin values that you have set.
*   `NSLayoutAttribute.CenterYWithinMargins` - This is similar to `.CenterY`, but it takes into account the margin values that you have set.

Once we've described which attribute we want to use as the first part of our relationship, we can choose for it to be either _equal_, _greater than_, or _less than_ an _attribute_ on our 'B' view. That B-view attribute is then able to be multiplied by a **multiplier**.

#### Multiplier

The multiplier is one of the core algebraic aspects of the Auto Layout linear equation that gives it power. You can use it, for example, to say that you want the width of view A to be half of the height of view B or similar.

The multiplier is a fixed value in that it cannot be changed after a constraint has been defined. If you want to change the multiplier, the only option is to remove and redefine the constraint.

More often than not, you'll see a multiplier of 1.0, which for all intents can be ignored. But should you want to do something more powerful, it's capable of being any floating point value you desire.

One example where I have used a different multiplier is with adjusting the padding between views based on the dynamic text size. If the user has a larger dynamic type size, I'll use that value as part of the multiplier so that there is more padding between labels. If they have a smaller text size, I'll then use a smaller amount of padding.

#### Constant

The last part of our linear equation is the constant, which allows you to offset a view from its defined attribute by a set float value. For instance, if you have a `UIButton` and want its `NSLayoutAttribute.Bottom` to be pinned to its superview's `NSLayoutAttribute.Bottom`, you could add a bit of padding by setting its `constant` value to 10.0.

If you remember one thing, remember that _the constant is not constant_. Unlike the multiplier, you're able to adjust the constant after a constraint has been defined. This is especially useful when we get to animating constraints in later chapters.

The good news about these linear equations is that, after you define your constraints, you don't have to do any of the solving. The heavy lifting is left to the Auto Layout engine, which will take your constraints and calculate all of your frame values for you.

### Intrinsic Content Size

The **Intrinsic Content Size** is one of the most powerful features you gain when you opt-in to using Auto Layout to describe your interfaces. When a view has an intrinsic content size, it is promising Auto Layout that it will have a predefined size that the engine can use to calculate and lay out its views.

Not all views have an intrinsic content size, but things like buttons and labels do. Both labels and buttons have text that we can measure based on its font attributes and approximately how much space it should take up if the view were just wrapped around the explicit text content. Image views also have an intrinsic content size that is based on the size of the image. With an intrinsic content size defined, the Auto Layout engine automatically defines the size constraints for the view and manages them for you.

![Our fancy button](./images/ch03-ss02.png)

\pagebreak

Let's look at an example of this tweet button view. Inside are both a `UIImageView` with the home icon and a `UILabel` that says "Home" in English. In our view subclass, we can override the `intrinsicContentSize` method to calculate and return a value as a `CGSize`.

~~~swift
override func intrinsicContentSize() -> CGSize
{
    let attributes = [
        NSFontAttributeName : UIFont.systemFontOfSize(12.0),
        NSForegroundColorAttributeName : UIColor.blackColor()
    ]

    let labelSize = self.label.text.sizeWithAttributes(attributes)
    let imageSize = self.image.size

    let width = imageSize.width + labelSize.width;
    let height = max(imageSize.height, labelSize.height);

    return CGSizeMake(width, height)
}
~~~

Let's walk through this code:

The first line defines a `Dictionary` with the attributes our label is laid out using. We can then get the `CGSize` of that label by passing the dictionary to the `sizeWithAttributes()` method.

Next, we get the `UIImage` size and store it as a `CGSize` value.

The subsequent two lines define the width and height that we are going to use as our intrinsic content size. The `width` is just the sum of the `imageSize` and `labelSize` widths. The `height` takes the largest (max) value of the `imageSize` and `labelSize` heights.

Finally, we return the calculated width and height as a `CGSize` for the Auto Layout engine to take advantage of.

This is a bit of a contrived example. More often than not, you won't need to override the `intrinsictContentSize` method to return your own values. The system should be able to determine the content size based off the constraints you define on the view. If you're doing something such as custom drawing, that may not be the case, and overriding `intrinsictContentSize` would make sense. Keep in mind, however, that once you do take over control of `intrinsictContentSize`, you're also in charge of invalidating it when a view transitions between size classes by calling `invalidateIntrinsicContentSize()` on the view.

### Localization

Where the intrinsic content size really shines is when dealing with localization. Traditionally, when you wanted to localize your user interface, the best practice was to size your controls with additional padding on the trailing edges so that more verbose languages like German wouldn't be truncated. It wasn't an exact science and took a lot of trial and error to get right.

With Auto Layout and the intrinsic content size, you no longer have to add that extra padding. It will be sized accordingly to fit the amount of content passed into it.

When your view is doing its measurement pass to calculate the size of its frames, it will measure the attributes you have passed to your `UILabel` (or `UITextView`, etc) and lay out your content based on that.

The one caveat to this: you shouldn't set an explicit height or width for that label or other text layout view. Doing so opts you out of using the intrinsic content size to size the view. We'll cover this more in Chapter 8.

### Alignment Rectangles

If the intrinsic content size defines the size of the content that we want to lay out, the **alignment rectangle** is what the Auto Layout engine actually uses to line up and lay out the controls rather than the full frame of your view.

An alignment rectangle is useful if you're working with a view that has extra ornamentation, such as a badge on a button that you don't necessarily want to take into account when laying out the control.

In the case of a badged button, you can just override `alignmentRectInsets` in its subclass to return either a `UIEdgeInsets` (iOS) or `NSEdgeInsets` (OS X) to define the alignment rectangle.

If you need to do something more complex than insetting the full-frame of a view, you can override `frameForAlignmentRect:` to define an actual CGRect or NSRect, depending on which OS you are targeting. UIImage also has a method, `imageWithAlignmentRectInsets`, which you can override to return a new version of the image adjusted by those insets.

### Priorities

Sometimes, you'll have multiple constraints that can have different effects on a specific view. For instance, you may have a set of constraints stating that the left and right edges of the view should be a value of 10, while also saying the view should be less than or equal to 300 points wide.

We can use priorities to decide which constraint takes precedence over the other if we get into a situation where they may conflict.

### Compression Resistance

The compression resistance priority refers to the way a view protects its content from being truncated. If you want to ensure that a control isn't shrunk when its parent view is resized, you can adjust its compression resistance so that it is higher than those other controls.

A view with a high compression resistance fights against shrinking. It won't allow its content to clip either horizontally or vertically, depending on which axis you define the resistance against.

For example, let's say that we have three buttons that are contained in a superview. The only way to fit all three into the superview is to truncate at least one. If we want to ensure that the green button maintains its width and its content is not truncated,, we would set its compression resistance to be higher than the other two.

~~~swift
greenButton.setContentCompressionResistancePriority
  (UILayoutPriorityRequired, forAxis: UILayoutConstraintAxis.Horizontal)
~~~

### Content Hugging

Related to compression resistance, the content hugging priority refers to the way a view prefers to avoid extra padding around its core content or the stretching of that core content. If a view has a higher content hugging priority, that means it won't be padded to fill out the UI, and the Auto Layout engine will instead move to a view with a lower priority to fill out that space.

Using our three buttons container view from above, let's assume the three buttons are smaller and that we want to fill out the superview entirely. In this situation, we want to make sure that the green and blue buttons don't stretch and that only the yellow one does. In order to establish that, we would do the following:

~~~swift
greenButton.setContentHuggingPriority
  (UILayoutPriorityRequired, forAxis: UILayoutConstraintAxis.Horizontal)

blueButton.setContentHuggingPriority
  (UILayoutPriorityDefaultHigh, forAxis: UILayoutConstraintAxis.Horizontal)

yellowButton.setContentHuggingPriority
  (UILayoutPriorityDefaultLow, forAxis: UILayoutConstraintAxis.Horizontal)
~~~

The next time the Auto Layout engine makes a pass, it will fill out the view so that the yellow button fills the extra available space, since it had a lower content hugging priority than the other two.

### Summary

This chapter was heavily focused on jargon and terminology, but the intent was to provide a good introduction and understanding of some of the key concepts that we will be working with in our journey towards achieving Auto Layout zen.

In the next chapter, we'll continue to build our foundation of understanding via an in-depth discussion of what actually happens behind the scenes when the Auto Layout engine does its work.

Grab your apron. We are about to learn how the sausage is made.

[cassowary]: http://sourceforge.net/projects/cassowary/

[css]: http://gridstylesheets.org/guides/ccss/

\pagebreak