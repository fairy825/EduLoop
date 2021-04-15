//
//  ELUserInfo.m
//  EduLoop
//
//  Created by mijika on 2021/4/3.
//

#import "ELUserInfo.h"

@implementation ELUserInfo

static dispatch_once_t token;
static ELUserInfo *instance;
+(ELUserInfo *)sharedUser{
    dispatch_once(&token, ^{
        if(instance==nil)
            instance = [[ELUserInfo alloc]init];
    });
    return instance;
}

+(void)setUserInfo:(ProfileModel *)info{
    ELUserInfo *userInfo = [ELUserInfo sharedUser];
    userInfo.id = info.id;
    userInfo.identity = info.identity;
    userInfo.userId = info.userId;
    userInfo.name = info.name;
    userInfo.nickname = info.nickname;
    userInfo.phone = info.phone;
    userInfo.faceImage = info.faceImage;
    userInfo.faceImageBig = info.faceImageBig;
    userInfo.latestLoginTime = info.latestLoginTime;
}

+(void)dealloc{
    token = 0; // 只有置成0,GCD才会认为它从未执行过.它默认为0.这样才能保证下次再次调用shareInstance的时候,再次创建对象.
//    [_instance release];
    instance = nil;
 }
@end
