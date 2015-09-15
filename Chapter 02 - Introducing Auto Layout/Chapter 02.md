
Chapter 02 - Introducing Auto Layout
================================================

### What Is Auto Layout?

If you have watched any of the WWDC videos on Auto Layout, Apple describes the technology as "a constraint-based, descriptive layout system." While accurate, the "Auto" aspect of it is a misnomer that people tend to get hung up on.

"Auto" describes what the layout engine itself does, but there's still work you as a developer must do up front so that Auto Layout can work its magic.

My preferred way to describe Auto Layout is that it is all about relationships. Auto Layout is a system that allows you to define a view's size and origin by its relationships to adjacent views and then use those relationships to perform the layout. More verbose? Yes, but it also explains what exactly is happening.

![Auto Layout is about relationships between your views.](./images/ch02-ss01.png)

Let's look at a basic example. Let's say that you have a `UILabel` that you want to be centered along the Y-Axis, with a `UIButton` placed underneath it and centered. There are a few different relationships that these views have between each other.

1. Both the `UIButton` and `UILabel` have the same parent view controller.
2. The `UILabel` is vertically centered based on the center point of the parent view controller.
3. The `UIButton` is then vertically centered based on the center point of the `UILabel`.
4. There's a variable value that describes the padding from the bottom of the `UILabel` to the `UIButton`.

Auto Layout is about explicitly defining these relationships either in code or with Interface Builder using constraints. A **constraint** is a way to describe the relationship between two views. A constraint can describe things such as the height or width of the view, how far from another view it should be, how to center it, etc. Once you pass these constraints to the Auto Layout engine, it can then go ahead and work its magic.

Auto Layout was introduced in OS X Lion and iOS 6, so it has a few years under its belt thus far. It has been enhanced in subsequent releases of OS X—both at the code and Interface Builder levels—allowing it to handle layouts as basic or as complex as you want to throw at it.

### Dynamic vs. Absolute Layout

The present-day OS X and iOS operating systems are both based off that NeXTSTEP OS. The Interface Builder you use now has existed in some form since the NeXTSTEP days, although you may not easily recognize it up against the modern Xcode 7 incarnation.

One of the key features of the Interface Builder paradigm is the concept of Springs & Struts. Springs & Struts allow a developer to easily handle a variety of different layout situations in a static manner. Interface Builder allows you to set specific springs and struts to define how a view or window should resize when faced with the task.

For instance, say you want a button to be pinned to the upper-right edge of the window no matter the size of the window. You could also specify you want a `UITextField` or `NSTextView` to be the entire width of its superview, but a fixed 250pt for its height.

The Springs & Struts way of developing interfaces is what I refer to as absolute layout.

Absolute layout systems like Springs & Struts have served us well, but they aren't without faults. For instance, in the age of iPhones and iPads, you're in charge of handling how your interface adjusts during rotation between portrait and landscape.

![Classic Layout Example](./images/ch02-ss02.png)

Take the following code sample:

~~~swift
let viewFrame = self.view.bounds
let width = round(CGRectGetWidth(viewFrame) / 2)
let height = round(CGRectGetHeight(viewFrame) / 4)
let centeredX = round((CGRectGetWidth(viewFrame) - width) / 2)
let centeredY = round((CGRectGetHeight(viewFrame) - height) / 2)

self.centeredView.frame = CGRectMake(centeredX, centeredY, width, height)
~~~

The purpose of the code is to center a UIView `orangeBoxView` in its superview while setting a height that is half the width of the superview and one-fourth the height. This code does exactly as is intended, until you rotate your device.

![Simulator Screenshot Sample Rotated](./images/ch02-ss03.png)

Upon rotation, the box remains the same size but is no longer centered in its superview. That's not a bug you caused necessarily. You defined the frame based on the coordinates you were working with at the time you called `setFrame:`. To adjust the box to handle both orientations, however, you need to do a recalculation at the time the frameworks tell you that the device is transitioning to a different size class.

~~~swift
override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator
	 coordinator: UIViewControllerTransitionCoordinator)
{
	super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
	let viewFrame = self.view.bounds
	let width = round(CGRectGetWidth(viewFrame) / 2)
	let height = round(CGRectGetHeight(viewFrame) / 4)
	let centeredX = round((CGRectGetWidth(viewFrame) - width) / 2)
	let centeredY = round((CGRectGetHeight(viewFrame) - height) / 2)

	self.centeredView.frame = CGRectMake(centeredX, centeredY, width, height)
}
~~~

One of the benefits of Auto Layout is that you don't have to handle the orientation changes like this anymore. Instead of setting a fixed `CGRect` value for the `orangeBoxView`'s `frame` we can instead describe its layout by applying constraints to the view. This is what I refer to as **dynamic layout**. The rules we are defining for our view's layout are universal, regardless of the orientation or size of the view. The Auto Layout engine will handle those adjustments for us.

