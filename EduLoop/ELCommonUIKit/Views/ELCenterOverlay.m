//
//  ELCenterOverlay.m
//  EduLoop
//
//  Created by mijika on 2020/12/15.
//

#import "ELCenterOverlay.h"
#import <Masonry/Masonry.h>
#import "UIColor+ELColor.h"

@implementation ELCenterOverlay
- (instancetype)initWithFrame:(CGRect)frame Data:(ELCenterOverlayModel *)model
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self = [super initWithFrame:screenRect];
    if (self) {
        self.coverWidth = screenWidth;
        self.coverHeight = screenHeight;
        [self setUpSubviews];
        _model = model;
        [self loadData];
    }
    return self;
}


- (void)loadData{
    _titleLabel.text = _model.title;
    _subTitleLabel.text = _model.subTitle;
    ELOverlayItem * leftItem = _model.leftChoice;
    [_leftButton setTitle:leftItem.title forState:UIControlStateNormal];
    [_rightButton setTitle:@"取消" forState:UIControlStateNormal];
}

- (void)setUpSubviews{
  
    [self addSubview:self.backgroundView];
    [self addSubview:self.alertView];
}

- (void)showHighlightViewFromPoint:(CGPoint) point ToPoint:(CGPoint) point2 Animation:(BOOL)animated{
    if(animated){
        self.alertView.frame = CGRectMake(point.x, point.y,  250,150);
        [UIApplication.sharedApplication.windows.lastObject addSubview:self];
        [UIView animateWithDuration:1.f delay:0.f usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alertView.center = point2;

        } completion:nil];
    }else{
        [UIApplication.sharedApplication.windows.lastObject addSubview:self];
        self.alertView.center = point2;
    }
}
- (void)showHighlightView{
    [self showHighlightViewFromPoint:CGPointZero ToPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/3) Animation:NO];
}

#pragma mark - View
- (UIView *)backgroundView{
    if(!_backgroundView){
        self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _coverWidth, _coverHeight)];
        self.backgroundView.backgroundColor = [UIColor grayColor];
        self.backgroundView.alpha = 0.5;
    }
    return _backgroundView;
}

- (UIView *)alertView{
    if(!_alertView){
        
        _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,320 ,180)];
        _alertView.layer.cornerRadius = 15;
        _alertView.layer.masksToBounds = YES;
        
        _alertView.backgroundColor = [UIColor whiteColor];
        
        
        [self.alertView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.alertView).offset(30);
            make.height.equalTo(@45);
            make.centerX.equalTo(self.alertView);
            make.width.equalTo(@(self.alertView.bounds.size.width-30));
        }];
        
        [self.alertView addSubview:self.subTitleLabel];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.height.equalTo(@35);
            make.centerX.equalTo(self.alertView);
            make.width.equalTo(@(self.alertView.bounds.size.width-30));
        }];
        
        [self.alertView addSubview:self.leftButton];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.alertView);
            make.right.equalTo(self.alertView.mas_centerX);
            make.top.equalTo(_subTitleLabel.mas_bottom);
            make.bottom.equalTo(self.alertView);
        }];
        
        [self.alertView addSubview:self.rightButton];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftButton.mas_right);
            make.right.equalTo(self.alertView);
            make.top.equalTo(self.leftButton);
            make.bottom.equalTo(self.leftButton);
        }];
        
        [self.alertView addSubview:self.seperator];
        [self.seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.alertView);
            make.centerY.equalTo(self.leftButton);
            make.width.equalTo(@1);
            make.height.equalTo(@20);
        }];
    }
    return _alertView;
}

- ( UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20.f];
        _titleLabel.numberOfLines =1;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- ( UILabel *)subTitleLabel{
    if(!_subTitleLabel){
        _subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,50,20)];
        _subTitleLabel.font = [UIFont systemFontOfSize:16.f];
        _subTitleLabel.textColor = [UIColor grayColor];
        _subTitleLabel.numberOfLines =0;
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_subTitleLabel sizeToFit];
    }
    return _subTitleLabel;
}
- (UIView *)seperator{
    if(!_seperator){
        _seperator = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 20)];
        _seperator.backgroundColor = [UIColor grayColor];
    }
    return _seperator;
}
- (UIButton *)leftButton{
    if(!_leftButton){
        _leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
 
        [_leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_leftButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:20]];
        [_leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton{
    if(!_rightButton){
        _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];

        [_rightButton setTitleColor:[UIColor themeBlue] forState:UIControlStateNormal];
        [_rightButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:20]];
        [_rightButton addTarget:self action:@selector(dismissOverlay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
#pragma mark - action

- (void)dismissOverlay{
    [self removeFromSuperview];
}

- (void)clickLeftButton{
    dispatch_block_t clickBlock =_model.leftChoice.clickBlock;
    if(clickBlock)
        clickBlock();
    [self dismissOverlay];
}
@end
