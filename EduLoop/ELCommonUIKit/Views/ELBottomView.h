//
//  ELBottomView.h
//  EduLoop
//
//  Created by mijika on 2021/3/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol  ELBottomViewDelegate<NSObject>

-(void)clickRightLabel;

@end
@interface ELBottomView : UIView

@property(nonatomic,readwrite) CGFloat coverWidth;
@property(nonatomic,readwrite) CGFloat coverHeight;
@property(nonatomic,strong,readwrite) UIView *backgroundView;
@property(nonatomic,strong,readwrite) UIView *highLightView;
@property(nonatomic,strong,readwrite) UIView *contentView;
@property(nonatomic,strong,readwrite) UILabel *titleLabel;
@property(nonatomic,strong,readwrite) UIButton *rightButton;
@property(nonatomic,strong,readwrite) UIButton *cancelBtn;
@property(nonatomic,weak,readwrite) id<ELBottomViewDelegate> delegate;
- (void)setUpSubviews;
- (void)showHighlightViewFromPoint:(CGPoint) point ToPoint:(CGPoint) point2 Animation:(BOOL)animated;
- (void)showHighlightView;
- (void)dismissOverlay;
@end

NS_ASSUME_NONNULL_END