If we were to do that in common English, it'd be something along the lines of:

* I want `orangeBoxView` to be half the width of its superview.
* I want `orangeBoxView` to be a quarter the height of its superview.
* I want `orangeBoxView` to be centered horizontally in its superview.
* I want `orangeBoxView` to be centered vertically in its superview.

Each of these descriptions can be turned into a constraint that we can apply to the view, which allows the Auto Layout engine to calculate our `CGRect` frame values and present the orange box on the screen.

Constraints are applied to the superview of the views you are expressing the relationship between. Looking at our Orange Box example, you'd define the constraints like so:

~~~swift
// Setup the orange box.
let viewFrame = self.view.bounds

// Half the width of the view frame.
let width = round(CGRectGetWidth(viewFrame) / 2)

// 1/4 the height of the view frame.
let height = round(CGRectGetHeight(viewFrame) / 4)

// Establishing the width to be half the view width
self.view.addConstraint(self.centeredView.widthAnchor.
		constraintEqualToConstant(width))

// Establishing the width to be 1/4 the view height
self.view.addConstraint(self.centeredView.heightAnchor.
		constraintEqualToConstant(height))

// We want our view to be centered horizontally.
self.view.addConstraint(self.centeredView.centerXAnchor.
		constraintEqualToAnchor(self.view.centerXAnchor))

// And vertically.
self.view.addConstraint(self.centeredView.centerYAnchor.
		constraintEqualToAnchor(self.view.centerYAnchor))
~~~

I'm sure I can guess your first reaction to that code block.

Oh my god that is more code than the previous example!

You're correct. It is more code on a line count basis, but it is also more expressive code. We are defining four constraint-based relationships between our superview and the `orangeBoxView`. You write this code once, and then Auto Layout handles maintaining those relationships the rest of the time, no matter what orientation or size of views you are working with.

Don't worry if you don't fully understand the code. I'll explain it in detail in upcoming chapters.

### Why Auto Layout?

If the previous example hasn't scared you away yet, let me try to convince you why Apple created Auto Layout in the first place.

It's not that the traditional absolute layout system was bad necessarily, but the folks in Cupertino believed they could create something better. With Auto Layout they did just that in the following ways.

#### Extend the Usefulness of Interface Builder

![Interface Builder](./images/ch02-ss04.png)

Interface Builder is no doubt part of the secret sauce that makes building apps for OS X and iOS so enjoyable. Rather than being knee-deep in XML layouts or writing a bunch of boilerplate code to create a table view, you can instead drag the table view onto its parent view and set up a majority of its visual attributes.

Auto Layout extends the power of Interface Builder by allowing you to define the constraint-based relationships each of your views have visually.

If you've worked with Interface Builder before, you're likely used to seeing the blue dotted lines that appear as guides for laying out your interface. Those dotted guides usually show up to match the spacing recommended between controls by the HIG.

![Interface Builder Auto Layout Guides](./images/ch02-ss05.png)

At its most basic level, Auto Layout is taking those guides that have always shown up temporarily and making them permanent.

This allows you to write (and manage) less code than before.

#### Improve Layout Code

What about those times that you actually need or want to write layout code? Auto Layout makes managing that code easier than before. The ASCII-Art formatting language Auto Layout provides makes it easy to go back to code you wrote months ago and get back up to speed on what its purpose is.

~~~swift
self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat
		("H:|-[stopButton]-[playButton]-[scrubber]-[airplayButton]-|",
		options: .AlignAllBaseline, metrics: nil, views: viewsDictionary))
~~~

In the example above, I'm defining a row of buttons that should fill the width of its super view. Each button has a fixed width defined by the button's asset size, while a slider control will fill the remaining space. I'll leave recreating this code using the traditional `setFrame:` method as an exercise to the reader, but I guarantee you it won't be a single line of code.

#### Move View Logic Back to the View

As applications have gotten more complex over the years, the acronym MVC has stopped standing for "Model-View-Controller" and instead for "Massive View Controller." In addition to providing view lifecycle and rotation information for our application, both `UIViewController` and `NSViewController` have seemingly become dumping grounds for anything from data sources, delegates, and configuring and laying out custom views.

Auto Layout has the concept of an `intrinsicContentSize` that promises to provide a predefined `CGSize` value for the width and height of certain views. This moves code that would be related to calculating the size of views out of your view controllers and back into those `UIView` subclasses where they belong.

Another concept introduced with Auto Layout is alignment rects, which can be used to align views with one another based on their content location rather than the full frame. This is beneficial in cases where there may be extra padding from borders, shadow, or reflections that ornament the view. Again, more code that would traditionally be put in your view controller is being moved back to the view subclass.

#### More Easily Handle a Variety of Screen Sizes and Interface Metrics

