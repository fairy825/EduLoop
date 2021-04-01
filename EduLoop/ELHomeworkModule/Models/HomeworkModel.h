//
//  HomeworkModel.h
//  EduLoop
//
//  Created by mijika on 2021/3/29.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "ReviewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeworkModel : JSONModel

@property(nonatomic,readwrite) NSInteger id;
@property(nonatomic,strong,readwrite) NSString<Optional> *detail;
@property(nonatomic,readwrite) NSInteger taskId;
@property(nonatomic,readwrite) NSInteger authorId;
@property(nonatomic,strong,readwrite) NSString<Optional> *authorName;
@property(nonatomic,readwrite) NSInteger studentId;
@property(nonatomic,strong,readwrite) NSString<Optional> *studentName;
@property(nonatomic,strong,readwrite) NSString *publishTime;
@property(nonatomic,readwrite) BOOL hasViewed;
@property(nonatomic,readwrite) BOOL delay;
@property(nonatomic,readwrite) ReviewModel<Optional> *reviewVO;

@end

NS_ASSUME_NONNULL_END
