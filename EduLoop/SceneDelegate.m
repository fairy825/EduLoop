//
//  SceneDelegate.m
//  EduLoop
//
//  Created by mijika on 2020/12/2.
//

#import "SceneDelegate.h"
#import "ELProfileModule/ELProfileModule.h"
#import "ELHomeworkModule/ELHomeworkModule.h"
#import "ELCommunityModule/ELCommunityModule.h"
#import "ELChatModule/ELChatModule.h"
#import "ELOauthModule/ELOauthModule.h"
#import "ELTeamModule/ELTeamModule.h"
#import "BasicInfo.h"
#import <RTRootNavigationController.h>
#import "ELSplashView.h"
#import "ELNotification.h"
#import "ELNotificationCenterDelegate.h"
@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    /**
     获取了userinfo之后再判断出现的第一个vc
     */
   
        [BasicInfo initUserWithBlock:^{
            
   
        ELUserInfo *userInfo = [ELUserInfo sharedUser];
//        UINavigationController *navigationController;
        UIViewController *navigationController;
        if(userInfo!=nil&&userInfo.id!=0){
            navigationController = [BasicInfo initNavigationTab];
//            navigationController = [[UINavigationController alloc]initWithRootViewController:[BasicInfo initNavigationTab]];//每个navigationController都需要rootNavigationController 代表栈底元素 即初始显示的controller
        }else{
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            navigationController = loginVC;
//            navigationController = [[UINavigationController alloc]initWithRootViewController:loginVC];//每个navigationController都需要rootNavigationController 代表栈底元素 即初始显示的controller
        }
//        [navigationController setNavigationBarHidden:YES];
        self.window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene*)scene];
        self.window.rootViewController = [[RTRootNavigationController alloc] initWithRootViewController:navigationController];
        self.window.rootViewController.rt_disableInteractivePop = YES;

        [self.window makeKeyAndVisible];
        [self.window addSubview:({
            ELSplashView *splashView = [[ELSplashView alloc] initWithFrame:self.window.bounds];
            splashView;
        })];
        
        }];

}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
