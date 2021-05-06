//
//  TaskDetailCard.m
//  EduLoop
//
//  Created by mijika on 2021/3/30.
//

#import "TaskDetailCard.h"
#import "UIColor+MyTheme.h"
#import <Masonry/Masonry.h>
#import <SDWebImage.h>

@implementation TaskDetailCard
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 10;

    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(20, 20, 20, 20));
    }];
    
    [self.bgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.left.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
    }];
    
    [self.bgView addSubview:self.teacherLabel];
    [self.bgView addSubview:self.avatarImage];
    [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.teacherLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatarImage);
        make.left.equalTo(self.titleLabel);
    }];
    
    [self.bgView addSubview:self.seperateLine];
    [self.seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImage.mas_bottom).offset(10);
        make.height.equalTo(@5);
        make.left.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
    }];
    
    [self.bgView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.seperateLine.mas_bottom).offset(10);
        make.left.equalTo(self.seperateLine);
        make.width.equalTo(self.bgView);
    }];
    
    [self.bgView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.bgView);
        make.left.equalTo(self.detailLabel);
        make.width.equalTo(self.bgView);
        make.height.equalTo(@21);
    }];
    
}

- (void)loadData:(TeacherTaskModel *)data{
    _data = data;
    _titleLabel.text = _data.title;
    _detailLabel.text = _data.content;
    _timeLabel.text = _data.publishTime;
    _teacherLabel.text = _data.creatorName;
    [_avatarImage sd_setImageWithURL:[NSURL URLWithString:data.creatorAvatar] placeholderImage:[UIImage imageNamed:@"icon_teacher"]];

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
        _avatarImage.layer.cornerRadius = 20;
        _avatarImage.layer.masksToBounds = YES;
        
    }
    return _avatarImage;
}

- (UIView *)seperateLine{
    if(!_seperateLine){
        _seperateLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 10)];
        _seperateLine.backgroundColor = [UIColor f6f6f6];
    }
    return _seperateLine;
}

- (UIImageView *)arrowImage{
    if(!_arrowImage){
        _arrowImage = [[UIImageView alloc]init];
        _arrowImage.image = [UIImage imageNamed:@"right_arrow_gray"];
        _arrowImage.contentMode = UIViewContentModeScaleToFill;
        _arrowImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toggleCard)];
        [_arrowImage addGestureRecognizer:tapGesture];
    }
    return _arrowImage;
}

- (UILabel *)teacherLabel{
    if(!_teacherLabel){
        _teacherLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,100,20)];
        _teacherLabel.font = [UIFont fontWithName:@"PingFangSC" size:16.f];
        _teacherLabel.textColor = [UIColor color555555];
        [_teacherLabel sizeToFit];
    }
    return _teacherLabel;
}

- (UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,100,20)];
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC" size:16.f];
        _timeLabel.textColor = [UIColor color555555];
        [_timeLabel sizeToFit];
    }
    return _timeLabel;
}


- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,100,20)];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20.f];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel{
    if(!_detailLabel){
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,100,20)];
        _detailLabel.font = [UIFont systemFontOfSize:16.f];
        _detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.numberOfLines = 0;
        [_detailLabel sizeToFit];
    }
    return _detailLabel;
}

#pragma mark - action
-(void)toggleCard{
    NSLog(@"toggle");
}
@end
