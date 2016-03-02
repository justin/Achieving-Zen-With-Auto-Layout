
Chapter 10 - Debugging Constraints
====================================

At this point, you have developed a fairly solid foundation of the hows and whys of Auto Layout. In fact, I'm hoping you've even taken the time to convert a few of your own production projects to begin using the technology!

Auto Layout isn't all roses and sunshine, however. Like all development technologies, things do go wrong. Whether there are missing constraints in your view, too many constraints, or possibly conflicting ones—as developers, we have to spend part of our time debugging when our layouts don't look just as we expected.

The focus of this chapter will be to share a variety of different tools and techniques I use for figuring out what is happening with the Auto Layout engine and why it's not doing what I expect.

### Painting by Memory Address

Let's say we are working with a view that has a large number of similar controls—a video player, perhaps. The main component of the view is going to be the `AVPlayerLayer`, which actually displays the video, but to control it, we're going to have a variety of different controls:

* A fast-forward button
* A rewind button
* A play/pause button
* A label showing how long the video has been playing
* A slider to show our progress
* A label showing how long the video has remaining
* An Airplay button
* Maybe even a Chromecast button

Here's a situation in which we have five different buttons that are likely going to be image-based rather than text-based. If we were to break after our video player view had laid out its content, we could print out the listing of constraints in that toolbar and get something like this:

```
(lldb) po self.bottomHUD.constraints
<__NSArrayM 0x7feed0492640>(
<NSLayoutConstraint:0x7feed0485c30 H:|-(20)-[UIButton:0x7feed0448e50]
  (Names: '|':AZLVideoPlayerBottomHUD:0x7feed0452d50 )>,
<NSLayoutConstraint:0x7feed0485cb0 H:[UIButton:0x7feed0448e50(30)]>,
<NSLayoutConstraint:0x7feed0485d00 H:[UIButton:0x7feed0448e50]-(20)-
  [AZLVolumeView:0x7feed0474bc0]>,
<NSLayoutConstraint:0x7feed0485d50 H:[AZLVolumeView:0x7feed0474bc0(30)]>,
<NSLayoutConstraint:0x7feed0485da0 H:[AZLVolumeView:0x7feed0474bc0]-
  (NSSpace(8))-[AZLChromecastButton:0x7feed047a280]>,
<NSLayoutConstraint:0x7feed0485e20 H:[AZLChromecastButton:0x7feed047a280]-
  (20)-[UILabel:0x7feed045a290]>,
<NSLayoutConstraint:0x7feed0485e70 H:[UILabel:0x7feed045a290(<=100@900)]
  priority:900>,
<NSLayoutConstraint:0x7feed0485f10 H:[UILabel:0x7feed045a290]-(NSSpace(8))-
  [AZLBufferingSlider:0x7feed0459930]>,
<NSLayoutConstraint:0x7feed0485f60 H:[AZLBufferingSlider:0x7feed0459930(>=75)]>,
<NSLayoutConstraint:0x7feed0485fb0 H:[AZLBufferingSlider:0x7feed0459930]
  -(NSSpace(8))-[UILabel:0x7feed04767b0]>,
<NSLayoutConstraint:0x7feed0486000 H:[UILabel:0x7feed04767b0(>=10)]>,
<NSLayoutConstraint:0x7feed048b0a0 H:[UILabel:0x7feed04767b0(<=100)]>,
<NSLayoutConstraint:0x7feed0485ec0 H:[UILabel:0x7feed04767b0]-(20)
  -[UIButton:0x7feed04816e0]>,
<NSLayoutConstraint:0x7feed048b170 H:[UIButton:0x7feed04816e0(30)]>,
<NSLayoutConstraint:0x7feed048b1c0 H:[UIButton:0x7feed04816e0]-(20)
  -[UIButton:0x7feed047f2d0]>,
<NSLayoutConstraint:0x7feed048b210 H:[UIButton:0x7feed047f2d0(30)]>,
<NSLayoutConstraint:0x7feed048b260 H:[UIButton:0x7feed047f2d0]-(20)-|
    (Names: '|':AZLVideoPlayerBottomHUD:0x7feed0452d50 )>,
<NSLayoutConstraint:0x7feed048b0f0 V:[UIButton:0x7feed0448e50(30)]>,
<NSLayoutConstraint:0x7feed048b450 V:[AZLVolumeView:0x7feed0474bc0(30)]>,
<NSLayoutConstraint:0x7feed048b4a0 UIButton:0x7feed047f2d0.centerY
  == AZLVideoPlayerBottomHUD:0x7feed0452d50.centerY>,
<NSLayoutConstraint:0x7feed048b4f0 AZLBufferingSlider:0x7feed0459930
  .centerY == AZLVideoPlayerBottomHUD:0x7feed0452d50.centerY>,
<NSLayoutConstraint:0x7feed048b540 UIButton:0x7feed04816e0
  .centerY == AZLVideoPlayerBottomHUD:0x7feed0452d50.centerY>,
<NSLayoutConstraint:0x7feed048b590 UILabel:0x7feed04767b0.centerY ==
  AZLVideoPlayerBottomHUD:0x7feed0452d50.centerY>
)
```

