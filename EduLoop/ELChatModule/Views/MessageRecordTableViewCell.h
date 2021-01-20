//
//  MessageRecordTableViewCell.h
//  EduLoop
//
//  Created by mijika on 2021/1/13.
//

#import <UIKit/UIKit.h>
#import "MessageBubble.h"
#import "MessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MessageRecordTableViewCell : UITableViewCell

@property(nonatomic,strong,readwrite) MessageModel *messageModel;
@property(nonatomic,strong,readwrite) MessageBubble *bubble;
@property(nonatomic,strong,readwrite) UIImageView *avatarImage;
@property(nonatomic,readwrite) BOOL isFrom;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)rect data:(MessageModel *)model;
- (void)loadData;
- (void)setMessageModel:(MessageModel *)model;
@end

NS_ASSUME_NONNULL_END
