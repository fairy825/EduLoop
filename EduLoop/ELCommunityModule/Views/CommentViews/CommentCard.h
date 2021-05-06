//
//  CommentCard.h
//  EduLoop
//
//  Created by mijika on 2020/12/24.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol CommentCardDelegate;
@interface CommentCard : UITableViewCell

@property (nonatomic, strong, readwrite) CommentModel *data;
@property(nonatomic,strong,readwrite) UIView *bgView;
@property(nonatomic,strong,readwrite) UIImageView *avatarImage;
@property(nonatomic,strong,readwrite) UILabel *publishTimeLabel;
@property(nonatomic,strong,readwrite) UILabel *nameLabel;
@property(nonatomic,strong,readwrite) UIView *choiceTag;
@property(nonatomic,strong,readwrite) UILabel *detailLabel;
@property(nonatomic,strong,readwrite) UIButton *thumbButton;
@property(nonatomic,strong,readwrite) UIButton *commentButton;
@property(nonatomic,strong,readwrite) UIView *seperateView;
@property(nonatomic,weak,readwrite) id<CommentCardDelegate> delegate;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(CommentModel *)model;
- (void)loadData;
-(void)toggleThumb;
@end

@protocol CommentCardDelegate <NSObject>
-(void)clickThumbCommentCard:(CommentCard *)card;
-(void)clickCommentCard:(CommentCard *)card;

@end
NS_ASSUME_NONNULL_END
