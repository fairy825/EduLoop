//
//  UgcTextImgCardTableViewCell.m
//  EduLoop
//
//  Created by mijika on 2020/12/21.
//

#import "UgcTextImgCard.h"
#import "UIColor+MyTheme.h"
#import <Masonry/Masonry.h>
#import "ELImageManager.h"
#import "ELScreen.h"
#import "ELUserInfo.h"
#import <SDWebImage.h>
#import "ELPublishImage.h"
@implementation UgcTextImgCard

- (void)loadData{
    [self.avatarCard.avatarImage sd_setImageWithURL:[NSURL URLWithString:self.data.avatar] placeholderImage:[UIImage imageNamed: @"avatar-4"]]; 
    self.avatarCard.nameLabel.text = self.data.authorNickname;
    self.avatarCard.publishTimeLabel.text = self.data.timeDesc;
    self.detailLabel.text = self.data.detail;
//    self.photoGroup.urlArray = self.data.imgs;
    int i=0;
    CGFloat imgWidth = (SCREEN_WIDTH-40-15*2)/3;

    for(UIView *view in [self.imgStackView arrangedSubviews]){
//        [self.imgStackView removeArrangedSubview:view];
        [view removeFromSuperview];
    }
    for(NSString *str in self.data.imgs){
        UIImageView *photo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        [photo sd_setImageWithURL:[NSURL URLWithString:str]];
        photo.contentMode = UIViewContentModeScaleAspectFill;
        photo.clipsToBounds = YES;
        photo.tag=1000+i;
        //允许用户交互
        photo.userInteractionEnabled = YES;
        //添加点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(_tapPhoto:)];
        [photo addGestureRecognizer:tapGesture];
        [self.imgStackView addArrangedSubview:photo];
        [photo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(imgWidth,imgWidth));
        }];
        i++;
    }
    if(self.data.imgs.count>0){
        while(i<3){
            [self.imgStackView addArrangedSubview:[ELPublishImage emptyItem:CGRectMake(0, 0, imgWidth, imgWidth)]];
            i++;
        }
    }
    [self.commentButton setTitle:[NSString stringWithFormat:@"%ld", (long)self.data.commentNum] forState:UIControlStateNormal];
    [self.thumbButton setTitle:[NSString stringWithFormat:@"%ld", (long)self.data.thumbNum] forState:UIControlStateNormal];
    
    [self.thumbButton setImage:[UIImage imageNamed:self.data.myThumb?@"icon_thumb_red":@"icon_thumb"] forState:UIControlStateNormal];
}

- (void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(30, 20, 20, 20));
    }];
    
    [self addSubview:self.seperateView];
    [self.seperateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
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
        make.right.equalTo(self.bgView);
        make.width.equalTo(self.bgView);
//        make.height.lessThanOrEqualTo(@70);//todo
    }];

    [self.bgView addSubview:self.imgStackView];
    CGFloat imgWidth = (SCREEN_WIDTH-40-15*2)/3;
    CGFloat height = 0;
    CGFloat offset=0;
    if(self.data.imgs.count!=0){
        offset = 10;
        self.imgStackView.alpha=1;
        height = imgWidth;
    }else{
        self.imgStackView.alpha=0;
        height=0;
    }
    [self.imgStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(offset);
        make.height.mas_equalTo(height);
    }];
    NSMutableArray<UIButton *>* btns = @[self.thumbButton,self.commentButton].mutableCopy;
    if(self.data.profileId==[ELUserInfo sharedUser].id&&self.hasTrash)
       [btns addObject:self.trashButton];
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
    for(UIButton *btn in btns){
        CGFloat width = 40;
        if(i==2) width = 20;
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
    self.btnsView = btnsView;
    [self.bgView addSubview:btnsView];
    [btnsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right);
        make.top.equalTo(self.imgStackView.mas_bottom).offset(30);
        make.bottom.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(totalWidth, 20));
    }];
}

//- (HZPhotoGroup *)groupView{
//    if (!_groupView) {
//        _groupView = [[HZPhotoGroup alloc] init];
//    }
//    return _groupView;
//}

- (UIStackView *)imgStackView{
    if(!_imgStackView){
        _imgStackView = [UIStackView new];
        _imgStackView.axis = UILayoutConstraintAxisHorizontal;
        _imgStackView.spacing = 15;
        _imgStackView.distribution = UIStackViewDistributionFillEqually;
    }
    return _imgStackView;
}

- (UIButton *)commentButton{
    if(!_commentButton){
        _commentButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        _commentButton.backgroundColor = [UIColor clearColor];
        [_commentButton setTitleColor:[UIColor color999999] forState:UIControlStateNormal];
        [_commentButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC" size:20]];
        [_commentButton setImage:[UIImage imageNamed:@"icon_comment-2"] forState:UIControlStateNormal];
        [_commentButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        [_commentButton addTarget:self action:@selector(jumpToDetailPage) forControlEvents:UIControlEventTouchUpInside];

    }
    return _commentButton;
}


- (UIButton *)thumbButton{
    if(!_thumbButton){
        _thumbButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        _thumbButton.backgroundColor = [UIColor clearColor];
        [_thumbButton setTitleColor:[UIColor color999999] forState:UIControlStateNormal];
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
        _detailLabel.textColor = [UIColor color333333];
        _detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.numberOfLines = 3;
        [_detailLabel sizeToFit];
    }
    return _detailLabel;
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

- (void)clickThumb{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(clickThumbButtonTableViewCell:ugcTextImgCard:)]){
        [self.delegate clickThumbButtonTableViewCell:self.superview.superview ugcTextImgCard:self];
    }
}

- (void)jumpToDetailPage{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(clickCommentButtonTableViewCell:)]){
        [self.delegate clickCommentButtonTableViewCell:self.superview.superview];
    }
}

- (void)_tapPhoto:(UITapGestureRecognizer *)tapGesture{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(clickPhoto:TableViewCell:)]){
        
        [self.delegate clickPhoto: [self.data.imgs objectAtIndex:tapGesture.view.tag-1000] TableViewCell:self.superview.superview];
    }

}

@end
