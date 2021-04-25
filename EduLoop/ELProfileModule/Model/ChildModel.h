//
//  ChildModel.h
//  EduLoop
//
//  Created by mijika on 2020/12/9.
//

#import <Foundation/Foundation.h>
#import "StudentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChildModel : NSObject
@property(nonatomic,readwrite) NSInteger id;
@property(nonatomic,readwrite) NSInteger teamId;
@property(nonatomic,strong,readwrite) NSString *nickname;
@property(nonatomic,strong,readwrite) NSString *sno;
@property(nonatomic,strong,readwrite) NSString *team;
@property(nonatomic,strong,readwrite) NSString *relationship;
@property(nonatomic,strong,readwrite) NSString *sex;
@property(nonatomic,strong,readwrite) NSString *grade;
@property(nonatomic,strong,readwrite) NSString *avatarUrl;
@property(nonatomic,strong,readwrite) NSString *qrcode;

@end

NS_ASSUME_NONNULL_END
