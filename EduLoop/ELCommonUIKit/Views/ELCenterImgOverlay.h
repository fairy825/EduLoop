//
//  ELCenterImgOverlay.h
//  EduLoop
//
//  Created by mijika on 2021/4/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ELCenterImgOverlay : UIView
@property(nonatomic,strong,readwrite) UIView *backgroundView;
@property(nonatomic,strong,readwrite) UIView *alertView;
@property(nonatomic,strong,readwrite) UILabel *titleLabel;
@property(nonatomic,strong,readwrite) UILabel *subTitleLabel;
@property(nonatomic,strong,readwrite) UIButton *closeBtn;
@property(nonatomic,strong,readwrite) UIImageView *imageView;
@property(nonatomic,strong,readwrite) NSString *imageUrl;
@property(nonatomic,strong,readwrite) NSString *titleStr;
@property(nonatomic,strong,readwrite) NSString *subtitleStr;
@property(nonatomic,readwrite) CGRect imgFrame;

@property(nonatomic,readwrite) CGFloat coverWidth;
@property(nonatomic,readwrite) CGFloat coverHeight;
- (instancetype)initWithImageFrame:(CGRect)frame Title:(NSString *)title SubTitle:(NSString *)subtitle ImageUrl:(NSString *)imageUrl;
- (void)showHighlightView;
@end

NS_ASSUME_NONNULL_END
