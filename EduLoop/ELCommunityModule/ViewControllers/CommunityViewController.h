//
//  CommunityViewController.h
//  EduLoop
//
//  Created by mijika on 2020/12/18.
//

#import <UIKit/UIKit.h>
#import "UgcModel.h"
#import "ELFloatingButton.h"
#import "ELTabViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommunityViewController : ELTabViewController

@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) NSMutableArray<UgcModel *>* models;
@property(nonatomic,strong,readwrite) ELFloatingButton *addBtn;
@end

NS_ASSUME_NONNULL_END
