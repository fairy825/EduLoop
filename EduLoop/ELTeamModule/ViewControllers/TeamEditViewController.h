//
//  TeamEditViewController.h
//  EduLoop
//
//  Created by mijika on 2021/4/24.
//

#import <UIKit/UIKit.h>
#import "TeamModel.h"
#import "SettingDataTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface TeamEditViewController : UIViewController

@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) NSMutableArray<SettingDataModel*>* models;
@property(nonatomic,strong,readwrite) TeamModel *team;
@property(nonatomic,readwrite) BOOL editMode;
- (instancetype)initWithData:(TeamModel *)team;

@end

NS_ASSUME_NONNULL_END
