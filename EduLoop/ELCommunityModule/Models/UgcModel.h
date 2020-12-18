//
//  Ugc.h
//  EduLoop
//
//  Created by mijika on 2020/12/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UgcModel : NSObject
@property(nonatomic,strong,readwrite) NSString *authorName;
@property(nonatomic,strong,readwrite) NSString *detail;
@property(nonatomic,strong,readwrite) NSString *dateStr;
//@property(nonatomic,readwrite) NSArray<UIImage *> *imgs;
@property(nonatomic,readwrite) NSInteger commentNum;
@property(nonatomic,readwrite) NSInteger thumbNum;
@end

NS_ASSUME_NONNULL_END
