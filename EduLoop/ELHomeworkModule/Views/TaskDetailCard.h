//
//  TaskDetailCard.h
//  EduLoop
//
//  Created by mijika on 2021/3/30.
//

#import <UIKit/UIKit.h>
#import "TeacherTaskModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TaskDetailCard : UIView
@property (nonatomic, strong, readwrite) TeacherTaskModel *data;
@property(nonatomic,strong,readwrite) UIView *seperateLine;
@property(nonatomic,strong,readwrite) UIView *bgView;
@property(nonatomic,strong,readwrite) UIImageView *avatarImage;
@property(nonatomic,strong,readwrite) UILabel *teacherLabel;
@property(nonatomic,strong,readwrite) UILabel *detailLabel;
@property(nonatomic,strong,readwrite) UILabel *timeLabel;
@property(nonatomic,strong,readwrite) UIImageView *arrowImage;
@property(nonatomic,strong,readwrite) UILabel *titleLabel;
- (void)loadData:(TeacherTaskModel *)data;
@end

NS_ASSUME_NONNULL_END
