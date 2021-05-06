//
//  GetMyTPTeamsResponse.h
//  EduLoop
//
//  Created by mijika on 2021/5/1.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "TeamModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol TeamModel

@end
@interface GetMyTPTeamsResponse : JSONModel
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString<Optional> *msg;
@property (nonatomic, strong) NSArray<TeamModel> *data;
@end

NS_ASSUME_NONNULL_END
