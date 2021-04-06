//
//  GetMyStudentsResponse.h
//  EduLoop
//
//  Created by mijika on 2021/4/4.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

NS_ASSUME_NONNULL_BEGIN
@protocol StudentModel

@end

@interface GetMyStudentsResponse : JSONModel
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString<Optional> *msg;
@property (nonatomic, strong) NSArray<StudentModel,Optional> *data;
@end

NS_ASSUME_NONNULL_END
