//
//  BroadcastViewController.h
//  EduLoop
//
//  Created by mijika on 2020/12/9.
//

#import <UIKit/UIKit.h>
#import "SettingDataTableViewCell.h"
#import "TaskModel.h"
#import <PGDatePicker.h>
NS_ASSUME_NONNULL_BEGIN

@interface BroadcastViewController : UIViewController

@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) NSMutableArray<SettingDataModel*>* models;
@property(nonatomic,strong,readwrite) TaskModel *task;
@property(nonatomic,strong,readwrite) NSDate *endDate;
@property(nonatomic,readwrite) BOOL editMode;
- (instancetype)initWithHomeworkData:(TaskModel *)data;
@end

NS_ASSUME_NONNULL_END
