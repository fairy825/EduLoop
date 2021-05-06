//
//  ChatHistory.h
//  EduLoop
//
//  Created by mijika on 2021/4/29.
//

#import <Foundation/Foundation.h>
#import "ChatMsg.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatHistory : NSObject
@property (nonatomic,readwrite)NSNumber * myId;
@property (nonatomic,readwrite)NSNumber * friendId;
@property (nonatomic, strong,readwrite)ChatMsg *chatMsg;
@property (nonatomic,strong,readwrite)NSNumber *flag;//YES=me to friend

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)appInfoWithDict:(NSDictionary *)dict;
+ (NSArray *)appinfoArrayWithArray:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
