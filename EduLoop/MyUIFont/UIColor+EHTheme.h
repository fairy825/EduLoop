#import <UIKit/UIKit.h>
#import "UIColor+EHGenerator.h"

NS_ASSUME_NONNULL_BEGIN

enum {
    // 分割线颜色
    EHThemeColor_e1e1e1 = 0xe1e1e1,
    EHThemeColor_eeeeee = 0xeeeeee,
    
    // 页面底色
    EHThemeColor_f6f6f6 = 0xf6f6f6,
    
    // 文字颜色
    EHThemeColor_111111 = 0x111111,
    EHThemeColor_333333 = 0x333333,
    EHThemeColor_335679 = 0x335679,
    EHThemeColor_555555 = 0x555555,
    EHThemeColor_666666 = 0x666666,
    EHThemeColor_999999 = 0x999999,
    EHThemeColor_cccccc = 0xcccccc,
    
    // 主色调
    EHThemeColor_4cadff = 0x4cadff,
    
    EHThemeColor_5bb2ff = 0x5bb2ff,
    
    // 辅助色调
    EHThemeColor_ff9000 = 0xff9000,
    
    // 正确颜色
    EHThemeColor_05daba = 0x05daba,
    
    // 错误颜色
    EHThemeColor_f36921 = 0xf36921,
    
    // 不可点击颜色
    EHThemeColor_a6d7ff = 0xa6d7ff,
    EHThemeColor_f9f9f9 = 0xf9f9f9,
    EHThemeColor_bbbbbb = 0xBBBBBB,

    // 未选中颜色、默认背景色
    EHThemeColor_f4f4f4 = 0xf4f4f4,

    // 选中颜色
    EHThemeColor_ffc600 = 0xffc600,
    
    // 白色
    EHThemeColor_White = 0xFFFFFF,
    
    // 黑色
    EHThemeColor_Black = 0x000000,
    
    // 红色
    EHThemeColor_Red = 0xcc3300,
    
    // 蓝色
    EHThemeColor_Blue = 0x3366CC,
    
    //
    EHThemeColor_CellHighlightedColor = 0xDDDDDD,
};

#define EHWhiteColor [UIColor eh_colorWithHexRGB:EHThemeColor_White]

@interface UIColor (EHTheme)

+ (UIColor *)eh_eeeeee;
+ (UIColor *)eh_e1e1e1;
+ (UIColor *)eh_f6f6f6;

+ (UIColor *)eh_111111;
+ (UIColor *)eh_333333;
+ (UIColor *)eh_335679;
+ (UIColor *)eh_555555;
+ (UIColor *)eh_666666;
+ (UIColor *)eh_999999;
+ (UIColor *)eh_cccccc;
+ (UIColor *)eh_4cadff;
+ (UIColor *)eh_f9f9f9;
+ (UIColor *)eh_f4f4f4;
+ (UIColor *)eh_ffc600;
+ (UIColor *)eh_ff9000;
+ (UIColor *)eh_05daba;
+ (UIColor *)eh_5bb2ff;
+ (UIColor *)eh_f36921;
+ (UIColor *)eh_a6d7ff;

+ (UIColor *)eh_separatorColor;
+ (UIColor *)eh_imageBorderColor;
+ (UIColor *)eh_moduleDividerColor;
+ (UIColor *)eh_backgroundColor;
+ (UIColor *)eh_titleColor;
+ (UIColor *)eh_subtitleColor;
+ (UIColor *)eh_auxiliaryTextColor;
+ (UIColor *)eh_disableTextColor;

+ (UIColor *)eh_borderColor;

+ (UIColor *)eh_primaryColor;
+ (UIColor *)eh_secondaryColor;
+ (UIColor *)eh_rightColor;
+ (UIColor *)eh_errorColor;
+ (UIColor *)eh_diableColor;

+ (UIColor *)eh_cellHighlightedColor;

+ (UIColor *)eh_videocallCameraSwitchOnColor;
+ (UIColor *)eh_videocallBgColor;
@end

NS_ASSUME_NONNULL_END
