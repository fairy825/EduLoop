//
//  UIColor+ELColor.h
//  EduLoop
//
//  Created by mijika on 2021/6/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
enum {
    Color_finished = 0x00CC66,
    Color_not_finished = 0xcc3300,
    Color_delay_can_finish = 0xcc3300,
    Color_delay_cannot_finish = 0xBBBBBB,

};
@interface UIColor (ELColor)
+(UIColor *)colorWithRGB:(NSUInteger)hex
                   alpha:(CGFloat)alpha;
+ (UIColor *)elSeperatorColor;
+ (UIColor *)elBackgroundColor;
+ (UIColor *)themeBlue;
@end

NS_ASSUME_NONNULL_END
