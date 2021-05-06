//
//  GetContactsResponse.h
//  EduLoop
//
//  Created by mijika on 2021/4/27.
//

#import <JSONModel.h>
#import "ContactsPagedResult.h"
NS_ASSUME_NONNULL_BEGIN
//@protocol ProfileModel
//
//@end
@interface GetContactsResponse : JSONModel

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString<Optional> *msg;
@property (nonatomic, strong) NSArray<ProfileModel,Optional> *data;
@end

NS_ASSUME_NONNULL_END
