Chapter 06 - More On Size Classes & The Size Inspector
====================================

### Adjusting For Landscape

In the last chapter, spent all that time building the perfect login screen exactly to specification, and our CEO has now come back saying he wants a different interface layout for when users rotate their phones into landscape mode so that the text fields are next to each other rather than on top of one another. This is why we can't have nice things.

Luckily, thanks to size classes and Auto Layout we can make short work of his requests with only a minimal amount of changes required.

The Storyboard editor in Xcode 7 allows us to adjust our interface based on the trait collections we are working with. Our first version of the layout was designed for any sort of device size scenario. For our new iPhone landscape UI, we are going to want to adjust our Storyboard editor to show us the size class for a _Any_ width and _Compact_ height.

![Size Classs](./images/ch06-ss01.png)

1.  Click on the Size Class popover.
2.  Adjust the grid in the popover to match the screenshot above.

When you are finished, the square that we were working with in our Storyboard editor should now look more like a rectangle. We are now saying that we want to work with the interface with a compact height, but any width. This should cover our iPhone in landscape scenario just fine.

Go ahead and drag the controls around to match our CEO's new expectations. You should have something similar to this:

![Our view laid out in landscape](./images/ch06-ss02.png)


Now, let's run our application in the iPhone simulator and rotate the device into landscape.

Wait. What? Why didn't our controls stay where we told them to?

The problem is that while we moved the controls on screen in our Storyboard editor, we didn't explicitly update our constraints to take into account that our layout has changed. In Auto Layout's eyes, we are still working with the constraints that defined our text fields in a linear state.

Luckily with iOS 8, Apple added the ability to enable and disable constraints based on what size class we are working with. Let's start updating our constraints to match our new setup in this compact height scenario.

### The Identity Inspector

The first thing I tend to do is disable any existing constraints I know I won't need for a certain size class. You can quickly do this in the sidebar of Interface Builder under the Constraints listing for our view controller. To start, select the "Image View.centerX = centerX" constraint. This is the constraint we created in the previous chapter to ensure that our DeveloperTown logo was always centered vertically on the screen. Since we are now moving the image view to the left of our text fields, that's no longer the case obviously.

To disable it, ensure the Identity Inspector is visible. You can toggle it from the 'View' menu under 'Utilities'->'Show Identity Inspector'. You should now see the attributes for our CenterX attribute on the right side of the Xcode window. At the bottom of that inspector there is a small plus icon and a checkbox that says "Installed". Click the checkbox and then "Any Width | Compact Height (current)".

![Adjusting constraints per trait collection](./images/ch06-ss03.png)

You should now have a second checkbox with a label of "wAny hC". This is a toggle button that will let us toggle this constraint's activated state for our given size class. Go ahead and uncheck that. Now when we run our application and rotate into landscape mode on our iPhone, the CenterX constraint will be deactivated. If we are in portrait, or any other size class it will still be active.

Let's go ahead and repeat the previous steps for the following constraints:

* Image View.top = Top Layout Guide.bottom
* Email Address.top = Image View.bottom + 50
* Round Style Text Field.centerX = centerX
* Round Style Text Field.centerX = centerX

![Constraint Inspector](./images/ch06-ss04.png)

At this point we should have our view in a state where Interface Builder is complaining that we don't have enough constraints to have an unambiguous layout. You can tell this by the red arrow in the upper-right corner of the view controller's scene. If you click the arrow, you'll see a full dossier of what exactly we are missing to get resolve our layout issues. We could let Xcode and Interface Builder add its preferred constraints for us, but as an exercise in learning let's do it manually.

First let's select the logo image view and create a new Center Y Alignment constraint that will say we want the image view always centered along the Y axis of our view when we are in this compact height state.

1. Click the image view in our view's scene.
2. Open the alignment constraints popover and check the box next to "Vertically Center in Container."
3. Click "Add 1 Constraint."

You should now have this constraint added to your view. If you look at it in the Identity Inspector you'll also notice that it is only installed when we have a trait collection containing any width and a compact height.

