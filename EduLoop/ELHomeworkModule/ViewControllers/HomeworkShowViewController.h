//
//  HomeworkShowViewController.h
//  EduLoop
//
//  Created by mijika on 2020/12/14.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"
#import "TeacherTaskModel.h"
#import "ELFloatingButton.h"
#import "ProfileSummaryCard.h"
#import <LMJDropdownMenu.h>
#import "StudentModel.h"
#import "ELBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeworkShowViewController : ELBaseViewController
@property(nonatomic,readwrite) BOOL isParent;
@property(nonatomic,readwrite) int page;
@property(nonatomic,readwrite) NSInteger selectedStuIndex;
@property(nonatomic,strong,readwrite) LMJDropdownMenu *menu;
@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) NSMutableArray* models;
@property(nonatomic,strong,readwrite) NSMutableArray<StudentModel *>* students;
@property(nonatomic,strong,readwrite) NSMutableArray<UIImage *>* studentAvatars;
@property(nonatomic,strong,readwrite) ELFloatingButton *addBtn;
- (void)jumpToDetailPageWithData:(TaskModel *)model;
@end

NS_ASSUME_NONNULL_END
