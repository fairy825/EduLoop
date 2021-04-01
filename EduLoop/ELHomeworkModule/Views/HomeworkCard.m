//
//  HomeworkCard.m
//  EduLoop
//
//  Created by mijika on 2021/3/30.
//

#import "HomeworkCard.h"
#import "UIColor+MyTheme.h"
#import <Masonry/Masonry.h>
@implementation HomeworkCard
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)loadData:(HomeworkModel *)data{
    _data = data;
    _detailLabel.text = _data.detail;
    _timeLabel.text = _data.publishTime;
    _parentLabel.text = [NSString stringWithFormat:@"%@%@",@"家长：",_data.authorName];
    _studentLabel.text = _data.studentName;
    _finishTag.text = _data.delay?@"按时完成":@"未按时完成";
    _avatarImage.image = [UIImage imageNamed:@"avatar-4"];

    if(_data.hasViewed==YES){
    }

}
- (void)setupSubviews{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(20, 20, 20, 20));
    }];
    
    [self.bgView addSubview:self.avatarImage];
    [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.left.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.bgView addSubview:self.studentLabel];
    [self.studentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(5);
        make.left.equalTo(self.avatarImage.mas_right).offset(10);
    }];
    
    [self.bgView addSubview:self.parentLabel];
    [self.parentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.avatarImage).offset(-5);
        make.left.equalTo(self.studentLabel);
    }];
    
    [self.bgView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImage.mas_bottom).offset(15);
        make.left.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
    }];
    
    [self.bgView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.bgView);
        make.left.equalTo(self.detailLabel);
    }];
    
    [self.bgView addSubview:self.finishTag];
    [self.finishTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView);
        make.left.equalTo(self.timeLabel.mas_right).offset(5);
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

- (UIImageView *)avatarImage{
    if(!_avatarImage){
        _avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _avatarImage.contentMode = UIViewContentModeScaleToFill;
        _avatarImage.layer.cornerRadius = 25;
        _avatarImage.layer.masksToBounds = YES;
        
    }
    return _avatarImage;
}

- (UILabel *)studentLabel{
    if(!_studentLabel){
        _studentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,50,20)];
        _studentLabel.text = @"dd";
        _studentLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.f];
        _studentLabel.textColor = [UIColor color333333];
        [_studentLabel sizeToFit];
    }
    return _studentLabel;
}

- (UILabel *)parentLabel{
    if(!_parentLabel){
        _parentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,50,20)];
        _parentLabel.text = [NSString stringWithFormat:@"%@%@",@"家长：",@"abc"];
        _parentLabel.font = [UIFont fontWithName:@"PingFangSC" size:16.f];
        _parentLabel.textColor = [UIColor color555555];
        [_parentLabel sizeToFit];
    }
    return _parentLabel;
}

- (UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,100,20)];
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC" size:14.f];
        _timeLabel.textColor = [UIColor color555555];
        [_timeLabel sizeToFit];
    }
    return _timeLabel;
}

- (UILabel *)detailLabel{
    if(!_detailLabel){
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,100,20)];
        _detailLabel.font = [UIFont systemFontOfSize:18.f];
        _detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.numberOfLines = 3;
        [_detailLabel sizeToFit];
    }
    return _detailLabel;
}

- (ELCustomLabel *)finishTag{
    if(!_finishTag){
        _finishTag =  [[ELCustomLabel alloc]init];
        _finishTag.backgroundColor = [UIColor clearColor];
        _finishTag.font = [UIFont systemFontOfSize:14.f];
        _finishTag.layer.cornerRadius = 5;
        _finishTag.layer.masksToBounds = YES;
        _finishTag.layer.borderWidth = 2;
        _finishTag.layer.borderColor = [UIColor redColor].CGColor;
        _finishTag.textAlignment = NSTextAlignmentCenter;
        [_finishTag setTextInsets:UIEdgeInsetsMake(3, 5, 3, 5)];
        [_finishTag sizeToFit];
        _finishTag.textColor = [UIColor orangeColor];
    }
    return _finishTag;
}

@end
