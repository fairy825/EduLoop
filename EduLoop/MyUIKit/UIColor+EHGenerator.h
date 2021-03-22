#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define EHHexRGB(hexInt)    [UIColor eh_colorWithHexRGB:hexInt]
#define EHHexRGBA(hexInt)   [UIColor eh_colorWithHexRGBA:hexInt]

@interface UIColor (EHColorGenerator)

/**
 使用16进制整数生成颜色
 */
//+ (UIColor *)elColorWithHex:(UInt32)hexInt;
//+ (UIColor *)elColorWithHex:(UInt32)hexInt
//                    andAlpha:(CGFloat)alpha;
//+ (UIColor *)elColorWithHexRGB:(UInt32)hexInt;
//+ (UIColor *)elColorWithHexRGBA:(UInt32)hexInt;
//
///**
// * 十六进制的颜色值，支持#和0x开头的16进制颜色值
// */
//+ (UIColor *)elColorWithHexString:(NSString *)hexString;
//- (NSString *)elHEXString;
//
/////值不需要除以255.0
//+ (UIColor *)elColorWithWholeRed:(CGFloat)red
//                            green:(CGFloat)green
//                             blue:(CGFloat)blue
//                            alpha:(CGFloat)alpha;
/////值不需要除以255.0
//+ (UIColor *)elColorWithWholeRed:(CGFloat)red
//                            green:(CGFloat)green
//                             blue:(CGFloat)blue;

@end

NS_ASSUME_NONNULL_END
