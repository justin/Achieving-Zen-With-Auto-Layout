Chapter 01 - Introduction
====================================

We’ve all been there. Apple announces an all-new technology at their annual Worldwide Developers Conference. It’s designed to replace something that you’ve been using since you started down the road as an macOS or iOS programmer. The demos in the session look great. You can’t wait to get home and try this new stuff out!

And then you get home and realize, “Oh, this isn’t as easy as I thought.”
As software developers, we’re used to adapting to a learning curve whenever we try to implement a new technology in our products; it’s just part of the job. Unfortunately, some technologies have a steeper curve than others. One of the technologies that has had the biggest learning curve over the last few years is Auto Layout.

This book is designed to help you get over that hurdle with Auto Layout.

### Who Is This Book For?

For the last three years, I have been giving a talk around the United States called "Achieving Zen With Auto Layout" that is aimed at developers who have tried to use Auto Layout in the past but have struggled for some reason or another and gone back to doing layout the old way.

If that’s you, this book is for you.

If you haven’t even started using Auto Layout yet, but Apple’s announcements at WWDC 2014 have you in fear that you’re being left behind, I’ll have you up to speed in no time, as well.

### Prerequisites

This book presumes that you are a seasoned macOS or iOS developer using Objective-C or Swift. If this is the first time you’ve ever heard the words Objective-C or Swift, you might want to start with another book that teaches you the fundamentals. These are books and authors I recommend:

* [iOS Programming: The Big Nerd Ranch Guide][bnr]
* [Cocoa Programming for macOS][osx]
* [Programming iOS 8][oreilly]

I’m also going to make the assumption that you are targeting at least iOS 9 or macOS El Capitan with your products and are using the latest version of Xcode 7.0 and Swift 2.0, where appropriate. I’ll do my best to point out some tricks that can help with backwards compatibility to previous operating system releases.

### Organization of This Book

I have broken down the book into four sections, or levels of "Zen." The first section of the book will explore a lot of the under-the-hood plumbing of Auto Layout. My goal is to build a foundation of understanding what Auto Layout is actually doing, so you know _why_ you're coding something rather than just _what_ you're coding.

The second section of the book will cover working with Interface Builder and Xcode. The third section will explain working with constraints in code, custom views, and animations. The final section will delve into the more advanced topics, such as debugging constraints, scroll views, and other pain points developers may run into.

### My Writing Style

The style of this book is slightly different than other technology books you may have read. Most books are project-oriented, starting with a foundation project that you build on throughout the book.

I don’t believe that’s the best way to tackle a singular technology like Auto Layout. Instead, I’m going to spend the first part of this book building a foundation of knowledge about the core concepts of the technology so that you understand why Auto Layout is doing what it’s doing. From there, we’ll start looking at how to implement it in real-world, practical use cases.

### Code Samples

Throughout the book there are several snippets of code explaining how to accomplish different tasks using Auto Layout. Where appropriate, I am also providing a sample Xcode project or Playground that fully implements the feature. You should have received a ZIP file of these samples when you made your purchase.

All of the code samples were written using Xcode 7 and targeted towards macOS El Capitan and iOS 9 respectively.

### Errata and Issues

If you notice something missing or incorrect or factually inaccurate in the book, please file an issue on the public GitHub repository.

[https://github.com/secondgear/Achieving-Zen-With-Auto-Layout][gh]

### Feedback and Questions

If you have any feedback, questions, or topics you wish I had covered in this book, the best way to get in touch with me is via email.

My goal is to update this book on an ongoing basis with new content when possible, so if you feel like I should have covered a topic, please let me know and I’ll see what I can do. Digital publishing offers the benefit of making books become living documents rather than just a moment in time.

- Email me: [justin@secondgear.io](mailto:justin@secondgear.io)

[bnr]: http://www.bignerdranch.com/we-write/ios-programming.html

[oreilly]: http://shop.oreilly.com/product/0636920034261.do

[osx]: http://www.bignerdranch.com/we-write/cocoa-programming.html

[gh]: https://github.com/secondgear/Achieving-Zen-With-Auto-Layout

\pagebreak
