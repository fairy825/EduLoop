//
//  BasicInfo.h
//  EduLoop
//
//  Created by mijika on 2021/3/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <PGDatePicker/PGDatePickManager.h>
#import "ELUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface BasicInfo : NSObject
@property(class) int pageSize;
@property(class) NSString *appendix;
+(NSString *)url:(NSString *)str;
+ (NSString *)url:(NSString *)str path:(NSString *)path;
+(NSString *)url:(NSString *)str Start:(int)start AndSize:(int)size;
+(NSString *)urlwithDefaultStartAndSize:(NSString *)str;
+(void)POST:(NSString *)URLString parameters:(nullable id)parameters success:(nullable void (^)())success failure:(nullable void (^)())failure;
+(void)POST:(NSString *)URLString parameters:(nullable id)parameters success:(nullable void (^)())success;
+(void)PUT:(NSString *)URLString parameters:(nullable id)parameters success:(nullable void (^)())success;
+(void)DELETE:(NSString *)URLString success:(nullable void (^)())success;
+(void)showToastWithMsg:(NSString *)str;
+(PGDatePickManager *)sharedManager;
+(UITabBarController *)initNavigationTab;
+(void)markUser;
+(void)deleteUser;
@end

NS_ASSUME_NONNULL_END
