//
//  ChatDetailViewController.h
//  EduLoop
//
//  Created by mijika on 2021/1/4.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
#import "ContactPersonModel.h"
#import "ChatBoard.h"
#import "ChatMsg.h"
#import "ELBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatDetailViewController : ELBaseViewController
@property(nonatomic,strong,readwrite) NSMutableArray<MessageModel *>* models;
@property(nonatomic,strong,readwrite) NSMutableArray<NSDate *>* timeTitles;
@property(nonatomic,strong,readwrite) NSMutableArray<NSMutableArray<MessageModel *>*>* messages;
@property(nonatomic,strong,readwrite) ContactPersonModel * personModel;
@property(nonatomic,strong,readwrite) ChatBoard *chatBoard;
@property(nonatomic,strong,readwrite) UITableView *tableView;

- (instancetype)initWithModel:(ContactPersonModel *)personModel;
- (void)receiveMsg:(ChatMsg *)chatMsg;
@end

NS_ASSUME_NONNULL_END
