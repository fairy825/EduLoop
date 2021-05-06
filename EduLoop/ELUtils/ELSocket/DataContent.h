//
//  DataContent.h
//  EduLoop
//
//  Created by mijika on 2021/4/29.
//

#import <Foundation/Foundation.h>
#import "ChatMsg.h"
#import <JSONModel.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, ELScoketDataAction) {
    UNKNOWN   = 0,
    CONNECT   = 1,
    CHAT      = 2,
    SIGNED    = 3,
    KEEPALIVE = 4,
    PULLFRIEND = 5,
    LOGOUT    = 6,
};


@interface DataContent : JSONModel
@property (nonatomic,readwrite)ELScoketDataAction action;
@property (nonatomic, strong,readwrite)ChatMsg<Optional> *chatMsg;
@property (nonatomic, strong,readwrite)NSString<Optional> *extand;

@end

NS_ASSUME_NONNULL_END
