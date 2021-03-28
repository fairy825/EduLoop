//
//  BroadcastViewController.h
//  EduLoop
//
//  Created by mijika on 2020/12/9.
//

#import <UIKit/UIKit.h>
#import "SettingDataTableViewCell.h"
#import "TaskModel.h"
#import "TeamModel.h"
#import <PGDatePicker.h>
#import "ELBottomSelectOverlay.h"
NS_ASSUME_NONNULL_BEGIN

@interface BroadcastViewController : UIViewController

@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) ELBottomSelectOverlay *overlay;
@property(nonatomic,strong,readwrite) NSMutableArray<SettingDataModel*>* models;
@property(nonatomic,strong,readwrite) NSMutableArray<TeamModel*>* teams;
@property(nonatomic,strong,readwrite) NSMutableArray<NSNumber *>* chosedTeamIndexs;

@property(nonatomic,strong,readwrite) TaskModel *task;
@property(nonatomic,strong,readwrite) NSDate *endDate;
@property(nonatomic,readwrite) BOOL editMode;
- (instancetype)initWithHomeworkData:(TaskModel *)data;
@end

NS_ASSUME_NONNULL_END
