//
//  HomeworkShowTableViewCell.h
//  EduLoop
//
//  Created by mijika on 2020/12/14.
//

#import <UIKit/UIKit.h>
#import "AvatarCard.h"
#import "TaskModel.h"
#import "TeacherTaskModel.h"
#import "ELCustomLabel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol HomeworkShowTableViewCellDelegate<NSObject>
-(void)clickOtherButtonTableViewCell:(UITableView *)tableViewCell ;
@end

@interface HomeworkShowTableViewCell : UITableViewCell
@property (nonatomic, strong, readwrite) TeacherTaskModel *data;
@property(nonatomic,strong,readwrite) AvatarCard *avatarCard;
@property(nonatomic,strong,readwrite) UIView *seperateView;
@property(nonatomic,strong,readwrite) UIView *bgView;
@property(nonatomic,strong,readwrite) UIView *hintView;
@property(nonatomic,strong,readwrite) UILabel *hintLabel;
@property(nonatomic,strong,readwrite) UIImageView *arrowImage;
@property(nonatomic,strong,readwrite) ELCustomLabel *otherButton;
@property(nonatomic,strong,readwrite) UILabel *titleLabel;
@property(nonatomic,strong,readwrite) UILabel *detailLabel;
@property(nonatomic,weak,readwrite) id<HomeworkShowTableViewCellDelegate> delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(TeacherTaskModel *)model;
- (void)loadData;
@end

NS_ASSUME_NONNULL_END
