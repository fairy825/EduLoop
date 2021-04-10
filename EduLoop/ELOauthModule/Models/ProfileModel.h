//
//  ProfileModel.h
//  EduLoop
//
//  Created by mijika on 2021/4/10.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileModel : JSONModel
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSString<Optional> *name;
@property (nonatomic, assign) NSString<Optional> *phone;
@property (nonatomic, assign) NSString<Optional> *nickname;
@property (nonatomic, assign) NSString<Optional> *faceImage;
@property (nonatomic, assign) NSString<Optional> *faceImageBig;
@property (nonatomic, assign) BOOL identity;//true=parent
@property (nonatomic, assign) NSString<Optional> *latestLoginTime;
@end

NS_ASSUME_NONNULL_END
