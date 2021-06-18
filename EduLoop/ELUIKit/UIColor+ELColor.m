//
//  UIColor+ELColor.m
//  EduLoop
//
//  Created by mijika on 2021/6/18.
//

#import "UIColor+ELColor.h"

@implementation UIColor (ELColor)

+(UIColor *)colorWithRGB:(NSUInteger)hex
                  alpha:(CGFloat)alpha
{
    float r, g, b, a;
    a = alpha;
    b = hex & 0x0000FF;
    hex = hex >> 8;
    g = hex & 0x0000FF;
    hex = hex >> 8;
    r = hex;

    return [UIColor colorWithRed:r/255.0f
                           green:g/255.0f
                           blue:b/255.0f
                           alpha:a];
}
// 分割线颜色

+ (UIColor *)elSeperatorColor
{
    return [UIColor colorWithRGB:0xeeeeee alpha:1];
}

// 页面底色
+ (UIColor *)elBackgroundColor
{
    return [UIColor colorWithRGB:0xf6f6f6 alpha:1];
}

+ (UIColor *)themeBlue
{
    return [UIColor colorWithRGB:0x99CCFF alpha:1];
}


@end
