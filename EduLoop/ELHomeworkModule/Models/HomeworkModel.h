//
//  HomeworkModel.h
//  EduLoop
//
//  Created by mijika on 2020/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeworkModel : NSObject
@property(nonatomic,strong,readwrite) NSString *title;
@property(nonatomic,strong,readwrite) NSString *detail;
@property(nonatomic,readwrite) BOOL submitOnline;
@property(nonatomic,readwrite) BOOL allowSubmitAfter;
@end

NS_ASSUME_NONNULL_END
