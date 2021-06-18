//
//  ReviewCard.m
//  EduLoop
//
//  Created by mijika on 2021/3/30.
//

#import "ReviewCard.h"
#import <Masonry/Masonry.h>
@implementation ReviewCard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)loadData:(ReviewModel *)data{
    _data = data;
    _detailLabel.text = _data.detail;
    _scoreLabel.text = [NSString stringWithFormat:@"%ld%@",(long)_data.score,@"分"];
    _teacherLabel.text = _data.teacherNickname;

}

- (void)setupSubviews{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(20, 20, 150, 20));
    }];
    
    [self.bgView addSubview:self.teacherLabel];
    [self.teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.left.equalTo(self.bgView);
    }];
    
    [self.bgView addSubview:self.scoreLabel];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.teacherLabel);
        make.left.equalTo(self.teacherLabel.mas_right).offset(10);
    }];
    
    [self.bgView addSubview:self.updateButton];
    [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
        make.width.mas_equalTo(@45);
    }];
    
    [self.bgView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scoreLabel.mas_bottom).offset(15);
        make.left.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView);
    }];
    
    
}

#pragma mark - View
- (UIView *)bgView{
    if(!_bgView){
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 200)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UILabel *)scoreLabel{
    if(!_scoreLabel){
        _scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,50,20)];
        _scoreLabel.font = [UIFont fontWithName:@"PingFangSC" size:24.f];
        _scoreLabel.textColor = [UIColor redColor];
        [_scoreLabel sizeToFit];
    }
    return _scoreLabel;
}

- (UILabel *)detailLabel{
    if(!_detailLabel){
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,100,20)];
        _detailLabel.font = [UIFont systemFontOfSize:18.f];
        _detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.numberOfLines = 0;
        [_detailLabel sizeToFit];
    }
    return _detailLabel;
}

- (UIButton *)updateButton{
    if(!_updateButton){
        _updateButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
        _updateButton.backgroundColor = [UIColor clearColor];
        _updateButton.layer.borderWidth = 2;
        _updateButton.layer.borderColor = [UIColor grayColor].CGColor;
        _updateButton.layer.cornerRadius = 5;
        _updateButton.layer.masksToBounds = YES;
        [_updateButton setTitle:@"修改" forState:UIControlStateNormal];
        [_updateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_updateButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC" size:16]];
        [_updateButton addTarget:self action:@selector(clickUpdateButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updateButton;
}

- (UILabel *)teacherLabel{
    if(!_teacherLabel){
        _teacherLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,100,20)];
        _teacherLabel.font = [UIFont fontWithName:@"PingFangSC" size:16.f];
        _teacherLabel.textColor = [UIColor grayColor];
        [_teacherLabel sizeToFit];
    }
    return _teacherLabel;
}

- (void)clickUpdateButton{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(clickUpdateBtn:)]){
        [self.delegate clickUpdateBtn:self];
    }
}
@end
