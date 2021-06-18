//
//  ELScreen.h
//  EduLoop
//
//  Created by mijika on 2021/1/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define IS_LANDSCAPE (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
#define SCREEN_WIDTH (IS_LANDSCAPE?[[UIScreen mainScreen]bounds].size.height:[[UIScreen mainScreen]bounds].size.width)
#define SCREEN_HEIGHT (IS_LANDSCAPE?[[UIScreen mainScreen]bounds].size.width:[[UIScreen mainScreen]bounds].size.height)
#define IS_IPHONE_X (SCREEN_WIDTH==[ELScreen sizeFor58Inch].width&&SCREEN_HEIGHT==[ELScreen sizeFor58Inch].height)
#define IS_IPHONE_XR (SCREEN_WIDTH==[ELScreen sizeFor61Inch].width&&SCREEN_HEIGHT==[ELScreen sizeFor61Inch].height)
#define IS_IPHONE_XSMAX (SCREEN_WIDTH==[ELScreen sizeFor65Inch].width&&SCREEN_HEIGHT==[ELScreen sizeFor65Inch].height)
#define IS_IPHONE_X_XR_MAX (IS_IPHONE_X||IS_IPHONE_XR||IS_IPHONE_XSMAX)
#define STATUS_BAR_HEIGHT (IS_IPHONE_X_XR_MAX?44:20)
#define HOME_BUTTON_HEIGHT (IS_IPHONE_X_XR_MAX?34:0)
#define NAVIGATION_HEIGHT 44


#define UI(x) UIAdapter(x)
#define UIRect(x,y,width,height) UIRectAdapter(x,y,width,height)
static inline NSInteger UIAdapter (float x){
    //1 - 分机型 特定的比例
    
    //2 - 屏幕宽度按比例适配
    CGFloat scale = 414 / SCREEN_WIDTH;
    return (NSInteger)x /scale;
}

//...完善其他方法..size..rect..origin..
static inline CGRect UIRectAdapter(x,y,width,height){
    return CGRectMake(UIAdapter(x), UIAdapter(y), UIAdapter(width), UIAdapter(height));
}

@interface ELScreen : UIView
+(CGSize)sizeFor65Inch;
+(CGSize)sizeFor61Inch;
+(CGSize)sizeFor58Inch;

@end

NS_ASSUME_NONNULL_END
