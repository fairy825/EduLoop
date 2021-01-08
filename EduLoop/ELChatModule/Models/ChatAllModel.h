//
//  ChatAllModel.h
//  EduLoop
//
//  Created by mijika on 2021/1/4.
//

#import <Foundation/Foundation.h>
#import "ContactPersonModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatAllModel : NSObject

@property(nonatomic,strong,readwrite) ContactPersonModel *personModel;
@property(nonatomic,strong,readwrite) NSString *messageStr;
@property(nonatomic,strong,readwrite) NSString *dateStr;
@property(nonatomic,readwrite) int unreadNum;
@end

NS_ASSUME_NONNULL_END
