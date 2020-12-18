//
//  HomeworkShowTableViewCell.h
//  EduLoop
//
//  Created by mijika on 2020/12/14.
//

#import <UIKit/UIKit.h>
#import "AvatarCard.h"
#import "HomeworkModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol HomeworkShowTableViewCellDelegate<NSObject>
-(void)clickOtherButtonTableViewCell:(UITableView *)tableViewCell ;
@end

@interface HomeworkShowTableViewCell : UITableViewCell
@property (nonatomic, strong, readwrite) HomeworkModel *data;
@property(nonatomic,strong,readwrite) AvatarCard *avatarCard;
@property(nonatomic,strong,readwrite) UIView *seperateView;
@property(nonatomic,strong,readwrite) UIView *bgView;
@property(nonatomic,strong,readwrite) UIButton *otherButton;
@property(nonatomic,strong,readwrite) UILabel *titleLabel;
@property(nonatomic,strong,readwrite) UILabel *detailLabel;
@property(nonatomic,weak,readwrite) id<HomeworkShowTableViewCellDelegate> delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(HomeworkModel *)model;
@end

NS_ASSUME_NONNULL_END
