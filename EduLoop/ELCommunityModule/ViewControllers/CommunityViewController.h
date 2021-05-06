//
//  CommunityViewController.h
//  EduLoop
//
//  Created by mijika on 2020/12/18.
//

#import <UIKit/UIKit.h>
#import "MomentsModel.h"
#import "ELFloatingButton.h"
#import "ELBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommunityViewController : ELBaseViewController
@property(nonatomic,readwrite) BOOL isMine;
@property(nonatomic,readwrite) int page;
@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) UIView *defaultView;
@property(nonatomic,strong,readwrite) NSMutableArray<MomentsModel *>* models;
@property(nonatomic,strong,readwrite) ELFloatingButton *addBtn;
- (instancetype)initWithMode:(BOOL)isMine;
@end

NS_ASSUME_NONNULL_END
