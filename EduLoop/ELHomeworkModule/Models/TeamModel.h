//
//  TeamModel.h
//  EduLoop
//
//  Created by mijika on 2021/3/24.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface TeamModel : JSONModel
@property(nonatomic,readwrite) NSInteger id;
@property(nonatomic,strong,readwrite) NSString<Optional> *name;
@property(nonatomic,strong,readwrite) NSString<Optional> *code;
@property(nonatomic,readwrite) NSInteger creatorId;
@end

NS_ASSUME_NONNULL_END
