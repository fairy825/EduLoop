#import "UIColor+MyGenerator.h"

@implementation UIColor (MyColorGenerator)

+ (UIColor *)elColorWithHex:(UInt32)hex
{
    return [UIColor elColorWithHex:hex andAlpha:1];
}

+ (UIColor *)elColorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((hex >> 16) & 0xFF)/255.0
                           green:((hex >> 8) & 0xFF)/255.0
                            blue:(hex & 0xFF)/255.0
                           alpha:alpha];
}
@end
