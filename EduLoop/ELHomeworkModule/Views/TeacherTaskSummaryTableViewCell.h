//
//  TeacherTaskSummaryTableViewCell.h
//  EduLoop
//
//  Created by mijika on 2021/3/29.
//

#import <UIKit/UIKit.h>
#import "HomeworkModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TeacherTaskSummaryTableViewCell : UITableViewCell
@property (nonatomic, strong, readwrite) HomeworkModel *data;
@property(nonatomic,strong,readwrite) UIView *bgView;
@property(nonatomic,strong,readwrite) UIImageView *avatarImage;
@property(nonatomic,strong,readwrite) UIImageView *arrowImage;
@property(nonatomic,strong,readwrite) UILabel *hintLabel;
@property(nonatomic,strong,readwrite) UILabel *studentLabel;
@property(nonatomic,strong,readwrite) UILabel *parentLabel;
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(CommentModel *)model;
- (void)loadData;
@end

NS_ASSUME_NONNULL_END
