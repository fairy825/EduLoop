//
//  HomeworkShowTableViewCell.m
//  EduLoop
//
//  Created by mijika on 2020/12/14.
//

#import "HomeworkShowTableViewCell.h"
#import "UIColor+EHTheme.h"
#import <Masonry/Masonry.h>
#import "ELOverlay.h"

@implementation HomeworkShowTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(HomeworkModel *)model{
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
    _titleLabel.text = _data.title;
    _detailLabel.text = _data.detail;
}

- (void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.seperateView];
    [self.seperateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.height.equalTo(@10);
        make.width.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).mas_offset(UIEdgeInsetsMake(30, 20, 20, 20));
    }];
    
    [self.bgView addSubview:self.avatarCard];
    [self.avatarCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.height.equalTo(@60);
        make.width.equalTo(self.bgView);
    }];
    
    [self.bgView addSubview:self.otherButton];
    [self.otherButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
    }];
    
    [self.bgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarCard.mas_bottom).offset(10);
        make.left.equalTo(self.avatarCard);
    }];
    
    [self.bgView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.titleLabel);
        make.width.equalTo(self.bgView);
        make.height.lessThanOrEqualTo(@70);
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
        _seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 10)];
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

- (UIButton *)otherButton{
    if(!_otherButton){
        _otherButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        _otherButton.backgroundColor = [UIColor clearColor];
        [_otherButton setTitle:@"..." forState:UIControlStateNormal];
        [_otherButton setTitleColor:[UIColor eh_999999] forState:UIControlStateNormal];
        [_otherButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Bold" size:20]];
        [_otherButton addTarget:self action:@selector(clickHomeworkMenu) forControlEvents:UIControlEventTouchUpInside];
    }
    return _otherButton;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,100,20)];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.f];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel{
    if(!_detailLabel){
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,100,20)];
        _detailLabel.font = [UIFont systemFontOfSize:16.f];
        _detailLabel.textColor = [UIColor grayColor];
        _detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.numberOfLines = 0;
        [_detailLabel sizeToFit];
    }
    return _detailLabel;
}

-(void)clickHomeworkMenu{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(clickOtherButtonTableViewCell:)]){
        [self.delegate clickOtherButtonTableViewCell:self];
    }
}
@end
