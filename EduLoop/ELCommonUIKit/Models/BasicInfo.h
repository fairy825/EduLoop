//
//  BasicInfo.h
//  EduLoop
//
//  Created by mijika on 2021/3/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface BasicInfo : NSObject
@property(class) int pageSize;
@property(class) NSString *appendix;
+(NSString *)url:(NSString *)str Start:(int)start AndSize:(int)size;
+(NSString *)urlwithDefaultStartAndSize:(NSString *)str;
+(void)showToastWithMsg:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
