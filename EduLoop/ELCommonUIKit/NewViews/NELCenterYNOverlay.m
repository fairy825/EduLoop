//
//  NELCenterYNOverlay.m
//  EduLoop
//
//  Created by bytedance on 2021/7/22.
//

#import "NELCenterYNOverlay.h"
#import <Masonry.h>
#import "UIColor+ELColor.h"
@interface NELCenterYNOverlay()

@property(nonatomic,strong,readwrite) UIButton *leftButton;
@property(nonatomic,strong,readwrite) UIButton *rightButton;
@property(nonatomic,strong,readwrite) UIView *seperator;
@property(nonatomic,strong,readwrite) UILabel *titleLabel;
@property(nonatomic,strong,readwrite) UILabel *subTitleLabel;
@end

@implementation NELCenterYNOverlay
- (instancetype)init
{
    self = [super init];
    if (self) {
        return [self initWithData:nil];
    }
    return self;
}
- (instancetype)initWithData:(ELCenterOverlayModel *)model
{
    self = [super initWithFrame:CGRectMake(0, 0, 250, 150)];
    if (self) {
        [self setUpSubviews];

        _model = model;
        [self loadData];

    }
    return self;
}

- (void)setUpHighlightView{
    [self.highLightView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.highLightView).offset(30);
        make.height.equalTo(@45);
        make.centerX.equalTo(self.highLightView);
        make.width.equalTo(@(self.highLightView.bounds.size.width-30));
    }];
    
    [self.highLightView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.equalTo(@35);
        make.centerX.equalTo(self.highLightView);
        make.width.equalTo(@(self.highLightView.bounds.size.width-30));
    }];
    
    [self.highLightView addSubview:self.leftButton];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.highLightView);
        make.right.equalTo(self.highLightView.mas_centerX);
        make.top.equalTo(_subTitleLabel.mas_bottom);
        make.bottom.equalTo(self.highLightView);
    }];
    
    [self.highLightView addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftButton.mas_right);
        make.right.equalTo(self.highLightView);
        make.top.equalTo(self.leftButton);
        make.bottom.equalTo(self.leftButton);
    }];
    
    [self.highLightView addSubview:self.seperator];
    [self.seperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.highLightView);
        make.centerY.equalTo(self.leftButton);
        make.width.equalTo(@1);
        make.height.equalTo(@20);
    }];
}


- (void)loadData{
    _titleLabel.text = _model.title;
    _subTitleLabel.text = _model.subTitle;
    ELOverlayItem * leftItem = _model.leftChoice;
    [_leftButton setTitle:leftItem.title forState:UIControlStateNormal];
    [_rightButton setTitle:@"取消" forState:UIControlStateNormal];
}

- (void)clickLeftButton{
    dispatch_block_t clickBlock =_model.leftChoice.clickBlock;
    if(clickBlock)
        clickBlock();
    [self dismissOverlay];
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

@end
