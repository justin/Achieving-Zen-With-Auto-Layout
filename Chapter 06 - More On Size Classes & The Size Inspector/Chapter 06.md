Chapter 06 - More On Size Classes & The Size Inspector
====================================

### Adjusting for Landscape

In the last chapter, we spent all that time building the perfect log-in screen exactly to specification, and our CEO has now come back saying he wants a different interface layout when users rotate their phones into landscape mode so that the text fields are next to each other rather than on top of one another. This is why we can't have nice things.

Luckily, thanks to size classes and Auto Layout, we can make short work of his requests with only minimal changes required.

The storyboard editor in Xcode 7 allows us to adjust our interface based on the trait collections we are working with. Our first version of the layout was designed for any sort of device size scenario. For our new iPhone landscape UI, we are going to want to adjust our storyboard editor to show us the size class for _Any_ width and _Compact_ height.

![Size Class](./images/ch06-ss01.png)

1.  Click on the _Size Class_ popover.
2.  Adjust the grid in the popover to match the screenshot above.

When you are finished, the square that we were working with in our Storyboard editor should look more like a rectangle. We are now saying that we want to work with the interface with a compact height, but any width. This should cover our landscape iPhone scenario just fine.

Go ahead and drag the controls around to match our CEO's new expectations. You should have something similar to this:

![Our view laid out in landscape](./images/ch06-ss02.png)

Now, let's run our application in the iPhone simulator and rotate the device into landscape.

Wait. What? Why didn't our controls stay where we told them to?

The problem is that, while we moved the controls on screen in our storyboard editor, we didn't explicitly update our constraints to take into account that our layout has changed. In Auto Layout's eyes, we are still working with the constraints that defined our text fields in a linear state.

Fortunately, with iOS 8, Apple added the ability to enable and disable constraints based on what size class we are working with. Let's start updating our constraints to match our new setup in this compact height scenario.

### The Identity Inspector

The first thing I tend to do is disable any existing constraints I know I won't need for a certain size class. You can quickly do this in the sidebar of Interface Builder under the constraints listing for our view controller. To start, select the "Image View.centerX = centerX" constraint. This is the constraint we created in the previous chapter to ensure that our DeveloperTown logo was always centered vertically on the screen. Since we are now moving the image view to the left of our text fields, that's no longer the case.

To disable it, make sure the Identity Inspector is visible. (You can toggle it from the View menu under Utilities > Show Identity Inspector.) You should see the values for our CenterX attribute on the right side of the Xcode window. At the bottom of that inspector, there is a small plus icon and a checkbox that says "Installed." Click the plus icon and then choose "Any Width | Compact Height (current)."

![Adjusting constraints per trait collection](./images/ch06-ss03.png)

You should now have a second checkbox with a label of "wAny hC." This will let us toggle this constraint's activated state for our given size class. Go ahead and uncheck that. Now when we run our application and rotate into landscape mode on our iPhone, the CenterX constraint will be deactivated. If we are in portrait or any other size class, it will still be active.

Repeat the previous steps for the following constraints:

* Image View.top = Top Layout Guide.bottom
* Email Address.top = Image View.bottom + 50
* Round Style Text Field.centerX = centerX
* Round Style Text Field.centerX = centerX

![Constraint Inspector](./images/ch06-ss04.png)

At this point, we should have our view in a state where Interface Builder is complaining that we don't have enough constraints to have an unambiguous layout. This is indicated by the red arrow in the upper-right corner of the view controller's scene. If you click the arrow, you'll see a full dossier of what exactly we are missing to resolve our layout issues. We could let Xcode and Interface Builder add the preferred constraints for us, but as an exercise in learning, let's do it manually.

First, select the logo image view and create a new Center Y alignment constraint, which will say we want the image view always centered along the y-axis of our view when we are in this compact height state.

1. Click the image view in our view's scene.
2. Open the _Alignment Constraints_ popover and check the box next to _Vertically Center in Container._
3. Click _Add 1 Constraint._

