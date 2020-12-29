//
//  CommentCard.m
//  EduLoop
//
//  Created by mijika on 2020/12/24.
//

#import "CommentCard.h"
#import "UIColor+EHTheme.h"
#import <Masonry/Masonry.h>
#import "CommentEditView.h"
@implementation CommentCard
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(CommentModel *)model{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _data = model;
        [self setupView];
        [self loadData];
    }
    return self;
}

- (void)loadData{
    self.detailLabel.text = self.data.detail;
    self.publishTimeLabel.text = self.data.dateStr;
    self.nameLabel.text = self.data.authorName;
    
    UIColor *bgColor = [UIColor eh_colorWithHexRGB:self.data.chooseFirst?EHThemeColor_Red:EHThemeColor_Blue];
    self.choiceTag.backgroundColor = bgColor;
    self.choiceTag.layer.borderColor = bgColor.CGColor;
    
    [_thumbButton setTitle:[NSString stringWithFormat:@"%ld", (long)self.data.thumbNum] forState:UIControlStateNormal];
    
    [_thumbButton setImage:[UIImage imageNamed:self.data.hasClickedThumb?@"icon_thumb_red":@"icon_thumb"] forState:UIControlStateNormal];
}

- (void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).mas_offset(UIEdgeInsetsMake(20, 20, 20, 20));
    }];
    
    [self.bgView addSubview:self.avatarImage];
    [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.left.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    self.avatarImage.layer.cornerRadius = 20;
    self.avatarImage.layer.masksToBounds = YES;
    
    [self.bgView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImage);
        make.left.equalTo(self.avatarImage.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.bgView);
        make.height.equalTo(@20);
    }];
    
    [self.bgView addSubview:self.choiceTag];
    [self.choiceTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.bgView);
    }];
    
    [self.bgView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.nameLabel);
    }];
    
    [self.bgView addSubview:self.publishTimeLabel];
    [self.publishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView);
        make.left.equalTo(self.nameLabel);
    }];
    
    [self.contentView addSubview:self.seperateView];
    [self.seperateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@2);
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.bgView);
    }];
    
    UIView *btnsView = [UIView new];
    [btnsView addSubview:self.commentButton];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnsView);
        make.top.equalTo(btnsView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [btnsView addSubview:self.thumbButton];
    [self.thumbButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentButton.mas_right).offset(20);
        make.top.equalTo(btnsView);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    
    [self.bgView addSubview:btnsView];
    [btnsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
}

#pragma mark - Views
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

- (UIView *)choiceTag{
    if(!_choiceTag){
        UILabel * choiceLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, 0,50,20)];
        choiceLabel.font = [UIFont systemFontOfSize:12.f];
        choiceLabel.textColor = [UIColor whiteColor];
        choiceLabel.text = self.data.choiceStr;
        [choiceLabel sizeToFit];
        _choiceTag = [[UIView alloc]initWithFrame:CGRectMake(0, 0,70,20)];
        _choiceTag.layer.cornerRadius = 5;
        _choiceTag.layer.borderWidth = 2;
        [_choiceTag addSubview:choiceLabel];
           [choiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
               make.edges.equalTo(_choiceTag).mas_offset(UIEdgeInsetsMake(3, 3, 3, 3));
           }];
    }
    return _choiceTag;
}

- (UIImageView *)avatarImage{
    if(!_avatarImage){
        _avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        _avatarImage.image = [UIImage imageNamed:@"avatar-4"];
        _avatarImage.contentMode = UIViewContentModeScaleToFill;
    }
    return _avatarImage;
}

- (UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,50,20)];
        _nameLabel.text = [[NSString alloc] initWithFormat:@"%@%@",  @"何同学", @"妈妈"];
    
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20.f];
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}

- (UILabel *)publishTimeLabel{
    if(!_publishTimeLabel){
        _publishTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,50,20)];
        _publishTimeLabel.text = @"刚刚";
        _publishTimeLabel.font = [UIFont systemFontOfSize:14.f];
        _publishTimeLabel.textColor = [UIColor grayColor];
        [_publishTimeLabel sizeToFit];
    }
    return _publishTimeLabel;
}

- (UIButton *)commentButton{
    if(!_commentButton){
        _commentButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        _commentButton.backgroundColor = [UIColor clearColor];
        [_commentButton setBackgroundImage:[UIImage imageNamed:@"icon_comment-2"] forState:UIControlStateNormal];
        [_commentButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        [_commentButton addTarget:self action:@selector(clickCommentIcon) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
}

- (UIButton *)thumbButton{
    if(!_thumbButton){
        _thumbButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        _thumbButton.backgroundColor = [UIColor clearColor];
        [_thumbButton setTitleColor:[UIColor eh_999999] forState:UIControlStateNormal];
        [_thumbButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC" size:20]];
        [_thumbButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        [_thumbButton addTarget:self action:@selector(toggleThumb) forControlEvents:UIControlEventTouchUpInside];
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

-(void)toggleThumb{
    NSString *imgStr = @"icon_thumb";
    if(!self.data.hasClickedThumb){
        imgStr = [NSString stringWithFormat:@"%@%@",imgStr,@"_red"];
        self.data.thumbNum++;
    }else{
        self.data.thumbNum--;
    }
    self.data.hasClickedThumb = !self.data.hasClickedThumb;
    [_thumbButton setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    [_thumbButton setTitle:[NSString stringWithFormat:@"%ld", (long)self.data.thumbNum] forState:UIControlStateNormal];
}

- (void)clickCommentIcon{
    [[CommentEditView sharedManager].detailTextView becomeFirstResponder];
}
@end
