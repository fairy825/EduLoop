#import "UIColor+EHGenerator.h"

static CGFloat eh_colorComponentFrom(NSString *string, NSUInteger start, NSUInteger length)
{
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@implementation UIColor (EHColorGenerator)

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

+ (UIColor *)elColorWithHexRGB:(UInt32)hexInt
{
    return [UIColor elColorWithHex:hexInt andAlpha:1];
}

+ (UIColor *)elColorWithWholeRed:(CGFloat)red
                            green:(CGFloat)green
                             blue:(CGFloat)blue
                            alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.f
                           green:green/255.f
                            blue:blue/255.f
                           alpha:alpha];
}

+ (UIColor *)elColorWithWholeRed:(CGFloat)red
                            green:(CGFloat)green
                             blue:(CGFloat)blue
{
    return [self elColorWithWholeRed:red
                                green:green
                                 blue:blue
                                alpha:1.0];
}

@end
