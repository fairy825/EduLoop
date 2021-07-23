//
//  NELCenterCustomOverlay.h
//  EduLoop
//
//  Created by bytedance on 2021/7/22.
//

#import "NELCenterOverlay.h"

NS_ASSUME_NONNULL_BEGIN

@interface NELCenterCustomOverlay : NELCenterOverlay

@property(nonatomic,strong,readwrite) NSString *imageUrl;
@property(nonatomic,strong,readwrite) NSString *titleStr;
@property(nonatomic,strong,readwrite) NSString *subtitleStr;
@property(nonatomic,readwrite) CGRect imgFrame;
- (instancetype)initWithImageFrame:(CGRect)frame Title:(NSString *)title SubTitle:(NSString *)subtitle ImageUrl:(NSString *)imageUrl;
@end

NS_ASSUME_NONNULL_END
