//
//  MineInfoCard.m
//  EduLoop
//
//  Created by mijika on 2020/12/2.
//

#import "MineInfoCard.h"
#import <Masonry/Masonry.h>
#import "UIColor+MyTheme.h"
@implementation MineInfoCard
- (instancetype)initWithFrame:(CGRect)frame Model:(ProfileModel *)model
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
    _nameLabel.text = _model.name;
//    NSString *str =@"123435";
//    _nameLabel.text = str;
    _identityLabel.text = _model.identity==YES?@"家长":@"教师";
    _avatarView.image = [UIImage imageNamed:@"avatar_child_2"];

}

- (void)setupView{
    self.backgroundColor = [UIColor clearColor];
   
    self.avatarView.backgroundColor = [UIColor e1e1e1];
    [self addSubview:self.avatarView];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self).offset(20);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    self.avatarView.layer.cornerRadius = 35;
    self.avatarView.layer.masksToBounds = YES;
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarView).offset(10);
        make.left.equalTo(self.avatarView.mas_right).offset(20);
    }];
    
    [self addSubview:self.identityTag];
    [self.identityTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
    }];
    
    [self addSubview:self.schoolLabel];
    [self.schoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.nameLabel.mas_left);
    }];
    
    [self addSubview:self.gradeLabel];
       [self.gradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.schoolLabel);
           make.left.equalTo(self.schoolLabel.mas_right).offset(5);
       }];
    
    [self addSubview:self.arrowImage];
    [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatarView.mas_centerY);
        make.right.equalTo(self).offset(-20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

#pragma mark - View
- (UIImageView *)avatarView{
    if(!_avatarView){
        _avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
        _avatarView.contentMode = UIViewContentModeScaleToFill;
    }
    return _avatarView;
}

- (UIImageView *)arrowImage{
    if(!_arrowImage){
        _arrowImage = [[UIImageView alloc]init];
        _arrowImage.image = [UIImage imageNamed:@"right_arrow_gray"];
        _arrowImage.contentMode = UIViewContentModeScaleToFill;
    }
    return _arrowImage;
}

- (UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 70,50,20)];
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20.f];
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}

- (UILabel *)schoolLabel{
    if(!_schoolLabel){
        _schoolLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 100,50,20)];
//        _schoolLabel.text = @"设置学校";
//        NSString *schoolStr = @"华东师范大学";
//        if(schoolStr.length!=0){
//            _schoolLabel.text = schoolStr;
//        }
        _schoolLabel.font = [UIFont systemFontOfSize:12.f];
        _schoolLabel.textColor = [UIColor grayColor];
        [_schoolLabel sizeToFit];
    }
    return _schoolLabel;
}

- (UILabel *)gradeLabel{
    if(!_gradeLabel){
        _gradeLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 100,50,20)];
//        _gradeLabel.text = @"设置年级";
//        NSString *gradeStr = @"初三";
//        if(gradeStr.length!=0){
//            _gradeLabel.text = gradeStr;
//        }
        _gradeLabel.font = [UIFont systemFontOfSize:12.f];
        _gradeLabel.textColor = [UIColor grayColor];
        [_gradeLabel sizeToFit];
    }
    return _gradeLabel;
}

- (UILabel *)identityLabel{
    if(!_identityLabel){
        _identityLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,50,20)];
        _identityLabel.font = [UIFont systemFontOfSize:12.f];
        _identityLabel.textColor = [UIColor color5bb2ff];
        [_identityLabel sizeToFit];
    }
    return _identityLabel;
}

- (UIView *)identityTag{
    if(!_identityTag){
        
        _identityTag = [[UIView alloc]initWithFrame:CGRectMake(0, 0,70,20)];
        _identityTag.layer.cornerRadius = 5;
        _identityTag.layer.borderWidth = 2;
        _identityTag.layer.borderColor = [UIColor color5bb2ff].CGColor;
        [_identityTag addSubview:self.identityLabel];
           [self.identityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
               make.edges.equalTo(_identityTag).mas_offset(UIEdgeInsetsMake(3, 3, 3, 3));
           }];
    }
    return _identityTag;
}
@end
