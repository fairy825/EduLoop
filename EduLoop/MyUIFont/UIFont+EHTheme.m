#import "UIFont+EHTheme.h"
#import <CoreText/CoreText.h>

#define EHDINAlternateBoldFontName @"DIN Alternate"
#define EHFuturaBoldFontName       @"Futura"

@interface EHUIFont : NSObject

@property (nonatomic, copy) NSString *fzqtName;
@property (nonatomic, copy) NSString *alipuhuName;
@property (nonatomic, copy) NSString *FZLTZHKName;

@end

@implementation EHUIFont

+ (instancetype)shareInstance {
    static EHUIFont *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[EHUIFont alloc] init];
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"EHTheme" ofType:@"bundle"];
        NSString *fzqtTTFPath = [NSString stringWithFormat:@"%@/HanyiSentyFlorCalligraphy.ttf",bundlePath];
        NSString *alipuTTFPath = [NSString stringWithFormat:@"%@/aliph.ttf",bundlePath];
        NSString *FZLTZHKPath = [NSString stringWithFormat:@"%@/FZLTZHK.ttf",bundlePath];
        instance.fzqtName = [instance eh_getCustomFontNameWithPath:fzqtTTFPath];
        instance.alipuhuName = [instance eh_getCustomFontNameWithPath:alipuTTFPath];
        instance.FZLTZHKName = [instance eh_getCustomFontNameWithPath:FZLTZHKPath];
    });
    return instance;
}

- (NSString *)eh_getCustomFontNameWithPath:(NSString *)path {
    NSURL *fontUrl = [NSURL fileURLWithPath:path];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(fontRef, NULL);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    CGFontRelease(fontRef);
    return fontName;
}

@end

@implementation UIFont (EHTheme)

#pragma mark - font type

+ (UIFont *)eh_fontWithSize:(CGFloat)size
                     weight:(NSInteger)weight
{
    return [self eh_fontStyleWithSize:size
                           fontWeight:weight];
}

+ (UIFont *)eh_lightWithSize:(CGFloat)size
{
    return [self eh_fontStyleWithSize:size
                           fontWeight:EHFontWeightLight];
}

+ (UIFont *)eh_mediumFontWithSize:(CGFloat)size
{
    return [self eh_fontStyleWithSize:size
                           fontWeight:EHFontWeightMedium];
}

+ (UIFont *)eh_regularWithSize:(CGFloat)size
{
    return [self eh_fontStyleWithSize:size
                           fontWeight:EHFontWeightRegular];
}

+ (UIFont *)eh_semiBoldWithSize:(CGFloat)size
{
    return [self eh_fontStyleWithSize:size
                           fontWeight:EHFontWeightSemibold];
}

+ (UIFont *)eh_boldWithSize:(CGFloat)size
{
    return [self eh_fontStyleWithSize:size
                           fontWeight:EHFontWeightBold];
}

#pragma mark - helper

#define FontWeightUltraLight_Value    (-0.80000001192092896)
#define FontWeightThin_Value          (-0.60000002384185791)
#define FontWeightLight_Value         (-0.40000000596046448)
#define FontWeightRegular_Value       (0)
#define FontWeightMedium_Value        (0.23000000417232513)
#define FontWeightSemibold_Value      (0.30000001192092896)
#define FontWeightBold_Value          (0.40000000596046448)
#define FontWeightHeavy_Value         (0.56000000238418579)
#define FontWeightBlack_Value         (0.62000000476837158)

+ (UIFont *)eh_fontStyleWithSize:(CGFloat)size
                      fontWeight:(NSInteger)ehFontWeight
{
    UIFontWeight fontWeight = UIFontWeightRegular;
    switch (ehFontWeight) {
        case EHFontWeightUltraLight: {
            fontWeight = UIFontWeightUltraLight;
        } break;
        case EHFontWeightThin: {
            fontWeight = UIFontWeightThin;
        } break;
        case EHFontWeightLight: {
            fontWeight = UIFontWeightLight;
        } break;
        case EHFontWeightRegular: {
            fontWeight = UIFontWeightRegular;
        } break;
        case EHFontWeightMedium: {
            fontWeight = UIFontWeightMedium;
        } break;
        case EHFontWeightSemibold: {
            fontWeight = UIFontWeightSemibold;
        } break;
        case EHFontWeightBold: {
            fontWeight = UIFontWeightBold;
        } break;
        case EHFontWeightHeavy: {
            fontWeight = UIFontWeightHeavy;
        } break;
        case EHFontWeightBlack: {
            fontWeight = UIFontWeightBlack;
        } break;
        default: {
        } break;
    }
    return [UIFont systemFontOfSize:size weight:fontWeight];
}

