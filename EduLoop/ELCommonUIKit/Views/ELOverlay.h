//
//  ELOverlay.h
//  EduLoop
//
//  Created by mijika on 2020/12/9.
//

#import <UIKit/UIKit.h>
#import "ELOverlayItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ELOverlayDelegate<NSObject>
@optional
- (void) getChosenTitle:(NSString *)title;
@end


@interface ELOverlay : UIView
@property(nonatomic,readwrite) CGFloat coverWidth;
@property(nonatomic,readwrite) CGFloat coverHeight;
@property(nonatomic,strong,readwrite) NSMutableArray<ELOverlayItem *> *choices;
@property(nonatomic,strong,readwrite) UIView *backgroundView;
@property(nonatomic,strong,readwrite) UIView *highLightView;
@property(nonatomic,weak,readwrite) id<ELOverlayDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame Data:(NSArray<ELOverlayItem *> *)data;
- (void)setUpSubviews;
- (void)showHighlightViewFromPoint:(CGPoint) point ToPoint:(CGPoint) point2 Animation:(BOOL)animated;

@end

@interface ELBottomOverlay : ELOverlay
- (void)showHighlightView;
@end

NS_ASSUME_NONNULL_END
