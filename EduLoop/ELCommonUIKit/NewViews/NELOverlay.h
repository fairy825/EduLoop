//
//  NELOverlay.h
//  EduLoop
//
//  Created by bytedance on 2021/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NELOverlay : UIView
@property(nonatomic,readonly) CGFloat coverWidth;
@property(nonatomic,readonly) CGFloat coverHeight;
@property(nonatomic,readwrite) CGRect highlightFrame;
@property(nonatomic,strong,readwrite) UIView *backgroundView;
@property(nonatomic,strong,readwrite) UIView *highLightView;

- (void)showHighlightView;
- (void)loadData;
//- (instancetype)initWithFrame:(CGRect)frame Data:(NSArray<ELOverlayItem *> *)data;
- (void)setUpHighlightView;
- (void)setUpSubviews;
- (void)dismissOverlay;
- (void)showHighlightViewFromPoint:(CGPoint) point ToPoint:(CGPoint) point2 Animation:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
