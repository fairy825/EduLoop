//
//  NELOverlay.m
//  EduLoop
//
//  Created by bytedance on 2021/7/22.
//

#import "NELOverlay.h"
@interface NELOverlay()

@property(nonatomic,readwrite) CGFloat coverWidth;
@property(nonatomic,readwrite) CGFloat coverHeight;
@end

@implementation NELOverlay
- (instancetype)initWithFrame:(CGRect)frame
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self = [super initWithFrame:screenRect];
    if (self) {
        _highlightFrame = frame;
        self.coverWidth = screenWidth;
        self.coverHeight = screenHeight;
    }
    return self;
}

- (void)setUpSubviews{
    [self setUpHighlightView];
    [self addSubview:self.backgroundView];
    [self addSubview:self.highLightView];
    
}

- (void)showHighlightViewFromPoint:(CGPoint) point ToPoint:(CGPoint) point2 Animation:(BOOL)animated{
    if(animated){
        self.highLightView.frame = CGRectMake(point.x, point.y,  self.highLightView.frame.size.width,self.highLightView.frame.size.height);
        [UIApplication.sharedApplication.windows.lastObject addSubview:self];
        [UIView animateWithDuration:1.f delay:0.f usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.highLightView.center = point2;

        } completion:nil];
    }else{
        [UIApplication.sharedApplication.windows.lastObject addSubview:self];
        self.highLightView.center = point2;
    }
}

- (void)dismissOverlay{
    [self removeFromSuperview];
}
#pragma mark - View
- (UIView *)backgroundView{
    if(!_backgroundView){
        
        self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.coverWidth,self.coverHeight)];
        self.backgroundView.backgroundColor = [UIColor grayColor];
        self.backgroundView.alpha = 0.5;
        [self.backgroundView addGestureRecognizer: ({
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissOverlay)];
            recognizer;
        })];
    }
    return _backgroundView;
}

- (UIView *)highLightView{
    if(!_highLightView){
        _highLightView = [[UIView alloc]initWithFrame:_highlightFrame];
        _highLightView.layer.cornerRadius = 15;
        _highLightView.layer.masksToBounds = YES;
        _highLightView.backgroundColor = [UIColor whiteColor];
    }
    return _highLightView;
}

@end
