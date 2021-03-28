//
//  GetAllMyTeamResponse.h
//  EduLoop
//
//  Created by mijika on 2021/3/24.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
NS_ASSUME_NONNULL_BEGIN
@protocol TeamModel

@end
@interface GetAllMyTeamResponse : JSONModel
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString<Optional> *msg;
@property (nonatomic, strong) NSArray<TeamModel>  *data;
@end

NS_ASSUME_NONNULL_END
