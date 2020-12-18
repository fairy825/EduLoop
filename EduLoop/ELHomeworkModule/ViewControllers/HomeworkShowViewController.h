//
//  HomeworkShowViewController.h
//  EduLoop
//
//  Created by mijika on 2020/12/14.
//

#import <UIKit/UIKit.h>
#import "HomeworkModel.h"
#import "ELFloatingButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeworkShowViewController : UIViewController

@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) NSMutableArray<HomeworkModel *>* models;
@property(nonatomic,strong,readwrite) ELFloatingButton *addBtn;
- (void)jumpToDetailPageWithData:(HomeworkModel *)model;
@end

NS_ASSUME_NONNULL_END
