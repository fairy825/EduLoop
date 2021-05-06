//
//  TeamDetailViewController.h
//  EduLoop
//
//  Created by mijika on 2021/4/25.
//

#import <UIKit/UIKit.h>
#import "StudentModel.h"
#import "TeamModel.h"
#import "ELBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface TeamDetailViewController : ELBaseViewController
@property(nonatomic,readwrite) int page;
@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) NSMutableArray<StudentModel *>* students;
@property(nonatomic,strong,readwrite) TeamModel * team;
- (instancetype)initWithTeam:(TeamModel *)team;
@end

NS_ASSUME_NONNULL_END
