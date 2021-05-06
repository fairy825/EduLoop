//
//  ELBottomView.m
//  EduLoop
//
//  Created by mijika on 2021/3/31.
//

#import "ELBottomView.h"
#import "UIColor+MyTheme.h"
@implementation ELBottomView

- (instancetype)init
{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self = [super initWithFrame:screenRect];
    if (self) {
        self.coverWidth = screenWidth;
        self.coverHeight = screenHeight;
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews{
  
    [self addSubview:self.backgroundView];
    [self addSubview:self.highLightView];
    [self.highLightView addSubview:self.cancelBtn];
    [self.highLightView addSubview:self.titleLabel];
    [self.highLightView addSubview:self.rightButton];

}

- (void)showHighlightViewFromPoint:(CGPoint) point ToPoint:(CGPoint) point2 Animation:(BOOL)animated{
    if(animated){
        self.highLightView.frame = CGRectMake(point.x, point.y,self.highLightView.bounds.size.width,self.highLightView.bounds.size.height);
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
        self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _coverWidth, _coverHeight)];
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
        _highLightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _coverWidth, _coverHeight)];
        _highLightView.backgroundColor = [UIColor whiteColor];
    }
    return _highLightView;
}

- (UIButton *)cancelBtn{
    if(!_cancelBtn){
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        _cancelBtn.backgroundColor = [UIColor clearColor];
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"icon_cancel"] forState:UIControlStateNormal];
//        [_cancelBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        [_cancelBtn addTarget:self action:@selector(dismissOverlay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.f];
        _titleLabel.textColor = [UIColor blackColor];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UIButton *)rightButton{
    if(!_rightButton){
        _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_rightButton setTitleColor:[UIColor color5bb2ff] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(finishEditing) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (void)reload{
    self.cancelBtn.frame = CGRectMake(20, 10, 20, 20);
    self.titleLabel.center = CGPointMake(self.contentView.bounds.size.width/2, self.cancelBtn.center.y);
    self.rightButton.frame = CGRectMake(self.contentView.bounds.size.width-20-50,10,50, 20);

    [self.highLightView addSubview:self.contentView];
    self.contentView.frame = CGRectMake(0, 30, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    self.highLightView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height+30);
}

- (void)showHighlightView{
    [self reload];
    [self showHighlightViewFromPoint:CGPointMake((self.coverWidth-self.highLightView.bounds.size.width)/2,self.coverHeight) ToPoint:CGPointMake(self.coverWidth/2,self.coverHeight-self.highLightView.bounds.size.height/2) Animation:YES];
}

- (void)finishEditing{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(clickRightLabel)]){
        [self.delegate clickRightLabel];
    }
    [self dismissOverlay];
}
@end
