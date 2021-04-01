//
//  ELFormat.h
//  EduLoop
//
//  Created by mijika on 2021/4/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ELFormat : NSObject
+ (BOOL)isNumber:(NSString *)strValue;
+ (NSString *)stringFromNSNumber:(NSNumber *)intValue;
+ (NSString *)stringFromNSInteger:(NSInteger)intValue;
+ (NSString *)safeString:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