That's a lot to look at grok. It's also not the most helpful output when you see something like `UIButton:0x7feed04816e0`. I don't speak memory addresses that well, so I'm not sure exactly which button the constraint is related to.

A quick way to figure out which specific constraint you're dealing with is to adjust its background color in LLDB.

To do this:

1.  Open the DeveloperTown sample project from a previous chapter.
2.  Open the `ViewController.swift` file and add the following snippet of code to it:

~~~swift
override func viewDidLayoutSubviews() {
  super.viewDidLayoutSubviews()
}
~~~

3.  Set a breakpoint in the new `viewDidLayoutSubviews` method.
2.  Run the application in the iOS simulator. It should stop on your breakpoint.
3.  In LLDB type the following: `po self.view.constraints`. You should see a listing of constraints for the labels, text fields, sign-in button, and image view from our view.
4.  Find the `UIImageView` and take note of its memory address.
5.  Type the following in LLDB: `expr -l objc++ -O -- ((UIImageView *)0x123456).backgroundColor = [UIColor redColor]
`. In this case, _0x123456_ is the memory address you noted from step 4.
6. Press Return.
7. Type "continue," so the application runs again.

At this point, the `UIImageView` should be highlighted with red in our application.

One thing you will notice about this `expression` call is that we are routing things through Objective-C rather than Swift directly. At present time, there are a lot of things related to debugging Swift and Auto Layout that are easier to do with Objective-C. I can only assume this will improve in future releases of OS X and iOS as the Swift languages and LLDB continue to mature.

This isn't an Auto Layout-specific debugging technique, but it's one I use often whenever I am working with complex views and only have information about the control type and its memory address.

### Interface Builder Tricks

If you look at our DeveloperTown example, you'll see the long list of constraints listed in the storyboard's sidebar.

![Quick Look Default](./images/ch10-ss01.png)

This isn't the most helpful listing of constraints you'll ever find. For one thing, there doesn't seem to be any sort of rhyme or reason behind the organization of it. Second, the listing is often truncated, so you only see the first part of what the constraint is related to.

Interface Builder allows you to set a specific label for each constraint, which I try to take advantage of when I'm working with a view with many constraints. To me, setting Xcode-specific labels on each of the controls and constraints in a XIB or storyboard is analogous to commenting code you write.

To set up Xcode labels for your constraints:

1.  Open the Main.storyboard for our DeveloperTown project.
2.  Ensure that the Utilities pane is open by going to the _View_ menu and clicking on _Utilities > Show Identity Inspector._
3.  In the constraints list for your view controllers scene, select any of the available constraints.
4.  In the Utilities sidebar, you should see a _Label_ field under the _Document_ section. Set that to any text you want.
5.  Notice how the text for the constraint is now updated to match what that label is.

I have a specific method for how I label constraints. The format follows along the pattern of:

    [Constraint Attribute] Control 1 + Control 2

As an example, our view has a trailing constraint that dictates that the trailing edge of our e-mail address label should be equal to the trailing edge of the e-mail address text field. I'd label that as:

    [TRAILING] E-mail Label + Field

