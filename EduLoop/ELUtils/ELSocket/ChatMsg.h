//
//  ChatMsg.h
//  EduLoop
//
//  Created by mijika on 2021/4/29.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface ChatMsg : JSONModel
@property (nonatomic,readwrite)NSInteger senderId;
@property (nonatomic,readwrite)NSInteger receiverId;
@property (nonatomic, strong,readwrite)NSString<Optional> *msg;
@property (nonatomic,readwrite)NSInteger msgId;
@property (nonatomic, strong,readwrite)NSString<Optional> *createTime;

@end

NS_ASSUME_NONNULL_END
