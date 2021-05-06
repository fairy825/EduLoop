//
//  GetMomentsResponse.h
//  EduLoop
//
//  Created by mijika on 2021/5/1.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "MomentsPagedResult.h"
NS_ASSUME_NONNULL_BEGIN

@interface GetMomentsResponse : JSONModel
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString<Optional> *msg;
@property (nonatomic, strong) MomentsPagedResult *data;

@end

NS_ASSUME_NONNULL_END
