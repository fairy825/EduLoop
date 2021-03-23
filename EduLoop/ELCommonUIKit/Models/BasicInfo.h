//
//  BasicInfo.h
//  EduLoop
//
//  Created by mijika on 2021/3/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <PGDatePicker/PGDatePickManager.h>
NS_ASSUME_NONNULL_BEGIN

@interface BasicInfo : NSObject
@property(class) int pageSize;
@property(class) NSString *appendix;
+(NSString *)url:(NSString *)str;
+ (NSString *)url:(NSString *)str path:(NSString *)path;
+(NSString *)url:(NSString *)str Start:(int)start AndSize:(int)size;
+(NSString *)urlwithDefaultStartAndSize:(NSString *)str;
+(void)showToastWithMsg:(NSString *)str;
+(PGDatePickManager *)sharedManager;

@end

NS_ASSUME_NONNULL_END
