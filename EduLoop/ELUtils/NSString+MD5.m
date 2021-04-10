//
//  NSString+MD5.m
//  EduLoop
//
//  Created by mijika on 2021/4/10.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(MD5)

- (NSString *)md5_32bit {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)self.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

+ (NSString *)md5_32bitWithStr:(NSString *)str Salt:(NSString *)salt{
    NSString *string = [NSString stringWithFormat:@"%@%@%@%@%@",
                        [salt substringWithRange:NSMakeRange(0, 1)],
                        [salt substringWithRange:NSMakeRange(2, 1)],
                        str,
                        [salt substringWithRange:NSMakeRange(5, 1)],
                        [salt substringWithRange:NSMakeRange(4, 1)] ];
    return [string md5_32bit];

}
@end
