//
//  AvatarCard.m
//  EduLoop
//
//  Created by mijika on 2020/12/14.
//

#import "AvatarCard.h"
#import "UIColor+EHTheme.h"
#import <Masonry/Masonry.h>
@implementation AvatarCard

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
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    self.avatarImage.layer.cornerRadius = 30;
    self.avatarImage.layer.masksToBounds = YES;
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImage);
        make.left.equalTo(self.avatarImage.mas_right).offset(10);
    }];
    
    [self addSubview:self.publishTimeLabel];
    [self.publishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
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
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20.f];
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}

- (UILabel *)publishTimeLabel{
    if(!_publishTimeLabel){
        _publishTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,50,20)];
        _publishTimeLabel.font = [UIFont systemFontOfSize:14.f];
        _publishTimeLabel.textColor = [UIColor grayColor];
        [_publishTimeLabel sizeToFit];
    }
    return _publishTimeLabel;
}

@end
