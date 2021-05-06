//
//  CommentModel.h
//  EduLoop
//
//  Created by mijika on 2020/12/24.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface CommentModel : JSONModel
@property(nonatomic,readwrite) NSInteger id;
@property(nonatomic,readwrite) NSInteger profileId;
@property(nonatomic,strong,readwrite) NSString<Optional> *authorNickame;
@property(nonatomic,strong,readwrite) NSString<Optional> *avatar;
@property(nonatomic,strong,readwrite) NSString<Optional> *content;
@property(nonatomic,strong,readwrite) NSString<Optional> *publishTime;
@property(nonatomic,strong,readwrite) NSString<Optional> *timeDesc;
@property(nonatomic,readwrite) NSInteger commenteeId;
@property(nonatomic,strong,readwrite) NSString<Optional> *commenteeNickname;
@property(nonatomic,readwrite) NSInteger momentsId;
@property(nonatomic,readwrite) NSInteger thumbNum;
@property(nonatomic,readwrite) NSInteger commentNum;
@property(nonatomic,readwrite) BOOL myThumb;
//@property(nonatomic,readwrite) BOOL chooseFirst;
@end

NS_ASSUME_NONNULL_END
