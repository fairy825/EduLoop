//
//  GetOneHomeworkResponse.h
//  EduLoop
//
//  Created by mijika on 2021/4/1.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "HomeworkModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GetOneHomeworkResponse : JSONModel
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString<Optional> *msg;
@property (nonatomic, strong) HomeworkModel *data;

@end

NS_ASSUME_NONNULL_END
