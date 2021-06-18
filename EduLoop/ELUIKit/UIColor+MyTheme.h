#import <UIKit/UIKit.h>
#import "UIColor+MyGenerator.h"

NS_ASSUME_NONNULL_BEGIN

enum {
    Color_finished = 0x00CC66,
    Color_not_finished = 0xcc3300,
    Color_delay_can_finish = 0xcc3300,
    Color_delay_cannot_finish = 0xBBBBBB,

};

@interface UIColor (MyTheme)

+ (UIColor *)eeeeee;
+ (UIColor *)e1e1e1;
+ (UIColor *)f6f6f6;
+ (UIColor *)color333333;
+ (UIColor *)color555555;
+ (UIColor *)color666666;
+ (UIColor *)color999999;
+ (UIColor *)color5bb2ff;
@end

NS_ASSUME_NONNULL_END
