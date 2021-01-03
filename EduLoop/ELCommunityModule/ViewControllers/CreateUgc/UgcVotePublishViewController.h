//
//  UgcVotePublishViewController.h
//  EduLoop
//
//  Created by mijika on 2021/1/3.
//

#import <UIKit/UIKit.h>
#import "SettingDataTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface UgcVotePublishViewController : UIViewController

@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) NSMutableArray<SettingDataModel*>* models;
@end

NS_ASSUME_NONNULL_END
