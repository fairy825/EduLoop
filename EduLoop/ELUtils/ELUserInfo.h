//
//  ELUserInfo.h
//  EduLoop
//
//  Created by mijika on 2021/4/3.
//

#import <Foundation/Foundation.h>
#import "ProfileModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ELUserInfo : NSObject
+(ProfileModel *)sharedUser;
+(void)setUserInfo:(ProfileModel *)info;
+(void)dealloc;
@end

NS_ASSUME_NONNULL_END