For the Center X constraint that dictates the image view be centered with its parent view, I'd type:

    [CENTERX] Logo View + Parent

It takes just a few moments to set these constraint labels, but it goes a long way towards readability and easier debugging when you're trying to find a specific constraint to toggle in your application.

### \_autoLayoutTrace

One of the few debugging options that Apple touts in their documentation is the private `_autolayoutTrace` method on `UIView`. This is a quick way to see a hierarchy of the subviews contained in your parent view and to determine whether any of those views are in an ambiguous state.

Ambiguous layout refers to the Auto Layout engine (`NSISEngine` if we're being specific) being incapable of figuring out how exactly it should lay out a view, given the constraints that you have defined. In some situations, you don't have enough constraints, so there are two possible outcomes. In other situations, it could be related to having too many constraints or even conflicting ones.

If things are not rendering on screen exactly where I think they should be, `_autolayoutTrace` is usually the first thing I call to see if there are any situations where I have ambiguous layout.

To run `_autolayoutTrace` in Swift, do the following:

1.  Open the DeveloperTown sample project and set a breakpoint in the `ViewController.swift` `viewDidLayoutSubviews()` method.
2.  Run the application in the iOS simulator. It should stop on your breakpoint.
3.  In LLDB, type the following: `expr -l objc++ -O — [[UIWindow keyWindow] _autolayoutTrace]`.

You should see an output similar to this:

```
(lldb) expr -l objc++ -O — [[UIWindow keyWindow] _autolayoutTrace]
UIWindow:0x7feedad296d0
|   •UIView:0x7feedac7c1c0
|   |   *UILabel:0x7feedac84450'E-mail address'
|   |   *UILabel:0x7feedac865d0'Password'
|   |   *UIImageView:0x7feedac86ae0
|   |   *UITextField:0x7feedac87460
|   |   |   _UITextFieldRoundedRectBackgroundViewNeue:0x7feedac90a60
|   |   *UIButton:0x7feedac937d0'Sign-In'
|   |   *UITextField:0x7feedac94860
|   |   |   _UITextFieldRoundedRectBackgroundViewNeue:0x7feedac95be0
|   |   *_UILayoutGuide:0x7feedac96050
|   |   *_UILayoutGuide:0x7feedac96a80
```

The view hiearachy starts with the `UIWindow`, and then the `UIView` at memory address "0x7feedac7c1c0" contains all of the subviews.

You'll notice that we are not in an ambiguous state, because there's no mention of it by `_autolayoutTrace`. What if we wanted to force that to see what things look like?

To do that, go back to your "Main.storyboard" file and delete all the constraints in it. Save those changes and repeat steps 2–4 from above. The output this time should be a bit different:

```
(lldb) expr -l objc++ -O -- [[UIWindow keyWindow] _autolayoutTrace]

UIWindow:0x7fc5a1e3dae0
|   •UIView:0x7fc5a3b23f70
|   |   *UILabel:0x7fc5a3b21be0'E-mail address'-
  AMBIGUOUS LAYOUT for UILabel:0x7fc5a3b21be0'E-mail address'.Width{id: 26}
|   |   *UILabel:0x7fc5a3b24240'Password'-
  AMBIGUOUS LAYOUT for UILabel:0x7fc5a3b24240'Password'.Width{id: 38}
|   |   *UIImageView:0x7fc5a3b24750
|   |   *UITextField:0x7fc5a3b251b0
|   |   |   _UITextFieldRoundedRectBackgroundViewNeue:0x7fc5a3b2eb30
|   |   *UIButton:0x7fc5a3b318f0'Sign-In'
|   |   *UITextField:0x7fc5a3b32b30
|   |   |   _UITextFieldRoundedRectBackgroundViewNeue:0x7fc5a3b340d0
|   |   *_UILayoutGuide:0x7fc5a3b34530
|   |   *_UILayoutGuide:0x7fc5a3b34f60

Legend:
  * - is laid out with Auto Layout
  + - is laid out manually but is represented in the layout engine
    because translatesAutoresizingMaskIntoConstraints = YES
  • - layout engine host
```

See? Now we know that the `UILabel` instances for "E-mail address" and "Password" are in an ambiguous state. In fact, if you let the app continue to run you'll see that the views are no longer positioned properly in the simulator window.

`_autolayoutTrace` is likely one of the tools you will use most when debugging what is going on with Auto Layout constraints when things go awry.

Frequently typing that long of a statement is a bit tedious, so I like to put it in my `.lldbinit` file.

~~~
command alias alt expr -l objc++ -O -- [[UIWindow keyWindow] _autolayoutTrace]
~~~

Now you can just type "alt" and get the same output from the debugger.

You’ll notice that I am throwing this out for the entire contents of the keyWindow. What about if you wanted to just print out a single view? To do that, try pasting this into your .lldbinit file instead.

~~~
command regex alt ‘s/(.+)/expr -l objc++ -O — [%1 _autolayoutTrace]/’
~~~

Now you can type something like alt self.tableView and have the resulting view’s hierarchy printed out exclusively.

If you’re mixing Objective-C and Swift, you probably already have a bridging header. You can add a category on `UIView` that exposes the `recursiveDescription` and `_autolayoutTrace` methods to Swift.

~~~objectivec
#ifdef DEBUG
@interface UIView (LayoutDebugging)
#pragma clang push
#pragma clang diagnostic ignored “-Wincomplete-implementation”
- (id)recursiveDescription;
- (id)_autolayoutTrace;
#pragma clang pop
@end
#endif
~~~

And the implementation file.

~~~objectivec
#import “UIView+LayoutDebugging.h”
#ifdef DEBUG
@implementation UIView (LayoutDebugging)
// Nothing to see here!
@end
#endif
~~~

Let’s walk through this. You’ll notice that I have the entire thing wrapped in an `#ifdef DEBUG` statement because I am working with private APIs, which I presume the App Store usage checker would use to flag and reject your app. With the `#ifdef`, I am saying that this should only be included on development builds. Apple will have no idea what abuses we are committing, since it will never make it to the release builds!

The other atrocity I am including in this file is the use of `#pragma clang diagnostic` to tell the compiler to ignore any "uninmplemented method" warnings that will pop up from not being able to find an implementation for the two methods we defined in our category. Since they exist as private API, we don’t need to reimplement them.

Now, if you break in a Swift frame with LLDB and call `self.view._autolayoutTrace()`, you’ll get the output you expected.

# Layout Identifiers

Sometimes, when you are working with an array of constraints through a command like `autoLayoutTrace()`, it can be difficult to grok exactly which constraint is which. Using the `identifier` property on `NSLayoutConstraint` allows you to give a human-readable name to each of your constraints, either in a storyboard or your source code. When you set the identifier, it is appended to the constraint's `description()` in the debugger.

    <NSLayoutConstraint:0x7fb0ea62beb0 'Logo View Center X '
      UIImageView:0x7fb0ea626440.centerX == UIView:0x7fb0ea61fc20.centerX>

In this case, I set the constraint's `identifier` property to "Logo View Center X," since that accurately describes what the constraint is. Let's add that to your sample project.

Open up the `Main.storyboard` file and select the constraint that horizontally centers the image view in its parent. Open the Identity Inspector and set the "identifier" text field value to "Logo View Center X."

![Constraint identifiers](./images/ch10-ss04.png)

When you run your program and print out the constraints, the identifier should be included as part of the payload.

### Restoration Identifiers

From what I've shown you in in debugging output thus far—through the `constraints` property and calling the `_autolayoutTrace` method—you've probably come to realize that the output you get from the debugger isn't super helpful in complex scenarios. Knowing that a constraint is related to a `UIButton` at a specific memory address is nice, but which button is it?

In iOS, we can get a bit of an assist in figuring out the answer to this question by using restoration identifiers, a feature that Apple added in iOS 6 to make resuming an application that has been terminated less jarring for the user. A restoration identifier is just a simple `NSString` to define each of your views, so when you are unarchiving the view on launch, you have an easily-named reference.

We can use that restoration identifier to override some of the properties of the `NSLayoutItem` protocol that `UIView` conforms to. The protocol has a few different methods that the Auto Layout engine uses to help figure out how to solve its constraints and lay out the views. The two methods we care about overriding are `- (NSString *)nsli_description` and `- (BOOL)nsli_descriptionIncludesPointer`. We are going to adjust both of those to check for the existence of the `restorationIdentifier` property on a view and then change the output that `nsli_description` provides accordingly.

1.  Open the DeveloperTown sample project for this chapter and set a breakpoint in the `ViewController.swift` `viewDidLayoutSubviews` method.
2.  Open the "Main.storyboard" file.
3.  If you worked through the previous examples, the Identity Inspector panel should be open. If its not, go to the _View_ menu and click on _Utilities > Show Identity Inspector._
4.  Select your "E-mail address" label in and set its _Restoration ID_ property in the Identity Inspector to "EmailLabel."
5.  Go through the rest of the controls and set an appropriate restoration ID for them as well.

At this point, we haven't really done anything to change the output we get. If you were to run the application and print `[self.view constraints]` in the LLDB console, the results would be the same. What we need to add is a category on `UIView` that overrides our two `NSLayoutItem` protocol methods.

If you didn't in the previous section, create a new Objective-C category file on `UIView` called `ALZExtensions` and name it `UIView+ALZExtensions` In the `UIView+ALZExtensions.m` file, add the following block of code inside the implementation.

~~~objectivec
#ifdef DEBUG

- (NSString *)nsli_description {
  return [self restorationIdentifier] ?: [NSString stringWithFormat:
    @"%@:%p", [self class], self];
}

- (BOOL)nsli_descriptionIncludesPointer {
  return [self restorationIdentifier] == nil;
}

#endif
~~~

Now, if we run our application and print out the values from `[self.view constraints]` in LLDB, we'll get a much nicer output.

    (lldb) po [self.view constraints]
    <__NSArrayM 0x7fef41c1a7a0>(
    <NSLayoutConstraint:0x7fef41d25f50 EmailLabel.trailing ==
      EmailField.trailing   (Names: EmailLabel:0x7fef41d21dd0,
          EmailField:0x7fef41d24fc0 )>,
    <NSLayoutConstraint:0x7fef41d2d4c0 V:[CompanyLogo]-(20)-[EmailLabel]
      (Names: EmailLabel:0x7fef41d21dd0, CompanyLogo:0x7fef41d245b0 )>,
    <NSLayoutConstraint:0x7fef41d185e0 V:[EmailLabel]-(8)-[EmailField]
      (Names: EmailField:0x7fef41d24fc0, EmailLabel:0x7fef41d21dd0 )>
    )

Seeing "EmailLabel.trailing == EmailField.trailing" in the constraint description instantly lets me know which two attributes I am working with. This is much clearer than "UILabel:MemoryAddress.trailing == UITextField:MemoryAddress.trailing."

You'll notice that I wrapped the `ALZExtensions` category overrides in an `#ifdef DEBUG` block. If you're submitting to the App Store, Apple will reject your app for using those methods, so we're going to make sure they don't go along with your release builds.

### Quick Look

In Xcode 5, Apple added the ability to use Quick Look to see a variety of information in the debugger simply by pressing the space bar on its instance variable. This has been super useful for things like debugging images or custom views that you've rendered.

![Quick Look Default](./images/ch10-ss02.png)

We aren't limited to the default set of Quick Look plugins provided by Xcode, though. We can write our own custom Quick Look output for any class we are working with. Let's do it for `NSLayoutConstraint`!

In the DeveloperTown project, create a new Swift extension on `NSLayoutConstraint`. Name it `NSLayoutConstraint+ALZExtensions.swift`.

Then, in the `NSLayoutConstraint+ALZExtensions.swift` file, paste the next blob of code into the implementation.

~~~swift
extension NSLayoutConstraint {
  func nameForLayoutAttribute(attribute:NSLayoutAttribute) -> String {
    switch (attribute) {
    case NSLayoutAttribute.Left: return "left";
    case NSLayoutAttribute.LeftMargin : return "leftMargin";
    case NSLayoutAttribute.Right: return "right";
    case NSLayoutAttribute.RightMargin: return "rightMargin";
    case NSLayoutAttribute.Top: return "top";
    case NSLayoutAttribute.TopMargin: return "topMargin";
    case NSLayoutAttribute.Bottom: return "bottom";
    case NSLayoutAttribute.BottomMargin: return "bottom";
    case NSLayoutAttribute.Leading: return "leading";
    case NSLayoutAttribute.LeadingMargin: return "leadingMargin";
    case NSLayoutAttribute.Trailing: return "trailing";
    case NSLayoutAttribute.TrailingMargin: return "trailingMargin";
    case NSLayoutAttribute.Width: return "width";
    case NSLayoutAttribute.Height: return "height";
    case NSLayoutAttribute.CenterX: return "centerX";
    case NSLayoutAttribute.CenterXWithinMargins: return "centerXmargins";
    case NSLayoutAttribute.CenterY: return "centerY";
    case NSLayoutAttribute.CenterYWithinMargins: return "centerYmargins";
    case NSLayoutAttribute.Baseline: return "baseline";
    case NSLayoutAttribute.LastBaseline: return "lastBaseline"
    case NSLayoutAttribute.FirstBaseline: return "firstBaseline"
    case NSLayoutAttribute.NotAnAttribute: return "not-an-attributes"
    }
  }

  func debugQuickLookObject() -> AnyObject? {
    var relation = "EQUALS"
    if (self.relation == NSLayoutRelation.LessThanOrEqual) {
        relation = "GREATER THAN OR EQUAL"
    } else if (self.relation == NSLayoutRelation.Equal) {
        relation = "LESS THAN OR EQUAL"
    }

    return "\n\(firstItem) : \(nameForLayoutAttribute(firstAttribute))" +

    "\n\n [ \(relation) ]" +
    "\n\n\(secondItem) : \(nameForLayoutAttribute(secondAttribute))" +
    "\n\nPriority:\(priority)" +
    "\nMultiplier: \(multiplier)" +
    "\nConstant: \(constant)"
  }
}
~~~

The method we care about most right now is `debugQuickLookObject()`, where the actual magic is happening. If you override this method, you can pass back pretty much anything you want, although in most cases, you want it to be text or an image of some sort. In our situation, we're generating a custom string that contains information on a specific constraint. The second method in our implementation, `nameForLayoutAttribute()`, is merely a helper method I use to convert an enum value, such as `NSLayoutAttribute.LeftMargin`, to a standard string: "leftMargin."

This may seem like a strange use-case, but if you are holding references to any constraints as properties in your classes, it's nice to be able to get a quick output of what the constraint is doing.

![Quick Look Improved](./images/ch10-ss03.png)

### Cocoa Layout Instruments

The final tool in my belt is one that I don't believe a lot of developers know about or take advantage of. Instruments added a Cocoa Layout instrument several years ago for OS X developers to see what the Auto Layout engine is doing when your application is running.

What they didn't tell you is that you can also run this instrument in the iOS Simulator to get the same sort of information on your iPhone and iPad apps.

The Cocoa Layout instrument will show each constraint that is added to or removed from your view and when it is updated.

To use the instrument, do the following:

1.  In the _Build_ menu of Xcode, select _Profile._ This will kick off an Instruments session for your application.
2.  When Instruments opens, select the _Cocoa Layout_ tool from the list of items under _OS X._
3.  Start recording your Instruments session and watch as the information starts pouring into Instruments about constraints being created and adjusted.

I rarely use this on an everyday basis, but if I'm seeing weird issues with rendering or if something isn't rotating properly, it can be super useful to have a dossier of everything the `NSISEngine` is doing.

### Summary

In this chapter, we covered a variety of ways we can debug our Auto Layout-powered views using Apple's built-in tools and a few extra bits of trickery. At this point, you should be a fairly well-rounded Auto Layout expert.

We've reached the end of our journey towards Auto Layout zen. You now have the knowledge and tools you need to go forward and build excellent Mac and iOS apps. I look forward to seeing what you make.

\pagebreak
