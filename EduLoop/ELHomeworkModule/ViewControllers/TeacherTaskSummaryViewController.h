//
//  TeacherTaskSummaryViewController.h
//  EduLoop
//
//  Created by mijika on 2021/3/29.
//

#import <UIKit/UIKit.h>
#import "TeacherTaskModel.h"
#import "HomeworkModel.h"
#import "TaskDetailCard.h"
#import "ELBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface TeacherTaskSummaryViewController : ELBaseViewController
@property(nonatomic,readwrite) int page;
@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) TaskDetailCard *taskDetailCard;
@property(nonatomic,strong,readwrite) NSMutableArray<HomeworkModel *> *models;
@property(nonatomic,strong,readwrite) TeacherTaskModel *data;
- (instancetype)initWithTeacherTaskModel:(TeacherTaskModel *)data;
@end

NS_ASSUME_NONNULL_END
