//
//  Ugc.h
//  EduLoop
//
//  Created by mijika on 2020/12/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, UgcType)
{
    UgcType_normal,
    UgcType_vote,
};
@interface UgcModel : NSObject
@property(nonatomic,readwrite) UgcType *ugcType;
@property(nonatomic,strong,readwrite) NSString *avatar;
@property(nonatomic,strong,readwrite) NSString *authorName;
@property(nonatomic,strong,readwrite) NSString *detail;
@property(nonatomic,strong,readwrite) NSString *desc;
@property(nonatomic,strong,readwrite) NSString *dateStr;
@property(nonatomic,readwrite) NSArray<NSString *> *imgs;
@property(nonatomic,readwrite) NSInteger commentNum;
@property(nonatomic,readwrite) NSInteger thumbNum;
@property(nonatomic,readwrite) BOOL hasClickedThumb;
@property(nonatomic,readwrite) BOOL isMine;
@property(nonatomic,readwrite) BOOL hasPicked;
@property(nonatomic,readwrite) double leftPercent;
@property(nonatomic,strong,readwrite) NSString *leftChoice;
@property(nonatomic,strong,readwrite) NSString *rightChoice;

@end

NS_ASSUME_NONNULL_END
