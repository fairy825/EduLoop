//
//  CommentsPagedResult.h
//  EduLoop
//
//  Created by mijika on 2021/5/1.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "CommentModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol CommentModel

@end
@interface CommentsPagedResult : JSONModel
@property (nonatomic, assign) NSInteger page;// 当前页码 从1开始
@property (nonatomic, assign) NSInteger number;//弃用
@property (nonatomic, assign) NSInteger total;// 总页数
@property (nonatomic, assign) NSInteger records;// 总记录数
@property (nonatomic, strong) NSArray<CommentModel> *rows;// 每行显示的内容
@property (nonatomic, assign) BOOL first;
@property (nonatomic, assign) BOOL last;
@property (nonatomic, assign) BOOL hasPrevious;
@end

NS_ASSUME_NONNULL_END
