//
//  BasicInfo.m
//  EduLoop
//
//  Created by mijika on 2021/3/20.
//

#import "BasicInfo.h"
#import <MBProgressHUD.h>
#import <AFNetworking.h>
#import "ELUserInfo.h"
#import "ChatAllViewController.h"
#import "HomeworkShowViewController.h"
#import "CommunityViewController.h"
#import "MineViewController.h"
#import "UserLoginResponse.h"
#import "ELNetworkSessionManager.h"
#import "ELCenterOverlayModel.h"
#import "ELCenterOverlay.h"
#import "ELScreen.h"
#import <RTRootNavigationController.h>
@implementation BasicInfo
//static NSString *server=@"192.168.3.9";
static NSString *server=@"127.0.0.1";
static NSString *httpPort=@"8080";
static NSString *socketPort=@"8088";
+ (int)pageSize{
    return 10;
}
+ (NSString *)appendix{
    return [NSString stringWithFormat:@"%@%@%@%@", @"http://",server,@":",httpPort];
}
+ (NSString *)wsAppendix{
    return [NSString stringWithFormat:@"%@%@%@%@%@", @"ws://",server,@":",socketPort,@"/ws"];

}

+ (NSString *)url:(NSString *)str{
    NSMutableString *url = [NSMutableString string];
    [url appendString:BasicInfo.appendix];
    [url appendString:str];
    return url;
}
+ (NSString *)url:(NSString *)str path:(NSString *)path{
    NSMutableString *url = [NSMutableString string];
    [url appendString:BasicInfo.appendix];
    [url appendString:str];
    [url appendString:@"/"];
    [url appendString:path];
    return url;
}
+(NSString *)url:(NSString *)str Start:(int)start AndSize:(int)size{
    NSMutableString *url = [NSMutableString string];
    [url appendString:BasicInfo.appendix];
    [url appendString:str];
    [url appendString:@"?start="];
    [url appendString:[NSString stringWithFormat:@"%d",start]];
    [url appendString:@"&size="];
    [url appendString:[NSString stringWithFormat:@"%d",size]];
    return url;
}

+(NSString *)urlwithDefaultStartAndSize:(NSString *)str{
    return [BasicInfo url:str Start:1 AndSize:BasicInfo.pageSize];
}
+ (void)showToastWithMsg:(NSString *)str{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows lastObject] animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = str;
    hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.4f];
    [hud hideAnimated:YES afterDelay:1];
}

+(PGDatePickManager *)sharedManager{
    static PGDatePickManager* manager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[PGDatePickManager alloc]init];
    });
    return manager;
}

+(void)POST:(NSString *)URLString parameters:(nullable id)parameters wholesuccess:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success {
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    // 设置请求头
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //添加多的请求格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/json", @"text/javascript",@"text/html",nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager POST:URLString parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@---%@",[responseObject class],responseObject);

        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}

+(void)POST:(NSString *)URLString parameters:(nullable id)parameters success:(nullable void (^)())success {
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    // 设置请求头
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //添加多的请求格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/json", @"text/javascript",@"text/html",nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager POST:URLString parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@---%@",[responseObject class],responseObject);
            int code = [[responseObject objectForKey:@"code"]intValue];
            if(code!=0){
                NSString* msg = [responseObject objectForKey:@"msg"];
                NSLog(@"error--%@",msg);
                [BasicInfo showToastWithMsg:msg];
            }else if(success!=nil){
                success();
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}

+(void)PUT:(NSString *)URLString parameters:(nullable id)parameters success:(nullable void (^)())success{
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    // 设置请求头
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //添加多的请求格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/json", @"text/javascript",@"text/html",nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [manager PUT:URLString parameters:parameters headers:nil  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@---%@",[responseObject class],responseObject);
            int code = [[responseObject objectForKey:@"code"]intValue];
            if(code!=0){
                NSString* msg = [responseObject objectForKey:@"msg"];
                NSLog(@"error--%@",msg);
                [BasicInfo showToastWithMsg:msg];
            }else{
                if(success!=nil)
                success();
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}

+(void)DELETE:(NSString *)URLString success:(nullable void (^)())success{
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    [manager DELETE:URLString parameters:nil headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@---%@",[responseObject class],responseObject);
        int code = [[responseObject objectForKey:@"code"]intValue];
        
        if(code!=0){
            NSString* msg = [responseObject objectForKey:@"msg"];
            NSLog(@"error--%@",msg);
            [BasicInfo showToastWithMsg:msg];
        }else{
            success();
        }
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"请求失败--%@",error);
      }];
}

