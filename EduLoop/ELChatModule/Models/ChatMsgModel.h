//
//  ChatMsgModel.h
//  EduLoop
//
//  Created by mijika on 2021/4/30.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface ChatMsgModel : JSONModel
@property (nonatomic,readwrite)NSInteger id;
@property (nonatomic,readwrite)NSInteger sendUserId;
@property (nonatomic,readwrite)NSInteger acceptUserId;
@property (nonatomic,readwrite)NSInteger signFlag;
@property (nonatomic, strong,readwrite)NSString<Optional> *msg;
@property (nonatomic, strong,readwrite)NSString<Optional> *createTime;
@end

NS_ASSUME_NONNULL_END
