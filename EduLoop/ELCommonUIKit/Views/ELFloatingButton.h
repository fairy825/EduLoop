//
//  ELFloatingButton.h
//  EduLoop
//
//  Created by mijika on 2020/12/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ELFloatingButtonDelegate<NSObject>
-(void)clickFloatingButton;
@end

@interface ELFloatingButton : UIButton

@property(nonatomic,strong,readwrite) UIView *shadow;
@property(nonatomic,strong,readwrite) UIImage *iconImage;
@property(nonatomic,strong,readwrite) UIButton *aButton;
@property(nonatomic,weak,readwrite) id<ELFloatingButtonDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame Image:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
