//
//  ELCenterOverlayModel.h
//  EduLoop
//
//  Created by mijika on 2020/12/15.
//

#import <Foundation/Foundation.h>
#import "ELOverlayItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface ELCenterOverlayModel : NSObject

@property(nonatomic,strong,readwrite) NSString *title;
@property(nonatomic,strong,readwrite) NSString *subTitle;
@property(nonatomic,strong,readwrite) ELOverlayItem *leftChoice;

@end

NS_ASSUME_NONNULL_END
