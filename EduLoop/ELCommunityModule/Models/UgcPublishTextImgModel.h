//
//  UgcPublishTextImgModel.h
//  EduLoop
//
//  Created by mijika on 2020/12/30.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UgcPublishTextImgModel : NSObject
@property(nonatomic,strong,readwrite) NSString *detail;
@property(nonatomic,strong,readwrite) NSMutableArray<UIImage *> *imgs;

@end

NS_ASSUME_NONNULL_END
