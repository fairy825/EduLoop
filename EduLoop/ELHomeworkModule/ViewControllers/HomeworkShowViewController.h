//
//  HomeworkShowViewController.h
//  EduLoop
//
//  Created by mijika on 2020/12/14.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"
#import "ELFloatingButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeworkShowViewController : UIViewController
@property(nonatomic,readwrite) int page;
@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) NSMutableArray<TaskModel *>* models;
@property(nonatomic,strong,readwrite) ELFloatingButton *addBtn;
- (void)jumpToDetailPageWithData:(TaskModel *)model;
@end

NS_ASSUME_NONNULL_END
