//
//  AddressListTableViewCell.m
//  EduLoop
//
//  Created by mijika on 2021/1/5.
//

#import "AddressListTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+MyTheme.h"
#import <SDWebImage.h>

@implementation AddressListTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(ContactPersonModel *)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _data = model;
        [self setupView];
        [self loadData];
    }
    return self;
}

- (void)loadData{
    self.nameLabel.text = self.data.nickname;
    self.identityLabel.text = self.data.identity==YES?@"家长":@"教师";
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:self.data.avatar] placeholderImage: [UIImage imageNamed:@"avatar-4"]];
//    self.avatarImage.backgroundColor = [UIColor blackColor];
}

- (void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).mas_offset(UIEdgeInsetsMake(10, 20, 10, 20));
    }];
    
    [self.bgView addSubview:self.avatarImage];
    [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView);
        make.height.equalTo(@50);
        make.width.equalTo(@50);
        make.left.equalTo(self.bgView);
    }];
    
    [self.bgView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImage);
        make.left.equalTo(self.avatarImage.mas_right).offset(10);
    }];
    
    [self.bgView addSubview:self.identityLabel];
    [self.identityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.avatarImage);
        make.left.equalTo(self.nameLabel);
    }];
    
    [self.contentView addSubview:self.seperateView];
    [self.seperateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@2);
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.bgView);
    }];
    
}

#pragma mark - View
- (UIImageView *)avatarImage{
    if(!_avatarImage){
        _avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _avatarImage.contentMode = UIViewContentModeScaleToFill;
        _avatarImage.layer.cornerRadius = 25;
        _avatarImage.layer.masksToBounds = YES;
        
    }
    return _avatarImage;
}

- (UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,50,20)];
    
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.f];
        _nameLabel.numberOfLines = 1;
        _nameLabel.lineBreakMode = NSLayoutAttributeTrailing;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}

- (UILabel *)identityLabel{
    if(!_identityLabel){
        _identityLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,50,20)];
        _identityLabel.font = [UIFont systemFontOfSize:16.f];
        _identityLabel.textColor = [UIColor color999999];
        _identityLabel.numberOfLines = 1;
        _identityLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _identityLabel.textAlignment = NSTextAlignmentLeft;
        [_identityLabel sizeToFit];
    }
    return _identityLabel;
}

- (UIView *)bgView{
    if(!_bgView){
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 200)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIView *)seperateView{
    if(!_seperateView){
        _seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 3)];
        _seperateView.backgroundColor = [UIColor f6f6f6];
    }
    return _seperateView;
}
@end
