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
NS_ASSUME_NONNULL_BEGIN

@interface ChatDetailViewController : UIViewController
@property(nonatomic,strong,readwrite) NSMutableArray<MessageModel *>* models;
@property(nonatomic,strong,readwrite) ContactPersonModel * personModel;
@property(nonatomic,strong,readwrite) ChatBoard *chatBoard;

- (instancetype)initWithModel:(ContactPersonModel *)personModel;

@end

NS_ASSUME_NONNULL_END
