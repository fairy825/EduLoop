//
//  ELNotification.h
//  EduLoop
//
//  Created by mijika on 2021/5/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ELNotification : NSObject
+ (ELNotification *)notificationManager;

- (void)checkNotificationAuthorization;
@end

NS_ASSUME_NONNULL_END
