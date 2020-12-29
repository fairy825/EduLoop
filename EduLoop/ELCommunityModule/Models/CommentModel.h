//
//  CommentModel.h
//  EduLoop
//
//  Created by mijika on 2020/12/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentModel : NSObject
@property(nonatomic,strong,readwrite) NSString *authorName;
@property(nonatomic,strong,readwrite) NSString *detail;
@property(nonatomic,strong,readwrite) NSString *dateStr;
@property(nonatomic,strong,readwrite) NSString *choiceStr;
@property(nonatomic,readwrite) NSInteger thumbNum;
@property(nonatomic,readwrite) BOOL hasClickedThumb;
@property(nonatomic,readwrite) BOOL chooseFirst;
@end

NS_ASSUME_NONNULL_END
