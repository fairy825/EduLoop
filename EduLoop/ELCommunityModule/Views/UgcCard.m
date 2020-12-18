//
//  UgcCard.m
//  EduLoop
//
//  Created by mijika on 2020/12/18.
//

#import "UgcCard.h"
#import "UIColor+EHTheme.h"
#import <Masonry/Masonry.h>

@implementation UgcCard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(UgcModel *)model{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _data = model;
        [self setupView];
        [self loadData];
//        [self addGestureRecognizer:({
//            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCell)];
//            recognizer;
//        })];
    }
    return self;
}

- (void)loadData{
    _avatarCard.nameLabel.text = _data.authorName;
    _avatarCard.publishTimeLabel.text = _data.dateStr;
    _detailLabel.text = _data.detail;
    [_commentButton setTitle:[NSString stringWithFormat:@"%ld", (long)_data.commentNum] forState:UIControlStateNormal];
    [_thumbButton setTitle:[NSString stringWithFormat:@"%ld", (long)_data.thumbNum] forState:UIControlStateNormal];
}

- (void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).mas_offset(UIEdgeInsetsMake(30, 20, 20, 20));
    }];
    
    [self.contentView addSubview:self.seperateView];
    [self.seperateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@2);
        make.left.equalTo(self.bgView);
        make.width.equalTo(self.bgView);
    }];
    
    [self.bgView addSubview:self.avatarCard];
    [self.avatarCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.height.equalTo(@60);
        make.width.equalTo(self.bgView);
    }];
    
    [self.bgView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarCard.mas_bottom).offset(20);
        make.left.equalTo(self.bgView);
        make.width.equalTo(self.bgView);
        make.height.lessThanOrEqualTo(@70);
    }];
    
    [self.bgView addSubview:self.commentButton];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    
    [self.bgView addSubview:self.thumbButton];
    [self.thumbButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView);
        make.right.equalTo(self.commentButton.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(40, 20));
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

- (UIView *)seperateView{
    if(!_seperateView){
        _seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 3)];
        _seperateView.backgroundColor = [UIColor eh_f6f6f6];
    }
    return _seperateView;
}

- (AvatarCard *)avatarCard{
    if(!_avatarCard){
        _avatarCard = [[AvatarCard alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 70)];
    }
    return _avatarCard;
}

- (UIButton *)commentButton{
    if(!_commentButton){
        _commentButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        _commentButton.backgroundColor = [UIColor clearColor];
        [_commentButton setTitleColor:[UIColor eh_999999] forState:UIControlStateNormal];
        [_commentButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC" size:20]];
        [_commentButton setImage:[UIImage imageNamed:@"icon_comment"] forState:UIControlStateNormal];
        [_commentButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    }
    return _commentButton;
}

- (UIButton *)thumbButton{
    if(!_thumbButton){
        _thumbButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        _thumbButton.backgroundColor = [UIColor clearColor];
        [_thumbButton setTitleColor:[UIColor eh_999999] forState:UIControlStateNormal];
        [_thumbButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC" size:20]];
        _thumbButton.imageView.image=[UIImage imageNamed:@"icon_thumb"];
        [_thumbButton setImage:[UIImage imageNamed:@"icon_thumb"] forState:UIControlStateNormal];
        [_thumbButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    }
    return _thumbButton;
}

- (UILabel *)detailLabel{
    if(!_detailLabel){
        _detailLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _detailLabel.font = [UIFont systemFontOfSize:18.f];
        _detailLabel.textColor = [UIColor eh_333333];
        _detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.numberOfLines = 0;
        [_detailLabel sizeToFit];
    }
    return _detailLabel;
}

@end

