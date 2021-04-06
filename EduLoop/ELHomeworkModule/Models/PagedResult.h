//
//  PagedResult.h
//  EduLoop
//
//  Created by mijika on 2021/3/21.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TeacherTaskModel

@end
@interface PagedResult : JSONModel
@property (nonatomic, assign) NSInteger page;// 当前页码 从1开始
@property (nonatomic, assign) NSInteger number;//弃用
@property (nonatomic, assign) NSInteger total;// 总页数
@property (nonatomic, assign) NSInteger records;// 总记录数
@property (nonatomic, strong) NSArray<TeacherTaskModel> *rows;// 每行显示的内容
@property (nonatomic, assign) BOOL first;
@property (nonatomic, assign) BOOL last;
@property (nonatomic, assign) BOOL hasPrevious;
@end

NS_ASSUME_NONNULL_END
