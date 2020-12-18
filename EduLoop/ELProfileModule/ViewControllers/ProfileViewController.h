//
//  ProfileViewController.h
//  EduLoop
//
//  Created by mijika on 2020/12/8.
//

#import <UIKit/UIKit.h>
#import "SettingDataTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
@property(nonatomic,strong,readwrite) UITableView *profileTableView;
@property(nonatomic,strong,readwrite) UIButton *saveBtn;
@property(nonatomic,strong,readwrite) NSMutableArray<SettingDataModel*>* models;
@end

NS_ASSUME_NONNULL_END
