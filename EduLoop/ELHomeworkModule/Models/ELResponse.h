//
//  ELResponse.h
//  EduLoop
//
//  Created by mijika on 2021/3/21.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "PagedResult.h"
NS_ASSUME_NONNULL_BEGIN

@interface ELResponse : JSONModel
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString<Optional> *msg;
@property (nonatomic, strong) PagedResult  *data;
@end

NS_ASSUME_NONNULL_END
