//
//  GetOneTeamResponse.h
//  EduLoop
//
//  Created by mijika on 2021/4/25.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "TeamModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GetOneTeamResponse : JSONModel
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString<Optional> *msg;
@property (nonatomic, strong) TeamModel  *data;
@end

NS_ASSUME_NONNULL_END
