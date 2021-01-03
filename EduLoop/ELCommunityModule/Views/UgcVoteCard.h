//
//  UgcVoteCard.h
//  EduLoop
//
//  Created by mijika on 2020/12/18.
//

#import <UIKit/UIKit.h>
#import "UgcCard.h"
#import "ELVoteCard.h"
NS_ASSUME_NONNULL_BEGIN

@interface UgcVoteCard : UgcCard
@property(nonatomic,strong,readwrite) ELVoteCard *voteView;
@property(nonatomic,strong,readwrite) UILabel *descriptionLabel;
@end

NS_ASSUME_NONNULL_END
