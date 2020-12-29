//
//  ELVoteCard.h
//  EduLoop
//
//  Created by mijika on 2020/12/18.
//

#import <UIKit/UIKit.h>
#import "UgcVoteModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ELVoteCard : UIView
@property(nonatomic,strong,readwrite) UIView *bgView;
@property(nonatomic,strong,readwrite) UILabel *titleLabel;
@property(nonatomic,strong,readwrite) UIButton *leftButton;
@property(nonatomic,strong,readwrite) UIButton *rightButton;
@property(nonatomic,strong,readwrite) UILabel *leftLabel;
@property(nonatomic,strong,readwrite) UILabel *rightLabel;
@property(nonatomic,strong,readwrite) UIView *leftProgress;
@property(nonatomic,strong,readwrite) UIView *rightProgress;
@property(nonatomic,readwrite) UgcModel *model;
- (instancetype)initWithFrame:(CGRect)frame Data:(UgcModel *)model;
@end

NS_ASSUME_NONNULL_END
