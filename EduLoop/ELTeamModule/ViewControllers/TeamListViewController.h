//
//  TeamListViewController.h
//  EduLoop
//
//  Created by mijika on 2021/4/24.
//

#import <UIKit/UIKit.h>
#import "TeamModel.h"
#import "ELFloatingButton.h"
#import "ELBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface TeamListViewController : ELBaseViewController
@property(nonatomic,readwrite) int page;
@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) NSMutableArray<TeamModel *>* teams;
@property(nonatomic,strong,readwrite) ELFloatingButton *addBtn;
//- (void)jumpToDetailPageWithData:(TaskModel *)model;
@end

NS_ASSUME_NONNULL_END
