//
//  MessageSummaryCardTableViewCell.h
//  EduLoop
//
//  Created by mijika on 2021/1/4.
//

#import <UIKit/UIKit.h>
#import "ChatAllModel.h"
#import "ELCustomLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MessageSummaryCardTableViewCell : UITableViewCell
@property (nonatomic, strong, readwrite) ChatAllModel *data;
@property(nonatomic,strong,readwrite) UIView *bgView;
@property(nonatomic,strong,readwrite) UIView *seperateView;
@property(nonatomic,strong,readwrite) UIImageView *avatarImage;
@property(nonatomic,strong,readwrite) UILabel *publishTimeLabel;
@property(nonatomic,strong,readwrite) UILabel *oppositeNameLabel;
@property(nonatomic,strong,readwrite) UILabel *messageLabel;
@property(nonatomic,readwrite) ELCustomLabel *unreadTag;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(ChatAllModel *)model;
- (void)loadData;
@end

NS_ASSUME_NONNULL_END
