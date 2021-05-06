//
//  PublishCommentResponse.h
//  EduLoop
//
//  Created by mijika on 2021/5/2.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "CommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PublishCommentResponse : JSONModel
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString<Optional> *msg;
@property (nonatomic, strong) CommentModel *data;
@end

NS_ASSUME_NONNULL_END
