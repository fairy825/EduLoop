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

@implementation BasicInfo
+ (int)pageSize{
    return 10;
}
+ (NSString *)appendix{
    return @"http://localhost:8080";
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



+(void)POST:(NSString *)URLString parameters:(nullable id)parameters success:(nullable void (^)())success {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
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
                success();
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}

+(void)DELETE:(NSString *)URLString success:(nullable void (^)())success{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
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
    ChatAllViewController *controller3 = [[ChatAllViewController alloc]init];
    controller3.tabBarItem.title = @"消息";
    CommunityViewController *controller1 = [[CommunityViewController alloc]init];
    controller1.tabBarItem.title = @"班级";
    HomeworkShowViewController *controller2 = [[HomeworkShowViewController alloc]init];
    controller2.tabBarItem.title = @"广播站";
    MineViewController *controller4 = [[MineViewController alloc] init];
    controller4.tabBarItem.title = @"我的";
    
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    [tabBarController setViewControllers:@[controller3,controller2,controller1,controller4]];
    return tabBarController;
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
@end
