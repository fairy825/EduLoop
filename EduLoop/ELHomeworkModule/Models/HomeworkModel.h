//
//  HomeworkModel.h
//  EduLoop
//
//  Created by mijika on 2021/3/29.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "ReviewModel.h"
#import "StudentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeworkModel : JSONModel

@property(nonatomic,readwrite) NSInteger id;
@property(nonatomic,strong,readwrite) NSString<Optional> *detail;
@property(nonatomic,readwrite) NSInteger taskId;
@property(nonatomic,readwrite) NSInteger authorId;
@property(nonatomic,strong,readwrite) NSString<Optional> *authorName;
@property(nonatomic,strong,readwrite) StudentModel<Optional> *student;
@property(nonatomic,strong,readwrite) NSString *publishTime;
@property(nonatomic,readwrite) BOOL hasViewed;
@property(nonatomic,readwrite) BOOL delay;
@property(nonatomic,readwrite) ReviewModel<Optional> *reviewVO;
@property(nonatomic,strong,readwrite) NSArray<NSString<Optional> *> *imgs;

@end

NS_ASSUME_NONNULL_END
