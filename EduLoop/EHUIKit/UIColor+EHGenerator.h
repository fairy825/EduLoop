#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define EHHexRGB(hexInt)    [UIColor eh_colorWithHexRGB:hexInt]
#define EHHexRGBA(hexInt)   [UIColor eh_colorWithHexRGBA:hexInt]

@interface UIColor (EHColorGenerator)

/**
 使用16进制整数生成颜色
 */
+ (UIColor *)elColorWithHex:(UInt32)hexInt;
+ (UIColor *)elColorWithHex:(UInt32)hexInt
                    andAlpha:(CGFloat)alpha;
+ (UIColor *)elColorWithHexRGB:(UInt32)hexInt;

///值不需要除以255.0
+ (UIColor *)elColorWithWholeRed:(CGFloat)red
                            green:(CGFloat)green
                             blue:(CGFloat)blue
                            alpha:(CGFloat)alpha;
///值不需要除以255.0
+ (UIColor *)elColorWithWholeRed:(CGFloat)red
                            green:(CGFloat)green
                             blue:(CGFloat)blue;

@end

NS_ASSUME_NONNULL_END