You should now have this constraint added to your view. If you look at it in the Identity Inspector, you'll also notice that it is only installed when we have a trait collection containing any width and a compact height.

### Editing Constraints

Our view is still missing constraints. Most notably, none of our views know how to be placed along the x-axis because we disabled all those constraints. Let's go ahead and add a few new ones.

First, let's say that we want our e-mail address label to have its leading edge equal to the horizontal center of our view. This will take a few more steps than previous constraints we've added, so let's walk through it step-by-step.

1. Click on the e-mail address label to select it.
2. Hold down the Control key on your keyboard and use your mouse to drag from the email address label to anywhere in your view's canvas. You should see a semi-transparent overlay on screen with a few different options.
3. Click on _Center Horizontally in Container._
4. You should notice that it creates a new constraint with a red line along the x-axis. Select that.
5. In the Identity Inspector you should notice that the constraint says that the _First Item_ value is _Email Address.Center X._ Click on that pop-up menu and change the value to _Leading._
6. Repeat steps 1–5 for the password label. We want its leading edge to also be centered horizontally in our view.

![We can adjust our constraints with this handy popover, too.](./images/ch06-ss05.png)

The logo image view still needs a constraint along the x-axis. Let's say we want to pin its trailing edge to the leading edge of our e-mail address text field with about 50 points of padding.

1. Click on the image view to select it.
2. Hold down the Control key on your keyboard and use your mouse to drag from the image view to the email address text field and let go. You should see a semi-transparent overlay on screen again—this time with different options.
3. Click on _Horizontal Spacing_ to create that new constraint.
4. Select your newly created constraint and go to the Identity Inspector.
5. Adjust the _Constant_ value to be 50.

Getting closer! We still have a few missing constraints. Most notably, none of our views are quite certain where exactly along the y-axis they belong. We can fix that by telling our view that we always want our password label to be centered vertically along the y-axis.

1. Click the password label in our view's scene.
2. Open the _Alignment Constraints_ popover and check the box next to _Vertically Center in Container._
3. Click _Add 1 Constraint._

At this point, we should have our interface completely configured without any missing constraints for our compact height scenario. There are likely a few misplaced views on the storyboard canvas, however. Let's quickly fix that by going to the _Resolve Auto Layout Issues_ popover and selecting _Update Frames_ for all the views in our container.

![Everything in its right place.](./images/ch06-ss06.png)

Let's kick the tires on our new work. Launch the DeveloperTown application in your iPhone simulator of choice and test rotating the interface between both portrait and landscape orientations. It should just work!

### How the Sausage Is Made

You're probably noticing that we haven't written a single line of code to accomplish any of this. It's a WWDC demo come true! Even though we aren't managing any code ourselves, the Auto Layout engine is doing a variety of different things behind the scenes to make our lives as developers easier.

Prior to iOS 8, working with constraints in different orientations required adding and removing constraints. This wasn't ideal for a variety of reasons. The overhead of adding constraints isn't zero, so there was a slight performance penalty for each constraint that was being processed on each rotation. The more complex the view, the higher that penalty. Why was this? Each time you added new constraints to your views, the Auto Layout engine would have to go through the entire process of solving your constraints, calculating your frames, and redrawing everything on screen.

With iOS 8, Apple added support for activating and deactivating constraints. This is a far better way of dealing with constraints that don't need to be enabled at all times. Now, when you rotate between different orientations, your view just disables the constraints that aren't needed in the current trait collection. The key difference, however, is that when you go back to the previous orientation, the engine remembers all the calculations it had solved previously and can more easily apply those.

In general, you should opt for activating and deactivating constraints rather than adding and removing them.

### Summary

In this chapter, we moved our knowledge of size classes from theoretical to practical by adding a different set of constraints for our DeveloperTown screen in the landscape orientation. We also learned how to use the Identity Inspector in Xcode to adjust different values on our constraints. Finally, we covered what happens when we activate and deactivate constraints in our views.

Next, we are going to continue our deep dive into Auto Layout by writing some code to interact with our constraints.

\pagebreak
