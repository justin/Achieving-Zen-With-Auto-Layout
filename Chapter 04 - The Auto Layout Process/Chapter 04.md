
Chapter 04 - The Auto Layout Process
====================================

### Installing Constraints

When you decide to use Auto Layout in your project, you may be wondering what exactly that entails. As we mentioned earlier in the book, there’s nothing “auto” about Auto Layout. It’s just doing what you, the developer, tell it to do.

It is worth taking the time, therefore, to understand what that means; it certainly helps to understand how something works under the hood when it’s not doing exactly what you want on the surface.

The first step is to install the constraints you want on each of your views. You're taking the time to establish the relationships between each of the views you want to draw on screen.

Defining the constraint relationships is a lot like the children's story, *Goldilocks and the Three Bears.* Each of the bears had a bowl of porridge. One bowl was far too hot. One, far too cold. And then there was the one that was just right.

Auto Layout is your figurative bowl of porridge. If you have too many constraints, you're going to have conflicts, and exceptions will be thrown. If you have too few constraints, you're going to end up in an ambiguous state where the Auto Layout engine is guessing what you want to happen because there is more than one possible outcome for your layout. Ultimately, you want an amount of constraints that is not too many and not too few—just right.

There are three ways to install constraints on your view:

1.  Using Interface Builder.
2.  In code, using the visual format language.
3.  In code, one-by-one using `NSLayoutConstraint` instances.

We'll cover these more extensively in successive chapters, but each method installs constraints at different times in the view creation process.

With Interface Builder, your constraints are installed as the view is unarchived and prepared for display by the user. Usually, these are constraints that will never change, although you can keep a weak reference to constraints you set in Interface Builder should you want to adjust, activate, or deactive them later on.

There are two places where it makes the most sense to apply constraints in code: the initializer and in an override of the `updateConstraints` method.

When adding constraints through either `init`, `initWithCoder:`, or similar methods, I'm usually only adding constraints that will never change during the lifetime of the view. Often, these are the basics—such as setting the edge relationships between a view and its superview, centering vertically or horizontally, and the like.

For constraints that are added on the fly or may change frequently, I aim to add them via `updateConstraints()`.

#### updateConstraints

The `updateConstraints` method is initiated at the last possible moment before our view starts trying to calculate a view's frame values from its Auto Layout constraints. In a lot of ways, it is analogous to `awakeFromNib()`, which provides a deferral mechanism for nibs that need to make changes before they are displayed on the screen.

You shouldn't be overriding this unless absolutely necessary. The ideal place to add constraints will always be Interface Builder.

Adding your constraints in `updateConstraints()` instead of Interface Builder can help when you have ordering problems with how your constraints are applied. It can also assist if you have different constraints based on the current state of your view, such as if you activate a different set of constraints for a landscape orientation versus portrait. If you are changing these often, batching the constraint changes in `updateConstraints()` can give you a bit of a performance boost over adding and removing them elsewhere.

#### The Measurement Pass

When you have your constraints installed, the Auto Layout engine begins the process of actually solving the linear equations to determine what the frame values of each of your views should be. This happens from the bottom up, starting with your subviews and making its way to the superview. This is often referred to as the measurement pass.

You can trigger a measurement pass by calling `setNeedsUpdateConstraints()`, which will go through the Auto Layout engine and recalculate the sizes of your views based on the current set of constraints.

### Laying Out Views

Once Auto Layout has taken a measurement pass and calculated the values we should have for each of our views, it can go through the actual process of setting those values against the views. For old hands of iOS and macOS development, this is basically an automated way of calling `setFrame()`. The Auto Layout engine calculates those frame values and then simply iterates through our views—from superview down to subview—calling `setFrame:` on each of them.

If you've elected to use Auto Layout but are still calling `setFrame()` manually, you've likely had the headache of debugging why your view doesn't look exactly like you expect. This is why. **If you're using Auto Layout, you should never call `setFrame()` yourself.** Trust the `NSISEngine` (the private class doing all the layout calculation and management) to do the heavy lifting for you.

If you want to force your view to re-layout, there are two ways to do that:

First, you can call `setNeedsLayout()`, which will notify the system that you want to do a layout pass. The system will then do the pass when it determines it is convenient. Alternately, if you want to have the layout pass happen immediately, you can call `layoutIfNeeded()`.

It should be noted that each step in the Auto Layout process is iterative, so every time you call `layoutIfNeeded()` or `setNeedsLayout()`, the Auto Layout engine is going back to step one and doing another measurement pass to calculate your frame values before it starts setting your frame values again. This is something to be mindful of if you are running into performance issues.

### Drawing on Screen

The final step of the Auto Layout process is the one you are likely most familiar with: actually drawing on screen. We've solved our constraint equations and set our frames to match those values. Now, we actually need to render this all on-screen for our user to interact with.

The drawing process operates from the top down, superview to subview, and actually paints our views on-screen using layoutSubviews() on iOS and layout() on macOS. Here, the system is copying the subview frames that were calculated from the layout engine and applying them to each view in your UI one-by-one.

You can trigger this step by calling `setNeedsDisplay()`, which notifies the system that you would like the specific view to be redrawn during the next drawing cycle.

As mentioned previously, each step depends on the one before it, so the display pass will trigger a layout pass if any layout changes are pending. If you ever run into performance issues with table cells and Auto Layout, it's likely because each time you redraw a new cell, it is going through the entire Auto Layout process—solving, setting, and drawing in real time (and on the main thread!).

### Summary

In this chapter, we walked through what is happening with Auto Layout under the hood. We discussed what happens when you apply constraints to a view and how the measurement pass calculates the values based on those. We covered how the layout process occurs for each view as well as the final step of drawing everything on the screen.

At this point, you have achieved Level 1 Zen of Auto Layout! Congratulations. Understanding the key terminology and how Auto Layout works is the first step toward becoming successful at adopting the technology in your app.

In the next set of chapters, we'll actually start working with Auto Layout in code. Well, not actual code. Interface Builder. If you're not using Interface Builder yet, you should be.

Let's learn why.

\pagebreak
