//
//  BasicInfo.m
//  EduLoop
//
//  Created by mijika on 2021/3/20.
//

#import "BasicInfo.h"
#import <MBProgressHUD.h>
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
@end
