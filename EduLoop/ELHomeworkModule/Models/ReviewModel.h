//
//  ReviewModel.h
//  EduLoop
//
//  Created by mijika on 2021/3/30.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReviewModel : JSONModel

@property(nonatomic,readwrite) NSInteger id;
@property(nonatomic,strong,readwrite) NSString<Optional> *detail;
@property(nonatomic,readwrite) NSInteger homeworkId;
@property(nonatomic,readwrite) NSInteger score;
@property(nonatomic,readwrite) NSInteger teacherId;
@property(nonatomic,strong,readwrite) NSString<Optional> *teacherNickname;

@end

NS_ASSUME_NONNULL_END