#pragma mark - special font

+ (UIFont *)eh_DINAlternateBoldWithSize:(CGFloat)size
{
    // font-family: "DIN Alternate"; font-weight: bold; font-style: normal; font-size: 18.00pt
    UIFont *font = [UIFont fontWithName:EHDINAlternateBoldFontName size:size];
    return font ?: [self eh_regularWithSize:size];
}

static UIFontDescriptor *EHGetFuturaDescriptor(void)
{
    // font-family: "DIN Alternate"; font-weight: bold; font-style: normal; font-size: 18.00pt
    static UIFontDescriptor *futuraFd = nil;
    if (!futuraFd) {
        futuraFd = [UIFontDescriptor fontDescriptorWithName:EHFuturaBoldFontName
                                                       size:0];
    }
    return futuraFd;
}

+ (UIFont *)eh_futuraWithSize:(CGFloat)size
{
    UIFont *font = [UIFont fontWithDescriptor:EHGetFuturaDescriptor()
                                         size:size];
    return font ?: [self eh_mediumFontWithSize:size];
}

+ (UIFont *)eh_FZQTFontWithSize:(CGFloat)fontSize {
    NSString *fontName = [[EHUIFont shareInstance] fzqtName];
    UIFont *font = [UIFont fontWithName:fontName?:@"" size:fontSize];
    return font?:[self eh_regularWithSize:fontSize];
}

+ (UIFont *)eh_ALIPHFontWithSize:(CGFloat)fontSize {
    NSString *fontName = [[EHUIFont shareInstance] alipuhuName];
    UIFont *font = [UIFont fontWithName:fontName?:@"" size:fontSize];
    return font?:[self eh_regularWithSize:fontSize];
}

+ (UIFont *)eh_FZLTZHKFontWithSize:(CGFloat)fontSize {
    NSString *fontName = [[EHUIFont shareInstance] FZLTZHKName];
    UIFont *font = [UIFont fontWithName:fontName?:@"" size:fontSize];
    return font?:[self eh_regularWithSize:fontSize];
}

+ (UIFont *)eh_futuraBoldWithSize:(CGFloat)size
{
    UIFont *font = [UIFont fontWithDescriptor:[EHGetFuturaDescriptor() fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold]
                                         size:size];
    return font ?: [self eh_semiBoldWithSize:size];
}

#pragma mark - pingFangSC

+ (UIFont *)eh_pingFangSCLightFontWithSize:(CGFloat)fontSize
{
    return [self _eh_pingFangSCFontWithSize:fontSize
                                       name:@"PingFangSC-Light"
                                     weight:EHFontWeightLight];
}

+ (UIFont *)eh_pingFangSCRegularFontWithSize:(CGFloat)fontSize
{
    return [self _eh_pingFangSCFontWithSize:fontSize
                                       name:@"PingFangSC-Regular"
                                     weight:EHFontWeightRegular];
}

+ (UIFont *)eh_pingFangSCMediumFontWithSize:(CGFloat)fontSize
{
    return [self _eh_pingFangSCFontWithSize:fontSize
                                       name:@"PingFangSC-Medium"
                                     weight:EHFontWeightMedium];
}

+ (UIFont *)eh_pingFangSCSemiboldFontWithSize:(CGFloat)fontSize
{
    return [self _eh_pingFangSCFontWithSize:fontSize
                                       name:@"PingFangSC-Semibold"
                                     weight:EHFontWeightSemibold];
}

+ (UIFont *)_eh_pingFangSCFontWithSize:(CGFloat)fontSize
                                  name:(NSString *)name
                                weight:(NSInteger)ehFontWeight
{
    return [UIFont fontWithName:name ?: @"PingFangSC-Regular" size:fontSize];
}

@end
