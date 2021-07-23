//
//  MomentsModel.h
//  EduLoop
//
//  Created by mijika on 2021/5/1.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "CommentsPagedResult.h"
NS_ASSUME_NONNULL_BEGIN

@interface MomentsModel : JSONModel
@property (nonatomic, readwrite) NSInteger id;
@property (nonatomic, readwrite) NSInteger profileId;
@property(nonatomic,strong,readwrite) NSString<Optional> *avatar;
@property(nonatomic,strong,readwrite) NSString *authorNickname;
@property (nonatomic, readwrite) NSInteger commentNum;
@property (nonatomic, readwrite) NSInteger thumbNum;
@property(nonatomic,strong,readwrite) NSString<Optional> *detail;
@property(nonatomic,strong,readwrite) NSString<Optional> *publishTime;
@property(nonatomic,strong,readwrite) NSString<Optional> *timeDesc;
@property(nonatomic,readwrite)BOOL myThumb;
@property(nonatomic,strong,readwrite) NSArray<NSString<Optional> *> *imgs;
@property(nonatomic,strong,readwrite) CommentsPagedResult<Optional> *comments;

@end

NS_ASSUME_NONNULL_END
