//
//  ChildModel.h
//  EduLoop
//
//  Created by mijika on 2020/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChildModel : NSObject
@property(nonatomic,strong,readwrite) NSString *nickname;
@property(nonatomic,strong,readwrite) NSString *school;
@property(nonatomic,strong,readwrite) NSString *sex;
@property(nonatomic,strong,readwrite) NSString *grade;
@property(nonatomic,strong,readwrite) NSString *avatarUrl;
@end

NS_ASSUME_NONNULL_END
