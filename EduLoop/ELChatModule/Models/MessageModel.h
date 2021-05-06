//
//  MessageModel.h
//  EduLoop
//
//  Created by mijika on 2021/1/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageModel : NSObject

@property(nonatomic,readwrite) NSInteger fromId;
@property(nonatomic,readwrite) NSInteger toId;
@property(nonatomic,strong,readwrite) NSString *avatar;
@property(nonatomic,strong,readwrite) NSString *messageStr;
@property(nonatomic,strong,readwrite) NSString *dateStr;
@property(nonatomic,readwrite) BOOL isRead;
@end

NS_ASSUME_NONNULL_END
