//
//  ELNetworkSessionManager.m
//  EduLoop
//
//  Created by mijika on 2021/4/19.
//

#import "ELNetworkSessionManager.h"

@implementation ELNetworkSessionManager
static AFHTTPSessionManager *manager;

/* 封装成 单例会话管理者 */
+ (AFHTTPSessionManager *)sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 初始化请求管理类
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        // 设置15秒超时 - 取消请求
        manager.requestSerializer.timeoutInterval = 15.0;
        // 编码
        manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        // 缓存策略
        manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        // 支持内容格式
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    });
    return manager;
}
@end
