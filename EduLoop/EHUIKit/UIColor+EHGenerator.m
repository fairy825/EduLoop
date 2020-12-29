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

+ (UIColor *)eh_colorWithHex:(UInt32)hex
{
    return [UIColor eh_colorWithHex:hex andAlpha:1];
}

+ (UIColor *)eh_colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((hex >> 16) & 0xFF)/255.0
                           green:((hex >> 8) & 0xFF)/255.0
                            blue:(hex & 0xFF)/255.0
                           alpha:alpha];
}

+ (UIColor *)eh_colorWithHexRGB:(UInt32)hexInt
{
    return [UIColor eh_colorWithHex:hexInt andAlpha:1];
}

+ (UIColor *)eh_colorWithHexRGBA:(UInt32)hexInt
{
    return [UIColor colorWithRed:((hexInt >> 24) & 0xFF)/255.0
                           green:((hexInt >> 16) & 0xFF)/255.0
                            blue:((hexInt >> 8) & 0xFF)/255.0
                           alpha:(hexInt & 0xFF)/255.0];
}

+ (UIColor *)eh_colorWithHexString:(NSString *)hexString
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    if (colorString.length == 6 || colorString.length == 8) {
        CGFloat r, g, b, a;
        unsigned long long hexInt = 0;
        
        NSScanner *scanner = [NSScanner scannerWithString:hexString];
        [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]];
        BOOL visit = [scanner scanHexLongLong:&hexInt];
        if (visit) {
            if (colorString.length == 8) {
                r = (float)((hexInt & 0xFF000000) >> 24) / 255.f;
                g = (float)((hexInt & 0x00FF0000) >> 16) / 255.f;
                b = (float)((hexInt & 0x0000FF00) >> 8)  / 255.f;
                a = (hexInt & 0x000000FF) / 255.f;
                
                return [UIColor colorWithRed:r green:g blue:b alpha:a];
            } else if (colorString.length == 6) {
                r = (float)((hexInt & 0xFF0000) >> 16) / 255.f;
                g = (float)((hexInt & 0x00FF00) >> 8)  / 255.f;
                b = (float)((hexInt & 0x0000FF)) /  255.f;
                a = 1.f;
                
                return [UIColor colorWithRed:r green:g blue:b alpha:a];
            }
        }
    }
    
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: {// #RGB
            alpha = 1.0f;
            red   = eh_colorComponentFrom(colorString, 0, 1);
            green = eh_colorComponentFrom(colorString, 1, 1);
            blue  = eh_colorComponentFrom(colorString, 2, 1);
        } break;
            
        case 4: {// #ARGB
            alpha = eh_colorComponentFrom(colorString, 0, 1);
            red   = eh_colorComponentFrom(colorString, 1, 1);
            green = eh_colorComponentFrom(colorString, 2, 1);
            blue  = eh_colorComponentFrom(colorString, 3, 1);
        } break;
            
        case 6: {// #RRGGBB
            alpha = 1.0f;
            red   = eh_colorComponentFrom(colorString, 0, 2);
            green = eh_colorComponentFrom(colorString, 2, 2);
            blue  = eh_colorComponentFrom(colorString, 4, 2);
        } break;
            
        case 8: {// #AARRGGBB
            alpha = eh_colorComponentFrom(colorString, 0, 2);
            red   = eh_colorComponentFrom(colorString, 2, 2);
            green = eh_colorComponentFrom(colorString, 4, 2);
            blue  = eh_colorComponentFrom(colorString, 6, 2);
        } break;
            
        default: {
            return [UIColor clearColor];
        }
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (NSString *)eh_HEXString
{
    UIColor *color = self;
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    return [NSString stringWithFormat:@"#%02X%02X%02X", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

+ (UIColor *)eh_colorWithWholeRed:(CGFloat)red
                            green:(CGFloat)green
                             blue:(CGFloat)blue
                            alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.f
                           green:green/255.f
                            blue:blue/255.f
                           alpha:alpha];
}

+ (UIColor *)eh_colorWithWholeRed:(CGFloat)red
                            green:(CGFloat)green
                             blue:(CGFloat)blue
{
    return [self eh_colorWithWholeRed:red
                                green:green
                                 blue:blue
                                alpha:1.0];
}

@end
