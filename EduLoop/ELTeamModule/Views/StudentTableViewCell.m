//
//  StudentTableViewCell.m
//  EduLoop
//
//  Created by mijika on 2021/4/25.
//

#import "StudentTableViewCell.h"

#import <Masonry/Masonry.h>
#import <SDWebImage.h>

@implementation StudentTableViewCell
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
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    self.avatarImage.layer.cornerRadius = 25;
    self.avatarImage.layer.masksToBounds = YES;
    
    [self.bgView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.left.equalTo(self.avatarImage.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.bgView);
        make.height.equalTo(@20);
    }];
    
    [self.bgView addSubview:self.snoLabel];
    [self.snoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.bgView);
    }];
    
}

- (void)loadData{
    _nameLabel.text = _data.name;
    _snoLabel.text = _data.sno;
    [_avatarImage sd_setImageWithURL:[NSURL URLWithString: _data.faceImage] placeholderImage: [UIImage imageNamed:@"avatar-4"]];

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
        _avatarImage.contentMode = UIViewContentModeScaleToFill;
    }
    return _avatarImage;
}

- (UILabel *)snoLabel{
    if(!_snoLabel){
        _snoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,50,20)];
        _snoLabel.textColor = [UIColor grayColor];
        _snoLabel.font = [UIFont fontWithName:@"PingFangSC" size:16.f];
        [_snoLabel sizeToFit];
    }
    return _snoLabel;
}

- (UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,50,20)];
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20.f];
        _nameLabel.textColor = [UIColor blackColor];
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}

@end
