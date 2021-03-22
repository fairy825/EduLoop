//
//  UgcVoteCard.m
//  EduLoop
//
//  Created by mijika on 2020/12/18.
//

#import "UgcVoteCard.h"
#import <Masonry/Masonry.h>
#import "UIColor+EHTheme.h"
@implementation UgcVoteCard
- (ELVoteCard *)voteView{
    if(!_voteView){
        _voteView = [[ELVoteCard alloc]initWithFrame:self.bounds Data:self.data];
    }
    return _voteView;
}

- (void)loadData{
    self.avatarCard.nameLabel.text = self.data.authorName;
    self.avatarCard.publishTimeLabel.text = self.data.dateStr;
    self.descriptionLabel.text = self.data.desc;
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

    [self.bgView addSubview:self.descriptionLabel];
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarCard.mas_bottom).offset(10);
        make.left.equalTo(self.bgView);
        make.width.equalTo(self.bgView);
    }];
    
    [self.bgView addSubview:self.voteView];
    [self.voteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom).offset(20);
        make.left.equalTo(self.bgView);
        make.width.equalTo(self.bgView);
        make.height.equalTo(@120);
    }];
    
    
    UIView *btnsView = [UIView new];
    if(self.data.isMine&&self.hasTrash){
        [btnsView addSubview:self.trashButton];
        [self.trashButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btnsView);
            make.top.equalTo(btnsView);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    
    self.btnsView = btnsView;
    [self.bgView addSubview:btnsView];
    [btnsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.voteView.mas_bottom).offset(30);
        make.right.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
}

- (UILabel *)descriptionLabel{
    if(!_descriptionLabel){
        _descriptionLabel = [[UILabel alloc]init];
        _descriptionLabel.font = [UIFont fontWithName:@"PingFangSC" size:18];
        _descriptionLabel.textColor = [UIColor color999999];
        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
        _descriptionLabel.numberOfLines = 0;
        [_descriptionLabel sizeToFit];
    }
    return _descriptionLabel;

}
@end
