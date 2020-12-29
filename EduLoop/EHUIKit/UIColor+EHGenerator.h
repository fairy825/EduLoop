#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define EHHexRGB(hexInt)    [UIColor eh_colorWithHexRGB:hexInt]
#define EHHexRGBA(hexInt)   [UIColor eh_colorWithHexRGBA:hexInt]

@interface UIColor (EHColorGenerator)

/**
 使用16进制整数生成颜色
 */
+ (UIColor *)eh_colorWithHex:(UInt32)hexInt;
+ (UIColor *)eh_colorWithHex:(UInt32)hexInt
                    andAlpha:(CGFloat)alpha;
+ (UIColor *)eh_colorWithHexRGB:(UInt32)hexInt;
+ (UIColor *)eh_colorWithHexRGBA:(UInt32)hexInt;

/**
 * 十六进制的颜色值，支持#和0x开头的16进制颜色值
 */
+ (UIColor *)eh_colorWithHexString:(NSString *)hexString;
- (NSString *)eh_HEXString;

///值不需要除以255.0
+ (UIColor *)eh_colorWithWholeRed:(CGFloat)red
                            green:(CGFloat)green
                             blue:(CGFloat)blue
                            alpha:(CGFloat)alpha;
///值不需要除以255.0
+ (UIColor *)eh_colorWithWholeRed:(CGFloat)red
                            green:(CGFloat)green
                             blue:(CGFloat)blue;

@end

NS_ASSUME_NONNULL_END
