//
//  ELBottomSelectOverlay.h
//  EduLoop
//
//  Created by mijika on 2021/3/23.
//

#import <UIKit/UIKit.h>
#import "ELOverlay.h"

NS_ASSUME_NONNULL_BEGIN

@interface ELBottomSelectOverlay : ELBottomOverlay
@property(nonatomic,strong,readwrite) NSArray<NSString *> *subTitles;
@property(nonatomic,strong,readwrite) UIView *container;
@property(nonatomic,strong,readwrite) UIView *innerContainer;

@property(nonatomic,strong,readwrite) UIScrollView *scrollView;
@property(nonatomic,strong,readwrite) UILabel *titleLabel;
- (instancetype)initWithFrame:(CGRect)frame Data:(NSDictionary *)data SubTitles:(NSArray *)subtitles;

@end

NS_ASSUME_NONNULL_END
