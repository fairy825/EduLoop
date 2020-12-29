//
//  UgcCard.m
//  EduLoop
//
//  Created by mijika on 2020/12/18.
//

#import "UgcCard.h"
#import "UIColor+EHTheme.h"
#import <Masonry/Masonry.h>
#import "ELCenterOverlay.h"
#import "UgcVoteModel.h"
@implementation UgcCard

- (instancetype)initWithFrame:(CGRect)frame Data:(UgcModel *)model
{
    self = [super init];
    if (self) {
        _data = model;
        [self setupView];
        [self loadData];
    }
    return self;
}

- (void)reload{
    [self loadData];
    [self setupView];
}
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(UgcModel *)model{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if(self){
//        _data = model;
//        [self setupView];
//        [self loadData];
////        [self addGestureRecognizer:({
////            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCell)];
////            recognizer;
////        })];
//    }
//    return self;
//}

- (void)loadData{
//    _avatarCard.nameLabel.text = _data.authorName;
//    _avatarCard.publishTimeLabel.text = _data.dateStr;
//    _detailLabel.text = _data.detail;
//    [_commentButton setTitle:[NSString stringWithFormat:@"%ld", (long)_data.commentNum] forState:UIControlStateNormal];
//    [_thumbButton setTitle:[NSString stringWithFormat:@"%ld", (long)_data.thumbNum] forState:UIControlStateNormal];
//
//    [_thumbButton setImage:[UIImage imageNamed:_data.hasClickedThumb?@"icon_thumb_red":@"icon_thumb"] forState:UIControlStateNormal];
}

- (void)setupView{
//    self.backgroundColor = [UIColor whiteColor];
//    
//    [self.contentView addSubview:self.bgView];
//    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView).mas_offset(UIEdgeInsetsMake(30, 20, 20, 20));
//    }];
//    
//    [self.contentView addSubview:self.seperateView];
//    [self.seperateView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.contentView.mas_bottom);
//        make.height.equalTo(@2);
//        make.left.equalTo(self.bgView);
//        make.width.equalTo(self.bgView);
//    }];
//    
//    [self.bgView addSubview:self.avatarCard];
//    [self.avatarCard mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.bgView);
//        make.height.equalTo(@60);
//        make.width.equalTo(self.bgView);
//    }];
//    
//    [self.bgView addSubview:self.detailLabel];
//    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.avatarCard.mas_bottom).offset(20);
//        make.left.equalTo(self.bgView);
//        make.width.equalTo(self.bgView);
//        make.height.lessThanOrEqualTo(@70);
//    }];
//    
//    [self.bgView addSubview:self.trashButton];
//    [self.trashButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.bgView);
//        make.right.equalTo(self.bgView);
//        if(_data.isMine)
//            make.size.mas_equalTo(CGSizeMake(20, 20));
//        else
//            make.size.mas_equalTo(CGSizeMake(0, 0));
//    }];
//    
//    [self.bgView addSubview:self.commentButton];
//    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.bgView);
//        CGFloat offset = 0;
//        if(_data.isMine)
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

- (UIButton *)trashButton{
    if(!_trashButton){
        _trashButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        _trashButton.backgroundColor = [UIColor clearColor];
        [_trashButton setBackgroundImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
        [_trashButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        [_trashButton addTarget:self action:@selector(pushDeleteAlertView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _trashButton;
}

- (void)pushDeleteAlertView{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(clickTrashButtonTableViewCell:)]){
        [self.delegate clickTrashButtonTableViewCell:self];
    }
}


@end

