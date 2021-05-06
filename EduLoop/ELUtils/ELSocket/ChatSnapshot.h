//
//  ChatSnapshot.h
//  EduLoop
//
//  Created by mijika on 2021/4/29.
//

#import <Foundation/Foundation.h>
#import "ChatMsg.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatSnapshot : NSObject

@property (nonatomic,readwrite)NSNumber * myId;
@property (nonatomic,readwrite)NSNumber * friendId;
@property (nonatomic, strong,readwrite)ChatMsg *chatMsg;
@property (nonatomic,strong,readwrite)NSNumber *isRead;
@property (nonatomic,strong,readwrite)NSNumber *unreadNum;
//@property (nonatomic, strong,readwrite)NSString *createTime;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)appInfoWithDict:(NSDictionary *)dict;
+ (NSArray *)appinfoArrayWithArray:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
