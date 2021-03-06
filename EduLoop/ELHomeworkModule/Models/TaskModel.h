//
//  HomeworkModel.h
//  EduLoop
//
//  Created by mijika on 2020/12/14.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "HomeworkModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TaskModel : JSONModel
@property(nonatomic,readwrite) NSInteger id;
@property(nonatomic,strong,readwrite) NSString<Optional> *title;
@property(nonatomic,strong,readwrite) NSString<Optional> *content;
@property(nonatomic,readwrite) NSInteger creatorId;
@property(nonatomic,strong,readwrite) NSString<Optional> *creatorName;
@property(nonatomic,strong,readwrite) NSString<Optional> *creatorAvatar;

@property(nonatomic,strong,readwrite) NSString *publishTime;
@property(nonatomic,strong,readwrite) NSString *endTime;
@property(nonatomic,strong,readwrite) NSString *timeDesc;
@property(nonatomic,strong,readwrite) HomeworkModel<Optional> *homeworkVO;

@property(nonatomic,readwrite) NSString *finish;
@property(nonatomic,readwrite) BOOL delayAllowed;
@end

NS_ASSUME_NONNULL_END
