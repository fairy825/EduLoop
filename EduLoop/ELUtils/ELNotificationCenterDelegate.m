//
//  ELNotificationCenterDelegate.m
//  EduLoop
//
//  Created by mijika on 2021/6/22.
//

#import "ELNotificationCenterDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "ELWebViewController.h"
#import "ELSplashView.h"
@interface ELNotificationCenterDelegate () <UNUserNotificationCenterDelegate>
@end

@implementation ELNotificationCenterDelegate
+ (instancetype)sharedDelegate {
    static ELNotificationCenterDelegate *delegate = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        delegate = [[ELNotificationCenterDelegate alloc] init];
    });
    return delegate;
}

+ (void)registerToCurrentNotificationCenterDelegate {
    [[UNUserNotificationCenter currentNotificationCenter] setDelegate:[self sharedDelegate]];
}

// App 在前台，通知触发会调用这个方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"UserInfo: %@", notification.request.content.userInfo);
    
    completionHandler(UNNotificationPresentationOptionList | UNNotificationPresentationOptionBanner|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler {
    /*if ([response.notification.request.content.categoryIdentifier isEqual:@"com.el.notification.category"]) {
        NSDictionary *userInfo = response.notification.request.content.userInfo;
        NSLog(@"%@", userInfo[@"url"]);
        
        if ([response.actionIdentifier isEqual:@"com.el.notification.ok"]) {
            NSLog(@"OK Action click");
        } else if ([response.actionIdentifier isEqual:@"com.el.notification.wait"]) {
            NSLog(@"Wait Action click");
        } else if ([response.actionIdentifier isEqual:UNNotificationDefaultActionIdentifier]) { // 用户通过通知打开了 App
            NSLog(@"User open app through notification");
        } else if ([response.actionIdentifier isEqual:UNNotificationDismissActionIdentifier]) { // 用户点击了通知的关闭按钮
            NSLog(@"User dimiss notification");
        }
    }*/
    NSString *url = response.notification.request.content.userInfo[@"url"];
    NSLog(@"UserInfo: %@", url);
    UIWindow *window = [[[UIApplication sharedApplication]windows]lastObject];
    UINavigationController *nav = window.rootViewController;
    if([[[window subviews]lastObject] isKindOfClass:[ELSplashView class]]){
        [[[window subviews]lastObject] removeFromSuperview];
    }
    [nav pushViewController:[[ELWebViewController alloc]initWithUrl:url] animated:YES];
    completionHandler();
}

@end
