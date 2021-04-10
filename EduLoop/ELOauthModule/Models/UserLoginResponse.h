//
//  UserLoginResponse.h
//  EduLoop
//
//  Created by mijika on 2021/4/10.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "ProfileModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserLoginResponse : JSONModel
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString<Optional> *msg;
@property (nonatomic, strong) ProfileModel *data;

@end

NS_ASSUME_NONNULL_END
