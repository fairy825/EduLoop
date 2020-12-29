//
//  UgcVoteCard.m
//  EduLoop
//
//  Created by mijika on 2020/12/18.
//

#import "UgcVoteCard.h"
#import <Masonry/Masonry.h>
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
    
    [self.bgView addSubview:self.voteView];
    [self.voteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarCard.mas_bottom).offset(20);
        make.left.equalTo(self.bgView);
        make.width.equalTo(self.bgView);
        make.height.equalTo(@100);
    }];
    
    if(self.data.isMine&&self.hasTrash){
    [self.bgView addSubview:self.trashButton];
    [self.trashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
//        else
//            make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    }
}
- (void)hideBtns{
    [self.trashButton setHidden:YES];
}
@end
