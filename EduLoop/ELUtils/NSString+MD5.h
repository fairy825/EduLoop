//
//  NSString+MD5.h
//  EduLoop
//
//  Created by mijika on 2021/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString(MD5)
- (NSString *)md5_32bit;
+ (NSString *)md5_32bitWithStr:(NSString *)str Salt:(NSString *)salt;
@end

NS_ASSUME_NONNULL_END