With such a drastic shift in the visual language of iOS 7, developers who were tasked with keeping a version of their app that supported both the legacy UI of iOS 6 and the modern decor of 7 were faced with a lot of frustration. Auto Layout eased some of that pain by accounting for those differences in metrics for you if you were using constraint-based layout. Though the size of the control may be different, its relationships with its parent and sibling views may not necessarily be.

Auto Layout also makes it easier to opt-in to supporting the new Dynamic Text System of iOS 7, which allows the user to customize the size of text in apps based on a system-wide setting, thanks to things like alignment rects and the intrinsic content size. When those values change, Auto Layout takes care of the heavy lifting of adjusting your interface to match the user's preferences with your interface design.

#### Easily Apply Maximums and Minimums

With Auto Layout you can be more expressive with your interface requirements without having to be explicit. For instance, you can define a button to be at least 100pt wide, but no more than 250pt wide, depending on how much of the view it needs to take up.

~~~swift
self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat
		("H:|-[button1(>=100,<=250)][button2][button3]-|",
		options: .AlignAllBaseline, metrics: nil, views: viewsDictionary))
~~~

Doing this using the absolute layout system involved a lot of heavy math calculation in your view controller. It isn't necessarily hard code to write, but the less code I can write, the happier a developer I am.

#### Prioritize Portions of Your Interface

Depending on the size of the screen or window you are working with, some portions of your UI may not be as important as others. For example, if you're laying out three labels and want to ensure that one will never be truncated, you can set it to have a higher priority than the views adjacent to it. Then when the labels are cramped for space, the others will truncate while the higher priority label will remain fully expanded.

Auto Layout calls this the **content hugging** and **compression resistance** priorities. We'll cover these more in depth in a later chapter.

### Zen?

What's with the "Zen" thing, you ask? When I was learning Auto Layout for the first time several years ago, I was running into many of the same barriers you likely were. Things didn't make sense. Stuff that was seemingly easy in the old absolute layout ways was costing me hours of time debugging.

Each time I would complain about this, my snarky, English coworker would look at me and say, "You just haven't reached Zen yet." From that point forward, each time something with Auto Layout began to click, I would say that I had leveled up my Auto Layout Zen.

Years later, the Zen mantra has stuck as I've worked to teach others how to embrace Apple's new layout system. Hopefully by the end of this book, you too will have achieved Zen.

### Issues Achieving Zen

Apple hasn't released numbers on Auto Layout adoption, but I'd be willing to wager that it isn't nearly as high as Apple would want. There will always be a subset of the developer base that is slow to adopt new technologies, but I also believe Auto Layout is at a disadvantage because it is such a departure from what has been used for years.

#### Auto Layout Is a Whole New Way of Thinking

When you adopt Auto Layout, you're throwing out all the knowledge you have from the absolute layout world. Instead of setting the view frames yourself, you're defining relationships between the views and putting that trust into a layout engine to handle the heavy lifting for you.

If you're working with animations, you're being told to forget your old ways of animating frames and instead to "animate the constraints." It's a whole new way of thinking about layout, but as developers, that's something we are used to. Auto Layout is an opportunity to learn a new, better way to write code. Embrace it with excitement. It's fun once you get the hang of it.

#### Xcode 4's Auto Layout Support Was Frustrating

I'd prefer to use another 'F' word to describe Xcode 4 and Auto Layout, but there might be children reading this book. Most people's first introduction to Auto Layout was with Xcode 4's Interface Builder toolkit, and it didn't do the technology any favors.

With Xcode 4, Interface Builder wouldn't allow your layout to get in an ambiguous state. It would instead continue adding constraints it believed were required to get the layout out of an ambiguous state, even if those weren't necessarily the constraints you wanted. On top of that, tools were also confusing and buggy to work with.

The good news is that Xcode 5's support for Auto Layout was vastly superior to its predecessor, and it only got better with Xcode 7. While Xcode 4 may not have made many people Auto Layout fans, Xcode 7 will bring them back.

#### Steep Learning Curve

Above all else, the Auto Layout system has a steep learning curve because it changes such a fundamental aspect of OS X and iOS development. You're no longer doing manual frame calculations and are instead writing these strange ASCII-Art formatted strings or working with an `NSLayoutConstraint` class method with 7 parameters to keep track of. With iOS 9, Apple has done some work to improve the verbosity of Auto Layout, but the core concepts under the hood remain the same.

I won't deny that the learning curve is steep, but once everything begins to click, the rewards more than pay off for the early frustration. I only truly embraced and adopted Auto Layout when I forced myself to use it for a major project and refused to fall back on my old knowledge and habits.

Hopefully, this book will help you get over that learning curve faster.

### Summary

At this point, I hope I've convinced you that taking this journey into the world of Auto Layout is worth it. In the next chapter, I'm going to cover some key terminology and concepts you'll need to understand in order to start laying out your own interfaces using the Auto Layout engine.

Buckle up.

\pagebreak
