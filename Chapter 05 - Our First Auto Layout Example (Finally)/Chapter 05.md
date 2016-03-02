
Chapter 05 - Our First Auto Layout Example (Finally)
====================================

The first part of our journey into Auto Layout was focused on understanding some of the core concepts and terminology associated with constraint-based layouts. With that knowledge stored in your head, let's focus on building our first interface using Auto Layout.

### Interface Builder

![Interface Builder](./images/ch05-ss01.png)

**If you are using Auto Layout, you should be using Interface Builder.** This is one of the most declarative statements I will make in this book, but that's because I am passionate about it.

Interface Builder has always been a great way to lay out your interface, providing a high-level visual overview of what your UI will look like on a user's OS X desktop or iOS device. Rather than requiring you to manage big chunks of tedious layout code, Interface Builder instead does all the heavy loading and lets you focus on the important functionality of your application.

One of the key reasons Auto Layout exists is to extend the usefulness of Interface Builder, and with Xcode 7, that usefulness is even more powerful. Each release of Xcode since version 4 has improved on the Auto Layout support in Interface Builder; as amateur Apple watchers, this should be a pretty obvious sign that Apple thinks this is important technology.

It's because of this that the next part of our adventure is going to take place almost exclusively in Interface Builder.

Beyond just the features Interface Builder affords us, visualizing the constraints you are working with makes understanding what Auto Layout is doing much easier to grok. I am a visual learner, so being able to see how my constraints-based relationships look on top of a representation of my interface is beneficial.

![Warnings / Errors Screenshot](./images/ch02-ss04.png)

I am also a major fan of free debugging, which Interface Builder offers. Rather than having to repeat the edit, compile, run, crash dance to discover that you have either missing or conflicting constraints, Interface Builder will instantly alert you and offer suggested ways to resolve the issues. It's not only a faster way to debug your issues, but it helps you better understand what does and doesn't please the constraints engine.

Have I sold you on Interface Builder? I hope so because it's time to build!

### Hello World

![Finished Sample Screenshot](./images/ch05-ss03.png)

Many books for software developers traditionally start with a "Hello World" example to implement the minimum amount of functionality required to talk about the basics of the project. With Auto Layout, a Hello World example would be fairly rudimentary—just two constraints applied to a label to vertically and horizontally center it.

I don't want to fully shun the ideas and traditions of "Hello World," however. In modern computing, we actually say "Hello World" multiple times a day as we sign in to various services. When you authenticate with the iOS Developer Center, you are saying "Hello World!" to Apple's servers in order to gain access to their information.

With that in mind, let's build a sign-in form for our imaginary social network for Apple platform developers, called DeveloperTown.

To get started, open Xcode and create a new Single View Application project. Name the product "DeveloperTown," set the organization name and identifier to your preferred settings, and set the language to Swift. Save the project wherever you keep your source code.

![Single View Project](./images/ch05-ss04.png)

Once we save DeveloperTown to disk, we are shown a skeleton project with an app delegate, starter view controller, and storyboard. Storyboards are Apple's preferred way of laying out high level interfaces on both iOS and OS X, so let's go ahead and keep that rather than using separate XIB files for our view controllers.

Open _Main.storyboard_, and you'll be presented with an empty square that defines our view controller's scene. If you're a seasoned iOS developer but haven't been working with iOS 8 or newer, this likely looks a little foreign. This is Apple's new concept of **size classes**.

### A not-so-brief aside on size classes

When iOS was first introduced, we had one device: the iPhone. It had a 320 × 480 pixel screen and it came in any color you liked, as long as it was black. Even in this single iteration, it supported two orientations: portrait and landscape.

Designing an app that supports two orientations isn't always as simple as letting views stretch and resize like Mobile Safari or Messages do. In a lot of cases, buttons and other controls need to be moved around to better take into account the altered sizing of landscape (480 × 320).

As iOS has matured and new devices have shipped, the number of different resolutions and screen sizes has grown. At the time of this writing, here's a sampling of the devices that you need to keep track of:

