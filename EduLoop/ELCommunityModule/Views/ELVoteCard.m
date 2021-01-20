//
//  ELVoteCard.m
//  EduLoop
//
//  Created by mijika on 2020/12/18.
//

#import "ELVoteCard.h"
#import "UIColor+EHTheme.h"
#import <Masonry/Masonry.h>
#import "ELScreen.h"
@implementation ELVoteCard

- (instancetype)initWithFrame:(CGRect)frame Data:(UgcModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        _model = model;
        [self setupView];
        [self loadData];
    }
    return self;
}

- (void)loadData{
    _titleLabel.text = _model.detail;
    [_leftButton setTitle:[NSString stringWithFormat:@"%@", _model.leftChoice] forState:UIControlStateNormal];
    [_rightButton setTitle:[NSString stringWithFormat:@"%@", _model.rightChoice] forState:UIControlStateNormal];
    _leftLabel.text = [NSString stringWithFormat:@"%@%.2f%@",_model.leftChoice,self.model.leftPercent,@"%" ];
    _rightLabel.text = [NSString stringWithFormat:@"%.2f%@%@",100-self.model.leftPercent,@"% ",_model.rightChoice];

    }

- (void)setupView{
    self.backgroundColor = [UIColor eh_eeeeee];

    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(20, 20, 20, 20));
    }];

    [self.bgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.left.equalTo(self.bgView);
        make.width.equalTo(self.bgView);
        make.height.lessThanOrEqualTo(@25);
    }];
    if(!_model.hasPicked){
    [self.bgView addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.right.equalTo(self.bgView);
        make.left.equalTo(self.mas_centerX);
        make.height.equalTo(@40);
    }];

    [self.bgView addSubview:self.leftButton];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightButton);
        make.left.equalTo(self.bgView);
        make.right.equalTo(self.mas_centerX);
        make.height.equalTo(@40);
    }];
    }else{
    [self.bgView addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.right.equalTo(self.bgView);
        make.left.equalTo(self.mas_centerX);
        make.height.equalTo(@20);
    }];

    [self.bgView addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightLabel);
        make.left.equalTo(self.bgView);
        make.right.equalTo(self.mas_centerX);
        make.height.equalTo(@20);
    }];
    CGFloat leftWidth = (float)self.model.leftPercent/100*(SCREEN_WIDTH-80);
    [self.bgView addSubview:self.leftProgress];
    [self.leftProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftLabel.mas_bottom).offset(5);
        make.left.equalTo(self.leftLabel);
        make.width.equalTo(@(leftWidth));
        make.height.equalTo(@5);
    }];
    [self.bgView addSubview:self.rightProgress];
    [self.rightProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightLabel.mas_bottom).offset(5);
        make.right.equalTo(self.rightLabel);
        make.left.equalTo(self.leftProgress.mas_right);
        make.right.equalTo(self.bgView);
        make.height.equalTo(@5);
    }];
    }
}

#pragma mark - View
- (UIView *)bgView{
    if(!_bgView){
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 200)];
        _bgView.backgroundColor = [UIColor eh_eeeeee];
    }
    return _bgView;
}

- (UIButton *)leftButton{
    if(!_leftButton){
        _leftButton =
        [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width/2+5, 40)];
        _leftButton.backgroundColor = [UIColor eh_colorWithHexRGB:EHThemeColor_Red];
        [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC" size:20]];
        CGSize size = _leftButton.bounds.size;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(size.width, 0)];
        [path addLineToPoint:CGPointMake(size.width * 0.9f, size.height)];
        [path addLineToPoint:CGPointMake(0, size.height)];
        [path closePath];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = _leftButton.bounds;
        maskLayer.path = path.CGPath;
        _leftButton.layer.mask = maskLayer;
    }
    return _leftButton;
}

- (UIButton *)rightButton{
    if(!_rightButton){
        _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width/2+5, 40)];
        _rightButton.backgroundColor = [UIColor eh_colorWithHexRGB:EHThemeColor_Blue];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC" size:20]];
        CGSize size = _rightButton.bounds.size;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0.1f * size.width, 0)];
        [path addLineToPoint:CGPointMake(size.width, 0)];
        [path addLineToPoint:CGPointMake(size.width, size.height)];
        [path addLineToPoint:CGPointMake(0, size.height)];
        [path closePath];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = _rightButton.bounds;
        maskLayer.path = path.CGPath;
        _rightButton.layer.mask = maskLayer;
    }
    return _rightButton;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UILabel *)leftLabel{
    if(!_leftLabel){
        _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 100, 20)];
        _leftLabel.font = [UIFont systemFontOfSize:14.f];
        _leftLabel.textColor = [UIColor eh_colorWithHexRGB:EHThemeColor_Red];
        [_leftLabel sizeToFit];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel{
    if(!_rightLabel){
        _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 100, 20)];
        _rightLabel.font = [UIFont systemFontOfSize:14.f];
        _rightLabel.textColor = [UIColor eh_colorWithHexRGB:EHThemeColor_Blue];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        [_rightLabel sizeToFit];
    }
    return _rightLabel;
}

- (UIView *)leftProgress{
    if(!_leftProgress){
        CGFloat width = self.bounds.size.width/2+5;
        _leftProgress =
        [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 10)];
        _leftProgress.backgroundColor = [UIColor eh_colorWithHexRGB:EHThemeColor_Red];
    }
    return _leftProgress;
}

- (UIView *)rightProgress{
    if(!_rightProgress){
        CGFloat width = self.bounds.size.width/2+5;
        _rightProgress =
        [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 10)];
        _rightProgress.backgroundColor = [UIColor eh_colorWithHexRGB:EHThemeColor_Blue];
    }
    return _rightProgress;
}
@end

