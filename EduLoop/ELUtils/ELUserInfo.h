//
//  ELUserInfo.h
//  EduLoop
//
//  Created by mijika on 2021/4/3.
//

#import <Foundation/Foundation.h>
#import "ProfileModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ELUserInfo : NSObject
@property(nonatomic,readwrite) NSInteger id;
@property(nonatomic,readwrite) NSInteger userId;
@property (nonatomic, assign) NSString *phone;
@property(nonatomic,strong,readwrite) NSString *name;
@property(nonatomic,strong,readwrite) NSString *nickname;
@property(nonatomic,readwrite) BOOL identity;//true=parent
@property (nonatomic, assign) NSString<Optional> *faceImage;
@property (nonatomic, assign) NSString<Optional> *faceImageBig;
@property (nonatomic, assign) NSString<Optional> *latestLoginTime;
+(ELUserInfo *)sharedUser;
+(void)setUserInfo:(ProfileModel *)info;
+(void)dealloc;
@end

NS_ASSUME_NONNULL_END
