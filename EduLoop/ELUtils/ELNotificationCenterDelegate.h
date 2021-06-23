//
//  ELNotificationCenterDelegate.h
//  EduLoop
//
//  Created by mijika on 2021/6/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ELNotificationCenterDelegate : UIViewController
+ (void)registerToCurrentNotificationCenterDelegate;
+ (instancetype)sharedDelegate;
@end

NS_ASSUME_NONNULL_END
