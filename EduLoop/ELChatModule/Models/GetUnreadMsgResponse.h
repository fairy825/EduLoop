//
//  GetUnreadMsgResponse.h
//  EduLoop
//
//  Created by mijika on 2021/4/30.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "ChatMsgModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol ChatMsgModel
@end

@interface GetUnreadMsgResponse : JSONModel

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString<Optional> *msg;
@property (nonatomic, strong) NSArray<ChatMsgModel,Optional> *data;

@end

NS_ASSUME_NONNULL_END
