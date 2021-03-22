#import <UIKit/UIKit.h>
#import "UIColor+EHGenerator.h"

NS_ASSUME_NONNULL_BEGIN

enum {
    // 红色
    Color_Red = 0xcc3300,
    
    // 蓝色
    Color_Blue = 0x3366CC,
    
    //
    Color_CellHighlightedColor = 0xDDDDDD,
    Color_finished = 0x00CC66,
    Color_not_finished = 0xcc3300,
    Color_delay_can_finish = 0xcc3300,
    Color_delay_cannot_finish = 0xBBBBBB,

};

@interface UIColor (EHTheme)

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
