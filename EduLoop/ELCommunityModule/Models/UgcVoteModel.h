//
//  UgcVoteModel.h
//  EduLoop
//
//  Created by mijika on 2020/12/29.
//

#import "UgcModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UgcVoteModel : UgcModel
@property(nonatomic,readwrite) BOOL hasPicked;
@property(nonatomic,readwrite) double leftPercent;
@property(nonatomic,strong,readwrite) NSString *leftChoice;
@property(nonatomic,strong,readwrite) NSString *rightChoice;
@end

NS_ASSUME_NONNULL_END