+(UITabBarController *)initNavigationTab{
//    RTRootNavigationController *controller3 = [[RTRootNavigationController alloc]initWithRootViewController:[[ChatAllViewController alloc]init]];
    ChatAllViewController *controller3 = [[ChatAllViewController alloc]init];
    controller3.tabBarItem.title = @"消息";
    controller3.tabBarItem.image = [UIImage imageNamed:@"icon_msg"];
    CommunityViewController *controller1 = [[CommunityViewController alloc]initWithMode:NO];
//    RTRootNavigationController *controller1 = [[RTRootNavigationController alloc]initWithRootViewController:[[CommunityViewController alloc]initWithMode:NO]];
    controller1.tabBarItem.title = @"班级";
    controller1.tabBarItem.image = [UIImage imageNamed:@"icon_discovery"];

    HomeworkShowViewController *controller2 = [[HomeworkShowViewController alloc]init];
//    RTRootNavigationController *controller2 = [[RTRootNavigationController alloc]initWithRootViewController:[[HomeworkShowViewController alloc]init]];
    controller2.tabBarItem.title = @"广播站";
    controller2.tabBarItem.image = [UIImage imageNamed:@"icon_homework"];

    MineViewController *controller4 = [[MineViewController alloc] init];
//    RTRootNavigationController *controller4 = [[RTRootNavigationController alloc]initWithRootViewController:[[MineViewController alloc]init]];
    controller4.tabBarItem.title = @"我的";
    controller4.tabBarItem.image = [UIImage imageNamed:@"icon_mine"];


    UITabBarController *tc = [[UITabBarController alloc]init];
    [tc setViewControllers:@[controller2,controller3,controller1,controller4]];
//    RTRootNavigationController *tabBarController = [[RTRootNavigationController alloc]initWithRootViewController:tc];
    return tc;
}

+(void)markUser{
    ELUserInfo *info = [ELUserInfo sharedUser];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(info.id) forKey:@"MY_ACCOUNT_ID"];
    [userDefaults setObject:[NSNumber numberWithBool:info.identity] forKey:@"IS_PARENT"];
    [userDefaults synchronize];
}

+(void)deleteUser{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"MY_ACCOUNT_ID"];
    [userDefaults removeObjectForKey:@"IS_PARENT"];
    [userDefaults synchronize];
}

+(void)reloadInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *myAccountId = [userDefaults objectForKey:@"MY_ACCOUNT_ID"];

    if ( myAccountId != nil ) {
      NSInteger profileId = [myAccountId integerValue];
        if(profileId!=0){
            AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
            [manager GET:[BasicInfo urlwithDefaultStartAndSize:@"/profile/myself"] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                    NSLog(@"%@---%@",[responseObject class],responseObject);
                    int code = [[responseObject objectForKey:@"code"]intValue];
                    NSString* msg = [responseObject objectForKey:@"msg"];
                    if(code==0){
                        UserLoginResponse *response = [[UserLoginResponse alloc]initWithDictionary:responseObject error:nil];
                        ProfileModel *profile = response.data;
                        [ELUserInfo setUserInfo: profile];

                    }else{
                        NSLog(@"error--%@",msg);
                        [BasicInfo showToastWithMsg:msg];
                    }

                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"请求失败--%@",error);

                }];
        }
    }
}

+(void)initUserWithBlock:(nullable void (^)())block{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *myAccountId = [userDefaults objectForKey:@"MY_ACCOUNT_ID"];

    if ( myAccountId != nil ) {
      NSInteger profileId = [myAccountId integerValue];
        if(profileId!=0){
            AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
            [manager GET:[BasicInfo urlwithDefaultStartAndSize:@"/profile/myself"] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                    NSLog(@"%@---%@",[responseObject class],responseObject);
                    int code = [[responseObject objectForKey:@"code"]intValue];
                    NSString* msg = [responseObject objectForKey:@"msg"];
                    if(code==0){
                        UserLoginResponse *response = [[UserLoginResponse alloc]initWithDictionary:responseObject error:nil];
                        ProfileModel *profile = response.data;
                        [ELUserInfo setUserInfo: profile];
                        if(block){
                            block();
                            return;
                        }
                    }else{
                        NSLog(@"error--%@",msg);
                        [BasicInfo showToastWithMsg:msg];
                        if(block){
                            block();
                            return;
                        }
                    }

                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"请求失败--%@",error);
                    if(block){
                        block();
                        return;
                    }
                }];
        }
    }else if(block)
        block();
}

+(void)getCurrentNetworkInfo{
    AFNetworkReachabilityManager *reach =[AFNetworkReachabilityManager sharedManager];
    [reach setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if(status !=AFNetworkReachabilityStatusReachableViaWWAN && status != AFNetworkReachabilityStatusReachableViaWiFi){
                ELCenterOverlayModel *centerOverlayModel = [ELCenterOverlayModel new];
                centerOverlayModel.title = @"请打开网络连接";
                centerOverlayModel.leftChoice = ({
                    ELOverlayItem *sureItem =[ELOverlayItem new];
                    sureItem.title = @"确认";
                    sureItem;
                });
                ELCenterOverlay *deleteAlertView = [[ELCenterOverlay alloc]initWithFrame:[UIScreen mainScreen].bounds Data:centerOverlayModel
                ];
        
                [deleteAlertView showHighlightView];
            }
    }];
    [reach startMonitoring];
}

@end
