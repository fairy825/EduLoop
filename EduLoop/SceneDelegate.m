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
#import "TestViewController.h"
#import "UgcTextImgPublishViewController.h"
@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    CommunityViewController *controller1 = [[CommunityViewController alloc]init];
    controller1.tabBarItem.title = @"班级";
    
//    UgcDetailPageViewController *controller1 = [[UgcDetailPageViewController alloc]initWithModel:({
//        UgcModel *model = [UgcModel new];
//        model.ugcType = UgcType_vote;
//        model.authorName = @"dd";
//        model.dateStr = @"刚刚";
//        model.isMine = YES;
//
//        model;
//    })];
//    controller1.tabBarItem.title = @"班级";
    
    HomeworkShowViewController *controller2 = [[HomeworkShowViewController alloc]init];
    controller2.tabBarItem.title = @"通知";

//    UIViewController *controller1 = [[UIViewController alloc] init];
//    controller1.view.backgroundColor = [UIColor grayColor];
//    controller1.tabBarItem.title = @"新闻";
////    navigationController.tabBarItem.image =
////    navigationController.tabBarItem.selectedImage =
//    VideoViewController *controller2 = [[VideoViewController alloc] init];
//    controller2.tabBarItem.title = @"视频";
    
    MineViewController *controller4 = [[MineViewController alloc] init];
    controller4.tabBarItem.title = @"我的";
    
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    [tabBarController setViewControllers:@[controller1,controller2,controller4]];
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:tabBarController];//每个navigationController都需要rootNavigationController 代表栈底元素 即初始显示的controller
    [navigationController setNavigationBarHidden:YES];
    
    self.window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene*)scene];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
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
