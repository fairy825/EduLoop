//
//  UgcTextImgCardTableViewCell.m
//  EduLoop
//
//  Created by mijika on 2020/12/21.
//

#import "UgcTextImgCard.h"
#import "UIColor+EHTheme.h"
#import <Masonry/Masonry.h>
#import "ELImageManager.h"
#import "ELScreen.h"
@implementation UgcTextImgCard

- (void)loadData{
    self.avatarCard.nameLabel.text = self.data.authorName;
    self.avatarCard.publishTimeLabel.text = self.data.dateStr;
    self.detailLabel.text = self.data.detail;
    [_commentButton setTitle:[NSString stringWithFormat:@"%ld", (long)self.data.commentNum] forState:UIControlStateNormal];
    [_thumbButton setTitle:[NSString stringWithFormat:@"%ld", (long)self.data.thumbNum] forState:UIControlStateNormal];
    
    [_thumbButton setImage:[UIImage imageNamed:self.data.hasClickedThumb?@"icon_thumb_red":@"icon_thumb"] forState:UIControlStateNormal];
}

- (void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(30, 20, 20, 20));
    }];
    
//    [self addSubview:self.seperateView];
//    [self.seperateView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.mas_bottom);
//        make.height.equalTo(@2);
//        make.left.equalTo(self.bgView);
//        make.width.equalTo(self.bgView);
//    }];
    
//    self.bgView.backgroundColor = [UIColor yellowColor];
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
    
    [self.bgView addSubview:self.imgStackView];
    [self.imgStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(10);
    }];
    
    NSMutableArray<UIButton *>* btns = @[self.thumbButton,self.commentButton].mutableCopy;
    if(self.data.isMine&&self.hasTrash)
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
//    btnsView.backgroundColor = [UIColor redColor];
    [self.bgView addSubview:btnsView];
    [btnsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right);
        make.top.equalTo(self.imgStackView.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(totalWidth, 20));
    }];
//    [self.bgView addSubview:self.commentButton];
//    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.bgView);
//        CGFloat offset = 0;
//        if(self.data.isMine)
//            offset = -10;
//
//        make.right.equalTo(self.trashButton.mas_left).offset(offset);
//        make.size.mas_equalTo(CGSizeMake(40, 20));
//    }];
//
//    [self.bgView addSubview:self.thumbButton];
//    [self.thumbButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.bgView);
//        make.right.equalTo(self.commentButton.mas_left).offset(-10);
//        make.size.mas_equalTo(CGSizeMake(40, 20));
//    }];
    
}

- (UIStackView *)imgStackView{
    if(!_imgStackView){
        _imgStackView = [UIStackView new];
        _imgStackView.axis = UILayoutConstraintAxisHorizontal;
        _imgStackView.spacing = 15;
        _imgStackView.distribution = UIStackViewDistributionFillEqually;
        int i=0;
        for(NSString *str in self.data.imgs){
            UIImageView *photo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 100)];
            photo.image = [UIImage imageNamed:str];;
            photo.contentMode = UIViewContentModeScaleToFill;
            photo.tag=1000+i;
            //允许用户交互
            photo.userInteractionEnabled = YES;
            //添加点击手势
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(_tapPhoto:)];
            [photo addGestureRecognizer:tapGesture];
            [_imgStackView addArrangedSubview:photo];
            CGFloat imgWidth = (SCREEN_WIDTH-40-15*2)/3;
            [photo mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(imgWidth,imgWidth*4/3));
            }];
            i++;
        }
    }
    return _imgStackView;
}

- (UIButton *)commentButton{
    if(!_commentButton){
        _commentButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        _commentButton.backgroundColor = [UIColor clearColor];
        [_commentButton setTitleColor:[UIColor eh_999999] forState:UIControlStateNormal];
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

- (void)jumpToDetailPage{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(clickCommentButtonTableViewCell:)]){
        [self.delegate clickCommentButtonTableViewCell:self];
    }
}

- (void)_tapPhoto:(UITapGestureRecognizer *)tapGesture{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(clickPhoto:TableViewCell:)]){
        [self.delegate clickPhoto:[UIImage imageNamed:[self.data.imgs objectAtIndex:tapGesture.view.tag-1000]] TableViewCell:self];
    }
}

- (void)hideBtns{
    [self.trashButton setHidden:YES];
    [self.thumbButton setHidden:YES];
    [self.commentButton setHidden:YES];
}
@end
