#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (MyColorGenerator)

/**
 使用16进制整数生成颜色
 */
+ (UIColor *)elColorWithHex:(UInt32)hexInt;
+ (UIColor *)elColorWithHex:(UInt32)hexInt
                    andAlpha:(CGFloat)alpha;
@end

NS_ASSUME_NONNULL_END
