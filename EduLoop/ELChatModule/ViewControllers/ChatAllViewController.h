//
//  ChatAllViewController.h
//  EduLoop
//
//  Created by mijika on 2021/1/4.
//

#import <UIKit/UIKit.h>
#import "ChatAllModel.h"
#import "ChatMsgModel.h"
#import "ELBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatAllViewController : ELBaseViewController

@property(nonatomic,strong,readwrite) UIView *defaultView;
@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) NSMutableArray<ChatAllModel *>* models;
@end

NS_ASSUME_NONNULL_END
