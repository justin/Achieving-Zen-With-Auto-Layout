#import "UIView+AZALExtensions.h"

#ifdef DEBUG
@implementation UIView (LayoutDebugging)

- (NSString *)nsli_description
{
    return [self restorationIdentifier] ?: [NSString stringWithFormat:@"%@:%p", [self class], self];
}

- (BOOL)nsli_descriptionIncludesPointer
{
    return [self restorationIdentifier] == nil;
}

@end
#endif
