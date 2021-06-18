//
//  ProfileSummaryCard.m
//  EduLoop
//
//  Created by mijika on 2021/4/4.
//

#import "ProfileSummaryCard.h"
#import <Masonry/Masonry.h>
@implementation ProfileSummaryCard

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
   
    [self addSubview:self.avatarImage];
    [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    self.avatarImage.layer.cornerRadius = 20;
    self.avatarImage.layer.masksToBounds = YES;
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImage).offset(10);
        make.left.equalTo(self.avatarImage.mas_right).offset(10);
    }];
    
    [self addSubview:self.teamLabel];
    [self.teamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.avatarImage).offset(-10);
        make.left.equalTo(self.nameLabel);
    }];
}

#pragma mark - View
- (UIImageView *)avatarImage{
    if(!_avatarImage){
        _avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _avatarImage.image = [UIImage imageNamed:@"avatar-4"];
        _avatarImage.contentMode = UIViewContentModeScaleToFill;
    }
    return _avatarImage;
}

- (UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,50,20)];
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14.f];
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}

- (UILabel *)teamLabel{
    if(!_teamLabel){
        _teamLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,50,20)];
        _teamLabel.font = [UIFont systemFontOfSize:14.f];
        _teamLabel.textColor = [UIColor grayColor];
        [_teamLabel sizeToFit];
    }
    return _teamLabel;
}

@end
