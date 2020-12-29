//
//  ELCenterOverlay.h
//  EduLoop
//
//  Created by mijika on 2020/12/15.
//

#import <Foundation/Foundation.h>
#import "ELCenterOverlayModel.h"
#import "ELOverlay.h"
NS_ASSUME_NONNULL_BEGIN

@interface ELCenterOverlay : UIView
@property(nonatomic,strong,readwrite) UIView *backgroundView;
@property(nonatomic,strong,readwrite) UILabel *titleLabel;
@property(nonatomic,strong,readwrite) UILabel *subTitleLabel;
@property(nonatomic,strong,readwrite) UIButton *leftButton;
@property(nonatomic,strong,readwrite) UIButton *rightButton;
@property(nonatomic,strong,readwrite) UIView *seperator;
@property(nonatomic,strong,readwrite) UIView *alertView;

@property(nonatomic,readwrite) CGFloat coverWidth;
@property(nonatomic,readwrite) CGFloat coverHeight;
@property(nonatomic,strong,readwrite) ELCenterOverlayModel *model;
//@property(nonatomic,strong,readwrite) NSMutableArray<ELOverlayItem *> *choices;
- (instancetype)initWithFrame:(CGRect)frame Data:(ELCenterOverlayModel *)data;
- (void)showHighlightView;
@end

NS_ASSUME_NONNULL_END
