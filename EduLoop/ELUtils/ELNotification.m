//
//  ELNotification.m
//  EduLoop
//
//  Created by mijika on 2021/5/27.
//

#import "ELNotification.h"
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>
#import "ELNotificationCenterDelegate.h"
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
    [ELNotificationCenterDelegate registerToCurrentNotificationCenterDelegate];
    [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted) {
            //本地推送
//            [self _registerActionNotification];
//            [self _pushLocalNotification];
            
            //远程推送
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
        }
    }];
}

- (void)_registerActionNotification {
    UNNotificationAction *okAction = [UNNotificationAction actionWithIdentifier:@"com.el.notification.ok"
                                                                          title:@"知道了，马上来"
                                                                        options:UNNotificationActionOptionNone];
    UNNotificationAction *waitAction = [UNNotificationAction actionWithIdentifier:@"com.el.notification.wait"
                                                                            title:@"别着急，等我一下"
                                                                          options:UNNotificationActionOptionDestructive];
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"com.el.notification.category"
                                                                              actions:@[okAction, waitAction]
                                                                    intentIdentifiers:@[]
                                                                              options:UNNotificationCategoryOptionCustomDismissAction];
    // Because your app must handle all actions, you must declare the actions that your app supports at launch time.
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithArray:@[category]]];
}
-(void)_pushLocalNotification{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
    content.badge = @(1);
    content.title = @"EduLoop";
    content.body = @"Notification Body~";
    content.sound = [UNNotificationSound defaultSound];
    content.subtitle = @"...";
    content.userInfo = @{
        @"url":@"https://www.jianshu.com/p/ceaf978f9dfe"
    };
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:3 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"_pushLocalNotification" content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        //
        NSLog(@"finishNotification");
    }];
}
/*
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    completionHandler(UNNotificationPresentationOptionList | UNNotificationPresentationOptionBanner|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound);
}

//点击推送后调用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    
    //处理badge展示逻辑
    //点击之后根据业务逻辑处理
    int k = [UIApplication sharedApplication].applicationIconBadgeNumber;
    [UIApplication sharedApplication].applicationIconBadgeNumber = k-1;
    NSString *url =    [response.notification.request.content.userInfo objectForKey:@"url"];

    
    //处理业务逻辑
    completionHandler();
}*/
@end
