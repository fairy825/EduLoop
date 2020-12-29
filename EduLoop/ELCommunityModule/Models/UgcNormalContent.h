//
//  UgcNormalContent.h
//  EduLoop
//
//  Created by mijika on 2020/12/18.
//

#import <Foundation/Foundation.h>
#import "UgcModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UgcNormalContent : UgcModel

//@property(nonatomic,readwrite) NSArray<UIImage *> *imgs;
@property(nonatomic,readwrite) NSInteger thumbNum;
@property(nonatomic,readwrite) BOOL hasClickedThumb;
@end

NS_ASSUME_NONNULL_END
