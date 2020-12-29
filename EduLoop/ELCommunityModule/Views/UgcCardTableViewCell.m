//
//  UgcCardTableViewCell.m
//  EduLoop
//
//  Created by mijika on 2020/12/24.
//

#import "UgcCardTableViewCell.h"
#import "UgcVoteCard.h"
#import "UgcTextImgCard.h"
#import <Masonry/Masonry.h>

@implementation UgcCardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(UgcModel *)model{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        if(model.ugcType ==UgcType_vote)
            self.ugcCard = [[UgcVoteCard alloc]initWithFrame:self.bounds Data:model];
        else
            self.ugcCard = [[UgcTextImgCard alloc]initWithFrame:self.bounds Data:model];
        self.ugcCard.hasTrash = YES;
        [self.ugcCard reload];
        [self.contentView addSubview:self.ugcCard];
        [self.ugcCard mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
    }
    return self;
}


@end
