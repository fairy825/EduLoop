//
//  ELNetworkSessionManager.h
//  EduLoop
//
//  Created by mijika on 2021/4/19.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
NS_ASSUME_NONNULL_BEGIN

@interface ELNetworkSessionManager : AFHTTPSessionManager
+ (AFHTTPSessionManager *)sharedManager;
@end

NS_ASSUME_NONNULL_END
