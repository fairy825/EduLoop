//
//  TeacherTaskSummaryTableViewCell.m
//  EduLoop
//
//  Created by mijika on 2021/3/29.
//

#import "TeacherTaskSummaryTableViewCell.h"
#import "UIColor+MyTheme.h"
#import <Masonry/Masonry.h>
@implementation TeacherTaskSummaryTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).mas_offset(UIEdgeInsetsMake(15, 20, 15, 20));
    }];
    
    [self.bgView addSubview:self.avatarImage];
    [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.left.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    self.avatarImage.layer.cornerRadius = 20;
    self.avatarImage.layer.masksToBounds = YES;
    
    [self.bgView addSubview:self.studentLabel];
    [self.studentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.left.equalTo(self.avatarImage.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.bgView);
        make.height.equalTo(@20);
    }];
    
    [self.bgView addSubview:self.parentLabel];
    [self.parentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.studentLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.bgView);
        make.left.equalTo(self.studentLabel);
    }];
    
    [self.bgView addSubview:self.arrowImage];
    [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.right.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.bgView addSubview:self.hintLabel];
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.arrowImage.mas_centerY);
        make.right.equalTo(self.arrowImage.mas_left);
    }];
    
}

- (void)loadData{
    _parentLabel.text = [NSString stringWithFormat:@"%@%@",@"家长：",_data.authorName];
    _studentLabel.text = _data.studentName;
    if(_data.hasViewed==YES){
        _hintLabel.text = @"已点评";
    }else{
        _hintLabel.text = @"去点评";
    }

}

#pragma mark - Views
- (UIView *)bgView{
    if(!_bgView){
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 200)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIImageView *)avatarImage{
    if(!_avatarImage){
        _avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        _avatarImage.image = [UIImage imageNamed:@"avatar-4"];
        _avatarImage.contentMode = UIViewContentModeScaleToFill;
    }
    return _avatarImage;
}

- (UIImageView *)arrowImage{
    if(!_arrowImage){
        _arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,20,20)];
        _arrowImage.image = [UIImage imageNamed:@"right_arrow_gray"];
        _arrowImage.contentMode = UIViewContentModeScaleToFill;
    }
    return _arrowImage;
}

- (UILabel *)hintLabel{
    if(!_hintLabel){
        _hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,50,20)];
        _hintLabel.text = @"去点评";
        _hintLabel.textColor = [UIColor color555555];
        _hintLabel.font = [UIFont fontWithName:@"PingFangSC" size:16.f];
        [_hintLabel sizeToFit];
    }
    return _hintLabel;
}

- (UILabel *)studentLabel{
    if(!_studentLabel){
        _studentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,50,20)];
        _studentLabel.text = @"dd";
        _studentLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20.f];
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

@end
