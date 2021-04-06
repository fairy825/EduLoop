//
//  ParentScanAllTaskResponse.h
//  EduLoop
//
//  Created by mijika on 2021/4/3.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "ParentPagedResult.h"
NS_ASSUME_NONNULL_BEGIN

@interface ParentScanAllTaskResponse : JSONModel
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString<Optional> *msg;
@property (nonatomic, strong) ParentPagedResult  *data;

@end

NS_ASSUME_NONNULL_END
