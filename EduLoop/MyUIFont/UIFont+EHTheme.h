#import <UIKit/UIKit.h>
#import "EHFontWeight.h"

#define EHLightFont(fontSize)       [UIFont eh_lightWithSize:fontSize]
#define EHRegularFont(fontSize)     [UIFont eh_regularWithSize:fontSize]
#define EHMediumFont(fontSize)      [UIFont eh_mediumFontWithSize:fontSize]
#define EHSemiBoldFont(fontSize)    [UIFont eh_semiBoldWithSize:fontSize]
#define EHBoldFont(fontSize)        [UIFont eh_boldWithSize:fontSize]
#define EHFZQTFont(fontSize)        [UIFont eh_FZQTFontWithSize:fontSize]
#define EHFALPHFont(fontSize)       [UIFont eh_ALIPHFontWithSize:fontSize]
#define EHFZLTZHKFont(fontSize)     [UIFont eh_FZLTZHKFontWithSize:fontSize]

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (EHTheme)

+ (UIFont *)eh_fontWithSize:(CGFloat)size
                     weight:(NSInteger)weight;

/**
 获取Light font
 */
+ (UIFont *)eh_lightWithSize:(CGFloat)size;

/**
 获取Medium font
 */
+ (UIFont *)eh_mediumFontWithSize:(CGFloat)size;

/**
 获取Regular font
 */
+ (UIFont *)eh_regularWithSize:(CGFloat)size;

/**
 获取Semibold font
 */
+ (UIFont *)eh_semiBoldWithSize:(CGFloat)size;

/**
 获取Bold font
 */
+ (UIFont *)eh_boldWithSize:(CGFloat)size;

/**
 获取 DIN Alternate font
 */
+ (UIFont *)eh_DINAlternateBoldWithSize:(CGFloat)size;

/**
 获取 Futura font
 */
+ (UIFont *)eh_futuraWithSize:(CGFloat)size;
+ (UIFont *)eh_futuraBoldWithSize:(CGFloat)size;


/**
 获取 pingFangSC 字体
 */
+ (UIFont *)eh_pingFangSCLightFontWithSize:(CGFloat)fontSize;
+ (UIFont *)eh_pingFangSCRegularFontWithSize:(CGFloat)fontSize;
+ (UIFont *)eh_pingFangSCMediumFontWithSize:(CGFloat)fontSize;
+ (UIFont *)eh_pingFangSCSemiboldFontWithSize:(CGFloat)fontSize;


/**
 获取方正启体
 */
+ (UIFont *)eh_FZQTFontWithSize:(CGFloat)fontSize;


/**
 获取阿里普惠体
 */
+ (UIFont *)eh_ALIPHFontWithSize:(CGFloat)fontSize;

/**
获取方正兰亭黑_韵母调整宽度版
*/
+ (UIFont *)eh_FZLTZHKFontWithSize:(CGFloat)fontSize;

@end

NS_ASSUME_NONNULL_END
