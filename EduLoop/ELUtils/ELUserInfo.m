//
//  ELUserInfo.m
//  EduLoop
//
//  Created by mijika on 2021/4/3.
//

#import "ELUserInfo.h"

@implementation ELUserInfo
+(ProfileModel *)sharedUser{
    static dispatch_once_t token;
    static ProfileModel *instance;
    dispatch_once(&token, ^{
        if(instance==nil)
            instance = [[ProfileModel alloc]init];
    });
    return instance;
}

+(void)setUserInfo:(ProfileModel *)info{
    ProfileModel *instance = [ELUserInfo sharedUser];
    instance.id = (info).id;
    instance.userId = (info).userId;
    instance.name = (info).name;
    instance.nickname = (info).nickname;
    instance.phone = (info).phone;
    instance.faceImage = (info).faceImage;
    instance.identity = (info).identity;
    instance.latestLoginTime = (info).latestLoginTime;
    instance.faceImageBig = (info).faceImageBig;
}

+(void)dealloc{
//    token = 0; // 只有置成0,GCD才会认为它从未执行过.它默认为0.这样才能保证下次再次调用shareInstance的时候,再次创建对象.
////    [_instance release];
//    _instance = nil;
 }
@end
