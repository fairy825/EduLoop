//
//  ELNotification.m
//  EduLoop
//
//  Created by mijika on 2021/5/27.
//

#import "ELNotification.h"
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>
@interface ELNotification ()<UNUserNotificationCenterDelegate>

@end

@implementation ELNotification

+ (ELNotification *)notificationManager{
    static ELNotification *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ELNotification alloc] init];
    });
    return manager;
}

- (void)checkNotificationAuthorization{
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted) {
            //本地推送
//            [self _pushLocalNotification];
            
            //远程推送
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
        }
    }];
}

-(void)_pushLocalNotification{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
    content.badge = @(1);
    content.title = @"极客时间";
    content.body = @"从0开发一款iOS App";
    content.sound = [UNNotificationSound defaultSound];
    content.subtitle = @"...";
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:3 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"_pushLocalNotification" content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        //
        NSLog(@"");
    }];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    completionHandler(UNNotificationPresentationOptionList | UNNotificationPresentationOptionBanner);
}

//点击推送后调用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    
    //处理badge展示逻辑
    //点击之后根据业务逻辑处理
    //[UIApplication sharedApplication].applicationIconBadgeNumber = 100;

    //处理业务逻辑
    completionHandler();
}
@end
