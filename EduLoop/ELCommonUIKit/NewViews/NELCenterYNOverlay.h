//
//  NELCenterYNOverlay.h
//  EduLoop
//
//  Created by bytedance on 2021/7/22.
//

#import <UIKit/UIKit.h>
#import "NELCenterOverlay.h"
#import "ELCenterOverlayModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NELCenterYNOverlay : NELCenterOverlay
@property(nonatomic,strong,readwrite) ELCenterOverlayModel *model;
- (instancetype)initWithData:(ELCenterOverlayModel *)model;
@end

NS_ASSUME_NONNULL_END
