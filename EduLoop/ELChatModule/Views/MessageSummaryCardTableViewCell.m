//
//  MessageSummaryCardTableViewCell.m
//  EduLoop
//
//  Created by mijika on 2021/1/4.
//

#import "MessageSummaryCardTableViewCell.h"
#import "UIColor+MyTheme.h"
#import <Masonry/Masonry.h>
#import <SDWebImage.h>
@implementation MessageSummaryCardTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(ChatAllModel *)model
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
    self.oppositeNameLabel.text = self.data.personModel.nickname;
    self.publishTimeLabel.text = [self.data.dateStr substringToIndex:self.data.dateStr.length-3];
    self.messageLabel.text = self.data.messageStr;
    self.unreadTag.text = self.data.unreadNum>0?[NSString stringWithFormat:@"%ld", (long)self.data.unreadNum]:@"";
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:self.data.personModel.avatar] placeholderImage:[UIImage imageNamed:@"avatar"]];
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
    
    [self.bgView addSubview:self.unreadTag];
    [self.unreadTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImage);
        make.right.equalTo(self.avatarImage).offset(5);
        make.width.greaterThanOrEqualTo(@20);
    }];
    
    [self.bgView addSubview:self.oppositeNameLabel];
    [self.oppositeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImage);
        make.left.equalTo(self.avatarImage.mas_right).offset(10);
    }];
    
    [self.bgView addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.avatarImage);
        make.left.equalTo(self.oppositeNameLabel);
        make.right.equalTo(self.bgView);
    }];
    
    [self.bgView addSubview:self.publishTimeLabel];
    [self.publishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImage);
        make.right.equalTo(self.bgView);
//        make.width.equalTo(self.bgView);
//        make.height.equalTo(@100);
    }];
    
    [self.contentView addSubview:self.seperateView];
    [self.seperateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@2);
        make.left.equalTo(self.oppositeNameLabel);
        make.right.equalTo(self.bgView);
    }];
    
}

#pragma mark - View
- (UIImageView *)avatarImage{
    if(!_avatarImage){
        _avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _avatarImage.contentMode = UIViewContentModeScaleToFill;
//        _avatarImage.layer.cornerRadius = 25;
//        _avatarImage.layer.masksToBounds = YES;
        
    }
    return _avatarImage;
}

- (UILabel *)oppositeNameLabel{
    if(!_oppositeNameLabel){
        _oppositeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,50,20)];
    
        _oppositeNameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.f];
        _oppositeNameLabel.numberOfLines = 1;
        _oppositeNameLabel.lineBreakMode = NSLayoutAttributeTrailing;
        _oppositeNameLabel.textAlignment = NSTextAlignmentLeft;
        [_oppositeNameLabel sizeToFit];
    }
    return _oppositeNameLabel;
}

- (UILabel *)publishTimeLabel{
    if(!_publishTimeLabel){
        _publishTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,50,20)];
        _publishTimeLabel.font = [UIFont systemFontOfSize:14.f];
        _publishTimeLabel.textColor = [UIColor grayColor];
        _publishTimeLabel.numberOfLines = 1;
        _publishTimeLabel.lineBreakMode = NSLayoutAttributeTrailing;
        _publishTimeLabel.textAlignment = NSTextAlignmentRight;  [_publishTimeLabel sizeToFit];
    }
    return _publishTimeLabel;
}

- (UILabel *)messageLabel{
    if(!_messageLabel){
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,50,20)];
        _messageLabel.font = [UIFont systemFontOfSize:16.f];
        _messageLabel.textColor = [UIColor color999999];
        _messageLabel.numberOfLines = 1;
        _messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _messageLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _messageLabel;
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

- (ELCustomLabel *)unreadTag{
    if(!_unreadTag){
        _unreadTag = [[ELCustomLabel alloc]init];
        _unreadTag.font = [UIFont systemFontOfSize:14.f];
        _unreadTag.textColor = [UIColor whiteColor];
        _unreadTag.backgroundColor = [UIColor redColor];
        _unreadTag.layer.cornerRadius = 10;
        _unreadTag.layer.masksToBounds = YES;
        _unreadTag.layer.borderWidth = 2;
        _unreadTag.layer.borderColor = [UIColor whiteColor].CGColor;
        _unreadTag.textAlignment = NSTextAlignmentCenter;
        [_unreadTag setTextInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
        [_unreadTag sizeToFit];

    }
    return _unreadTag;
}

@end
