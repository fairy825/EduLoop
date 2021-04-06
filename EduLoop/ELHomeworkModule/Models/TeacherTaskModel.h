//
//  TeacherTaskModel.h
//  EduLoop
//
//  Created by mijika on 2021/3/29.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "HomeworkModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol HomeworkModel

@end

@interface TeacherTaskModel : JSONModel
@property(nonatomic,readwrite) NSInteger id;
@property(nonatomic,strong,readwrite) NSString<Optional> *title;
@property(nonatomic,strong,readwrite) NSString<Optional> *content;
@property(nonatomic,readwrite) NSInteger creatorId;
@property(nonatomic,strong,readwrite) NSString<Optional> *creatorName;

@property(nonatomic,strong,readwrite) NSString *publishTime;
@property(nonatomic,strong,readwrite) NSString *endTime;
@property(nonatomic,strong,readwrite) NSString *timeDesc;

@property(nonatomic,readwrite) NSInteger realHomeworkNumber;
@property(nonatomic,readwrite) NSInteger shouldHomeworkNumber;
@property(nonatomic,readwrite) BOOL delayAllowed;
@property (nonatomic, strong) NSArray<HomeworkModel,Optional> *homeworkLists;
@property(nonatomic,readwrite) NSInteger totalPages;


@end

NS_ASSUME_NONNULL_END
