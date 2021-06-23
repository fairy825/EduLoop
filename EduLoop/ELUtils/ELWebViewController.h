//
//  ELWebViewController.h
//  EduLoop
//
//  Created by mijika on 2021/6/22.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ELWebViewController : UIViewController
@property(nonatomic,strong,readwrite) WKWebView *webView;
@property(nonatomic,strong,readwrite) NSString *urlStr;
- (instancetype)initWithUrl:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
