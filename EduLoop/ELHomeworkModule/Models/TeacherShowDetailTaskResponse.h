//
//  TeacherShowDetailTaskResponse.h
//  EduLoop
//
//  Created by mijika on 2021/3/29.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "TeacherTaskModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TeacherShowDetailTaskResponse : JSONModel
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString<Optional> *msg;
@property (nonatomic, strong) TeacherTaskModel  *data;
@end

NS_ASSUME_NONNULL_END