* 3.5″ retina screen devices (iPhone 4S)
* 4″ retina screen devices (iPhone 5+)
* 4.7″ retina screen devices (iPhone 6)
* 5.5″ 3x retina screen devices (iPhone 6 Plus)
* 7.9″ iPad without a retina display (iPad mini Gen 1)
* 7.9″ iPad with a retina display (iPad mini Gen 3)
* 9.7″ iPad with a retina display (iPad Air 2)

Don't forget to double that list to take into account portrait _and_ landscape resolution (especially those iPads!).

The current/old way of solving this problem has been a mix of observing orientation changes in your view controllers and custom views as well as using multiple XIBs or storyboards.

Let's say I was building a universal version of the [TED app][ted] that supported the iPad. With iOS 7 and older, I would need to create a secondary storyboard that had each of my view controllers re-established, its outlets redone, and its target/action sequences reconnected. Duplicate work. Any seasoned programmer knows this isn't ideal; making the same change in two different places goes against the entire DRY (Don't Repeat Yourself) principle.

Now, let's add in the areas where I wasn't necessarily using a storyboard or XIB. There would be checks in the code to detect orientation and device size,  so that I could adjust my constraints or frame-based layout code manually (like an animal).

The code would be littered with a lot of this:

~~~swift
let device = UIDevice.currentDevice()
let currentOrientation = device.orientation
let screenHeight = CGRectGetHeight(UIScreen.mainScreen().bounds)
let isPhone = (device.userInterfaceIdiom == UIUserInterfaceIdiom.Phone)
let isFivePhone = (screenHeight == 568.0)
let isSixPhone = (screenHeight == 667.0)
let isSixPlusPhone = (screenHeight == 736.0)
if (UIDeviceOrientationIsPortrait(currentOrientation) == true) {
  // Do Portrait Things.
  if (isPhone == true) {
    // Don't deny you've done this at least once.
    if (isFivePhone == true) {
      // iPhone 5+
    }
    else if (isSixPhone == true) {
      // iPhone 6
    }
    else if (isSixPlusPhone == true) {
      // iPhone 6 Plus
    } else {
      // Old iPhones
    }
  } else {
      // Do Portrait iPad Things.
  }
} else {
  // Do Landscape Things.
  if (isPhone == YES) {
    // Do Landscape iPhone Things.
  } else {
    // Do Landscape iPad Things.
  }
}
~~~

The solution to handling the growing list of screen sizes and orientations is **size classes**.

A size class is a new technology used by iOS to allow you to customize your app for a given device class based on its orientation and screen size.

There are two goals with size classes:

1.  To get developers and designers out of the habit of thinking in terms of specific devices and instead think of a more generalized approach.
2.  To plan for the future.

There are presently four size classes.

![Size Classes Chart](./images/ch05-ss05.jpg)

*   Horizontal Regular
*   Horizontal Compact
*   Vertical Regular
*   Vertical Compact

At any time, your device is going to have a horizontal size class and a vertical size class. Together, those are used to define which set of layout attributes and traits to show the user on-screen.

#### Traits

The horizontal and vertical size classes are considered **traits**. Along with the current interface idiom and the display scale, they make up what is called a trait collection.

This doesn’t just include where on-screen specific controls should be placed. Traits can also be used for things like image assets, assuming you are using Asset Catalogs. Instead of just having a 1x and 2x version of your asset, you can specify different image assets for a horizontally and vertically compact size class, as well as one for horizontally regular and vertically compact. In code, it still looks like the same UIImage call. The Asset Catalog takes care of rendering the appropriate image based on the current trait collection.

So how does that relate to us, Auto Layout, and Interface Builder?

The good news is that Interface Builder makes working with size classes easy, which we'll see in the next few sections.

### Laying Out Our UI

To start with, let's build DeveloperTown's sign-in screen using the default size class that will account for any device height or width. You can easily track which size class you are working with by clicking on the size class popover centered along the bottom of the storyboard editor.

![Interface Builder's Size Class Popover](./images/ch05-ss06.png)

To start, drag the following items onto your canvas:

*   2 text labels
*   2 text fields
*   1 button
*   1 image view

At this point, it doesn't really matter how you lay them out.

Now, let's build and run our application in the iPhone simulator. You'll notice that our views are laid out exactly where we put them on-screen. If you rotate the simulator into landscape, you'll notice that the constraints move to account for the new screen limitations. The items aren't necessarily where we want them to be, but there is still some Auto Layout magic happening under the hood.

In fact, if you add the following lines of code to your `ViewController` implementation, you can see exactly what is going on:

~~~swift
override func viewDidLayoutSubviews() {
  super.viewDidLayoutSubviews()
  print("self.view.constraints = \(self.view.constraints)")
}
~~~

Now if you run the application, you'll see a giant array of auto-generated constraints printed into the debugging console.

self.view.constraints = [<_UILayoutSupportConstraint:0x7ff23b418150
V:[_UILayoutGuide:0x7ff23b4232c0(20)]>, <_UILayoutSupportConstraint:
0x7ff23b426170 V:|-(0)-[_UILayoutGuide:0x7ff23b4232c0]
(Names: '|':UIView:0x7ff23b418c80 )>,
<_UILayoutSupportConstraint:0x7ff23b41b7d0
V:[_UILayoutGuide:0x7ff23b423f70(0)]>,
<_UILayoutSupportConstraint:0x7ff23b417860
_UILayoutGuide:0x7ff23b423f70.bottom == UIView:0x7ff23b418c80.bottom>,
<NSIBPrototypingLayoutConstraint:0x7ff23b425000 'IB auto generated at build
time for view with fixed frame' H:|-(129)-[UILabel:0x7ff23b419040'Label']
(LTR)   (Names: '|':UIView:0x7ff23b418c80 )>,
<NSIBPrototypingLayoutConstraint:0x7ff23b4254c0 'IB auto generated at build
time for view with fixed frame' V:|-(164)-[UILabel:0x7ff23b419040'Label']  
(Names: '|':UIView:0x7ff23b418c80 )>
... ])

Most of the constraints are using the private `NSIBPrototypingLayoutConstraint` class to define the constraints. If you don't explicitly define the constraints you want your view to take advantage of, Interface Builder will create a suite of `NSIBPrototypingLayoutConstraint` constraints it believes will accomplish what you are trying to lay out.

In general, I advise against relying on these. In some super basic use cases, it could be fine, but for any production-level application, even a small amount of complexity warrants being more explicit with your constraints. Moreover, as a developer, I prefer being in control of my own destiny rather than at the behest of the compiler or tools. By defining my own suite of constraints, I know exactly what is happening.

#### Defining Our Constraints

Usually when I am working on a new screen, I have some sort of predefined requirements. In best-case scenarios, I have a full design spec and visual mockups illustrating exactly how the interface should be laid out. At a minimum, I have a few rough sketches to show how I want the application to look.

In this case, I've sketched out the basic layout I want for DeveloperTown's sign-in screen.

![A wireframe sketch of our ideal completed project](./images/ch05-ss08.png)

As you can see from our wireframe, this is a fairly linear layout with the logo along the top, followed by labels and text fields for email and password. We then set the sign-in button to hug the bottom of the password field.

Let's adjust our storyboard's interface to match our wireframe's layout.

![Our UI laid out in Interface Builder](./images/ch05-ss09.png)

If you skipped the previous section, you might think we are done right here, but remember, `NSIBPrototypingLayoutConstraint` constraints aren't nearly as explicit as we want. We want to define our own constraints to tell our application exactly how things should be laid out.

Along the lower-right edge of the Interface Builder editor, you'll see four small buttons that you should become familiar with as you continue designing your interfaces with Auto Layout.

![The Auto Layout buttons in Interface Builder](./images/ch05-ss10.png)

When I am adding constraints, I like to work my way top-down and handle each control one-by-one. Our first control is our logo image view, which we want to be pinned towards the top edge of its parent view and then centered horizontally in its parent.

To do this:

1.  Select the image view.
2.  Click on the alignment constraints popover.
3.  Add a check to the _Horizontal Center in Container_ constraint.
4.  Set the _Update Frames_ popover value to be _Items of New Constraints_.
5.  Click _Add Constraints_.

Oh no! Our view disappeared! What happened?

In item four, we set the _Update Frames_ popover to redraw our image view taking into account the new constraints we have. In this case, our image view only has a single constraint setting its horizontal center. The Auto Layout engine doesn't know anything else about how to lay it out—its edges, its size, etc.

Often when I am working on adding a large number of constraints manually, I will leave _Update Frames_ set at none and simply add the constraints I need to eliminate any situation where the view will go off-screen. For the purpose of this exercise, however, it's beneficial to see how different constraints change the view's frame in the storyboard editor.

Next, let's add an edge constraint to explicitly set 20 points of padding from the top of the parent view from the top of the image view.

1.  Select the image view.
2.  Click on the _Edge Constraints_ popover.
3.  Make sure that _Constrain to Margins_ is checked.
4.  Set the value of the _Top_ text field to 20 and ensure that the line between the text field and the top of the square is red.
5.  Set the _Update Frames_ popover value to be _Items of New Constraints_.
6.  Click _Add Constraints_.

So where did our box go now? We said that we wanted it to be centered horizontally and hugging the top with 20 points of padding. Why isn't it showing up on the screen now? Since we haven't populated the image view in Interface Builder, it doesn't have an intrinsic content size to define the height and width of the view with.

There are three ways we can handle this.

1.  Adding an image to the view.
2.  Setting a placeholder intrinsic content size using Interface Builder.
3.  Adding explicit constraints for the height and width.

The first one is obvious and will give us a visual cue of how our layout is working. We won't learn much from doing that, however. The second option is the winner in most scenarios, but we are going to hold off on learning about that inspector until the next chapter.

In this case, let's set some explicit height and width constraints on our image view that will define that our DeveloperTown logo will always be 96 points wide and 96 points tall.

1.  Select the image view.
2.  Click on the _Edge Constraints_ popover.
3.  Click the _Width Constraint_ and set a value of 96.
4.  Click the _Aspect Ratio_ button. This will allow us to say we want a 1:1 relationship between our view's width and height.
4.  Set the _Update Frames_ popover value to be _Items of New Constraints_.
5.  Click _Add Constraints_.

We have our image view back on screen and exactly where we wanted it!

One view down, five to go.

Next, we will focus on the relationship between our labels and the text fields. In our view, you'll notice that we have the left (or leading) edge of the labels lined up with the left edge of our text fields. When working with text, you want to use leading and trailing constraints. By doing this, iOS and OS X are able to account for left-to-right languages when rendering your views on screen.

Let's go ahead and make a few explicit constraints to define those relationships.

1.  Select both the e-mail address label and its related text field.
2.  Click on the _Alignment Constraints_ popover.
3.  Click the checkbox for the _Leading Edges_ constraint. Don't bother setting a value in the text field; 0 is fine.
4.  Click _Add Constraints_.
5.  Repeat steps 1-4 for the password label and its text field.

This isn't so bad, right? We're just defining the relationships that each of our views have with one another on screen. We're still missing some necessary constraints, though.

Let's add relationships between the trailing edges of our labels and their text fields. With these, we want to say that our labels shouldn't be any wider than our text fields. Otherwise, our designers will have to take their plaid shirts to the dry cleaners to wash away the tears of despair.

1.  Select both the e-mail address label and its related text field.
2.  Click on the _Alignment Constraints_ popover.
3.  Click the checkbox for the _Trailing Edges_ constraint. Don't bother setting a value in the text field; 0 is fine.
4.  Click _Add Constraints_.
5.  Repeat steps 1-4 for the password label and its text field.

Next, we will focus on the text fields. Notice how in our wireframe above the text fields were centered within the parent view just like our logo was? We need to add those constraints to make an explicit relationship between our text fields' horizontal centers and the view controller view's center.

1.  Select the e-mail address text field.
2.  Click on the _Alignment Constraints_ popover.
3.  Click the checkbox for the _Horizontal Center in Container_ constraint.
4.  Click _Add Constraints_.
5.  Repeat steps 1-4 for the password text field.

Now let's set explicit width constraints on the text fields to be 200 points wide. Later on, we'll adjust these to take into account the multiplier, but for now, this will get us a usable interface.

1.  Select the e-mail address text field.
2.  Click on _Edge Constraints_ popover.
3.  Click the _Width Constraint_ and set a value of 200.
4.  Click _Add Constraints_.
5.  Repeat steps 1-4 for the password text field.

We are still missing some constraints we need to finish defining the relationships for the text fields and labels. The big issue is that we haven't explicitly defined where on the y-axis our views are supposed to be laid out. There are a few different relationships we need to define to resolve those issues.

The first thing you may notice is that there is a relationship between the bottom of our logo image view and the e-mail label. We want to have a set amount of padding between the two, so our input fields hug the top of the view. Let's set an explicit vertical space relationship between our image view and the e-mail address label.

1.  Select the image view.
2.  Hold down the Control key and drag your cursor over to the e-mail address label.
3.  In the popover that appears, click on _Vertical Spacing_.

You should see a new constraint added to our canvas that defines the relationship between the bottom of our image view and the top of our email address label.

We should also set vertical space relationships between our labels and the text fields. We want to have about 8 points of spacing between the bottom of the label and the top of the text field.

1.  Select the e-mail address text field.
2.  Click on the _Edge Constraints_ popover.
3.  Set the value of the _Top_ text field to 8 and ensure that the line between the text field and the top of the square is red.
4.  Click _Add Constraints_.
5.  Repeat steps 1-4 for the password text field.

We've just defined vertical spacing relationships between our text fields and their labels, but we accomplished it in a different way than the Control-dragging we did for the relationship between the logo view and the e-mail address label.

The edge constraints popover has the concept of being able to define edge constraints with a selected view and its nearest neighbor. In the case of the text fields, the nearest neighbors are its respective labels.

Next, let's set a vertical spacing relationship between the bottom of the e-mail address text field and the top of the password label so that they line up nicely.

1.  Select the e-mail address text field.
2.  Click on the _Edge Constraints_ popover.
3.  Set the value of the _Bottom_ text field to 15 and ensure that the line between the text field and the top of the square is red.
4.  Click _Add Constraints_.

Now, what should we do about the sign-in field? We want its left edge to hug the left edge of our password text field and the top of it to be about 15 points away from the bottom of the password text field. Let's establish those relationships.

1.  Select both the sign-in button and the password text field.
2.  Click on the _Alignment Constraints_ popover.
3.  Click the _Leading Edges_ checkbox. Leave the text field set to 0.
4.  Click _Add 1 Constraint_.
5.  Select the sign-in button.
6.  Click on the _Edge Constraints_ popover.
7.  Set the _Top_ text field to 15 and ensure that the line between the text field and the top of the square is red.
8.  Click _Add 1 Constraint_.

At this point, we have all of our constraints defined (finally), but things don't look entirely right on screen.

Our labels and the sign-in button are still truncated, which isn't good for users who need the guidance from the text in those.

To resolve this, click on the triangle button in the lower-right corner of the Interface Builder editor. This is your go-to spot to resolve any weird layout issues or get back to a normal state if you go out in the weeds definining constraints.

In the menu that appears from the resolution button, select _Update Frames_, which will go through the process of updating the frame of each of your views on screen to match the constraints you have defined.

If everything is defined as it should be, your interface should look great!

Let's run the application in the iPhone simulator to see our handiwork.

![Our completed project](./images/ch05-ss11.png)

As you can see, everything is laid out exactly as we intended. If we rotate between landscape and portrait, our constraints are respected, and everything renders as we defined.

If this were an Apple demo at WWDC, I would point out that, so far, we have written zero lines of code to accomplish laying out our entire interface for both portrait and landscape orientations.

That's the power of Auto Layout.

### Summary

In this chapter, we started our journey toward achieving Auto Layout zen using Xcode 7's constraints editor to lay out a basic user interface. We learned about the reasoning behind size classes and took that into account when building our interface.

We have only scratched the surface of what is available in Interface Builder's support for Auto Layout. In the next chapter, we are going to build on what we've done here and start diving deeper into the power of size classes and customizing our constraints using Interface Builder.

[ted]: http://ted.com/

\newpage
