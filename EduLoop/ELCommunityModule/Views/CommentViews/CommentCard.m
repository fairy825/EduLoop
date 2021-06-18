//
//  CommentCard.m
//  EduLoop
//
//  Created by mijika on 2020/12/24.
//

#import "CommentCard.h"
#import "UIColor+ELColor.h"
#import <Masonry/Masonry.h>
#import "CommentEditView.h"
#import <SDWebImage.h>
#import "ChatBoard.h"
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
    NSString *str = self.data.content;
    if(self.data.commenteeId!=0)
        str = [NSString stringWithFormat:@"%@%@%@%@",@"回复 @",self.data.commenteeNickname,@" : ",str];
    self.detailLabel.text = str;
    self.publishTimeLabel.text = self.data.timeDesc;
    self.nameLabel.text = self.data.authorNickame;
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:self.data.avatar] placeholderImage:[UIImage imageNamed:@"avatar-4"]];
   
    [_thumbButton setTitle:[NSString stringWithFormat:@"%ld", (long)self.data.thumbNum] forState:UIControlStateNormal];
    [_thumbButton setImage:[UIImage imageNamed:self.data.myThumb?@"icon_thumb_red":@"icon_thumb"] forState:UIControlStateNormal];
    [_commentButton setTitle:[NSString stringWithFormat:@"%ld", (long)self.data.commentNum] forState:UIControlStateNormal];
}

- (void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *recog = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCard)];
    [self addGestureRecognizer:recog];
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
    
//    [self.bgView addSubview:self.choiceTag];
//    [self.choiceTag mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.nameLabel);
//        make.left.equalTo(self.nameLabel.mas_right).offset(10);
//        make.right.lessThanOrEqualTo(self.bgView);
//    }];
    
    [self.bgView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.bgView);
    }];
    
    [self.bgView addSubview:self.publishTimeLabel];
    [self.publishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom).offset(20);
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
    int i=0;
    UIButton *preBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [btnsView addSubview:preBtn];
    [preBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnsView);
        make.top.equalTo(btnsView);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    CGFloat totalWidth = 0;
    NSArray<UIButton *>*btns = @[self.thumbButton,self.commentButton];
    for(UIButton *btn in btns){
        CGFloat width = 40;
        totalWidth+=width+10;
        [btnsView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(preBtn.mas_right).offset(10);
            make.top.equalTo(btnsView);
            make.size.mas_equalTo(CGSizeMake(width, 20));
        }];
        preBtn = btn;
        i++;
    }
    [self.bgView addSubview:btnsView];
    [btnsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right);
        make.bottom.equalTo(self.publishTimeLabel);
        make.size.mas_equalTo(CGSizeMake(totalWidth, 20));
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
        _seperateView.backgroundColor = [UIColor elBackgroundColor];
    }
    return _seperateView;
}

//- (UIView *)choiceTag{
//    if(!_choiceTag){
//        UILabel * choiceLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, 0,50,20)];
//        choiceLabel.font = [UIFont systemFontOfSize:12.f];
//        choiceLabel.textColor = [UIColor whiteColor];
//        choiceLabel.text = self.data.choiceStr;
//        [choiceLabel sizeToFit];
//        _choiceTag = [[UIView alloc]initWithFrame:CGRectMake(0, 0,70,20)];
//        _choiceTag.layer.cornerRadius = 5;
//        _choiceTag.layer.borderWidth = 2;
//        [_choiceTag addSubview:choiceLabel];
//           [choiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//               make.edges.equalTo(_choiceTag).mas_offset(UIEdgeInsetsMake(3, 3, 3, 3));
//           }];
//    }
//    return _choiceTag;
//}

- (UIImageView *)avatarImage{
    if(!_avatarImage){
        _avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
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

- (UIButton *)commentButton{
    if(!_commentButton){
        _commentButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        _commentButton.backgroundColor = [UIColor clearColor];
        [_commentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_commentButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC" size:20]];
        [_commentButton setImage:[UIImage imageNamed:@"icon_comment-2"] forState:UIControlStateNormal];
        [_commentButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    }
    return _commentButton;
}

- (UIButton *)thumbButton{
    if(!_thumbButton){
        _thumbButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        _thumbButton.backgroundColor = [UIColor clearColor];
        [_thumbButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_thumbButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC" size:20]];
        [_thumbButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        [_thumbButton addTarget:self action:@selector(clickThumb) forControlEvents:UIControlEventTouchUpInside];
    }
    return _thumbButton;
}

- (UILabel *)detailLabel{
    if(!_detailLabel){
        _detailLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _detailLabel.font = [UIFont systemFontOfSize:18.f];
        _detailLabel.textColor = [UIColor blackColor];
        _detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.numberOfLines = 0;
        [_detailLabel sizeToFit];
    }
    return _detailLabel;
}

- (void)clickThumb{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(clickThumbCommentCard:)]){
        [self.delegate clickThumbCommentCard:self];
    }
}

-(void)toggleThumb{
    NSString *imgStr = @"icon_thumb";
    if(!self.data.myThumb){
        imgStr = [NSString stringWithFormat:@"%@%@",imgStr,@"_red"];
        self.data.thumbNum++;
    }else{
        self.data.thumbNum--;
    }
    self.data.myThumb = !self.data.myThumb;
    [_thumbButton setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    [_thumbButton setTitle:[NSString stringWithFormat:@"%ld", (long)self.data.thumbNum] forState:UIControlStateNormal];
}

- (void)clickCard{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(clickCommentCard:)]){
        [self.delegate clickCommentCard:self ];
    }
}
@end