### Editing Constraints

Our view is still missing constraints. Most notably, none of our views know how to be placed along the x-axis because we disabled all those constraints. Let's go ahead and add a few new ones.

First, let's say that we want our Email Address label to have its leading edge equal to the horizontal center of our view. This will take a few more steps than previous constraints we've added, so let's walk through it step-by-step.

1. Click on the "Email Address" label to select it.
2. Hold down the Control key on your keyboard and use your mouse to drag from the email address label to anywhere in your view's canvas. You should see a semi-transparent overlay on screen with a few different options.
3. Click on "Center Horizontally in Container."
4. You should notice that it creates a new constraint that will be a red line along the X-axis. Go ahead and select that.
5. In the Identity Inspector you should notice that the constraint says that the "First Item" value is "Email Address.Center X". Click on that pop-up menu and change the value to "Leading".
6. Repeat steps 1-5 for our Password label. We want its leading edge to also be centered horizontally in our view.

![We can adjust our constraints with this handy popover too.](./images/ch06-ss05.png)

Our logo image view still needs a constraint for along the X-Axis. Let's say we want to pin its trailing edge to the leading edge of our email address text field, with about 50pts of padding.

1. Click on the image view to select it.
2. Hold down the Control key on your keyboard and use your mouse to drag from the image view to the email address text field and let go. You should see a semi-transparent overlay on screen again; this time with different options.
3. Click on "Horizontal Spacing" to create that new constraint.
4. Select your newly created constraint and go to the Identity Inspector.
5. Adjust its Constant value to be 50.

Getting closer! We still have a few missing constraints. Most notably, none of our views are quite certain where exactly along the y-axis they belong. We can fix that by telling our view that we want our Password label to always be centered vertically along the Y-Axis.

1. Click the Password label in our view's scene.
2. Open the alignment constraints popover and check the box next to "Vertically Center in Container."
3. Click "Add 1 Constraint."

At this point we should have our interface completely configured without any missing constraints for our compact height scenario. You likely have a few misplaced views on your Storyboard canvas, however. Let's quickly fix that by going to the "Resolve Auto Layout Issues" popover and selecting "Update Frames" for all the views in our container.

![Everything in its right place.](./images/ch06-ss06.png)

Let's kick the tires on our new work. Launch the DeveloperTown application in your iPhone simulator of choice and test rotating the interface between both portrait and landscape orientations. It should just work!

### How The Sausage Is Made

You're probably noticing that we haven't written a single line of code to accomplish any of this. It's a WWDC demo come true! Even though we aren't managing any code ourselves, the Auto Layout engine is doing a variety of different things behind the scenes to make our lives as developers easier.

Prior to iOS 8 working with constraints in different orientations required adding and removing constraints. This wasn't ideal for a variety of reasons. The overhead of adding constraints isn't zero, so there was a slight performance penalty for each constraint that was being processed on each rotation. The more complex the view, the higher that penalty. Why was this? Each time you added new constraints to your views, the Auto Layout engine would have to go through the entire process of solving your constraints, calculating your frames, and redrawing everything on screen.

With iOS 8, Apple added support for activating and deactivating constraints. This is a far more ideal way of dealing with constraints that don't need to be enabled at all times. Now, when you rotate between different orientations, your view just disables the constraints that aren't needed in the current trait collection. The key difference, however, is that when you go back to the previous orientation, the engine remembers all the calculations it had solved previously and can more easily apply those.

In general, you should opt for activating and deactivating constraints rather than adding and removing them whenever possible.

### Summary

In this chapter we moved our knowledge of size classes from theoretical to practical by adding a different set of constraints for our DeveloperTown screen in the landscape orientation. We also learned how to use the Identity Inspector in iPad to adjust different values on our constraints. Finally, we covered what happens when we activate and deactivate constraints in our views.

In the next chapter, we are going to continue our deep dive into Auto Layout by writing some code to interact with our constraints.

\pagebreak
