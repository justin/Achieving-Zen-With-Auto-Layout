@import UIKit;

#ifdef DEBUG
@interface UIView (LayoutDebugging)
#pragma clang push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
- (id)recursiveDescription;
- (id)_autolayoutTrace;
#pragma clang pop
@end
#endif
