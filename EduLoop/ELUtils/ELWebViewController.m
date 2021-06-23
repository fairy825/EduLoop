//
//  BViewController.m
//  test
//
//  Created by mijika on 2021/6/15.
//

#import "ELWebViewController.h"
@interface ELWebViewController ()<WKNavigationDelegate,UITextFieldDelegate>
@property(nonatomic,strong,readwrite) UIProgressView *progressView;
@property(nonatomic,strong,readwrite) UIView *addressView;
@property(nonatomic,strong,readwrite) UITextField *addressTextField;
@property(nonatomic,strong,readwrite) UIView *btnView;
@property(nonatomic,strong,readwrite) UIButton *backBtn;
@property(nonatomic,strong,readwrite) UIButton *forwardBtn;
@property(nonatomic,strong,readwrite) UIButton *reloadBtn;
@property(nonatomic,strong,readwrite) UIButton *historyBtn;
@property(nonatomic,strong,readwrite) NSMutableArray<NSURL *> *urlArr;

@end

@implementation ELWebViewController
- (instancetype)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        _urlStr = url;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.addressTextField.text = self.webView.URL.absoluteString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.urlArr = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 44+40+20, self.view.bounds.size.width, self.view.bounds.size.height-44-40-20-70)];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];//KVO
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: self.urlStr]]];
    self.webView.navigationDelegate = self;
    
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 44+40, self.view.bounds.size.width, 20)];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.btnView];
    [self.view addSubview:self.addressView];

}
- (UIView *)addressView{
    if(!_addressView){
        _addressView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, 40)];
        _addressView.backgroundColor = [UIColor whiteColor];
        [_addressView addSubview:self.addressTextField];
    }
    return _addressView;
}
- (UITextField *)addressTextField{
    if(!_addressTextField){
        _addressTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, self.addressView.bounds.size.width-40, self.addressView.bounds.size.height)];
        _addressTextField.clearButtonMode = UITextFieldViewModeAlways;
        _addressTextField.backgroundColor = [UIColor lightGrayColor];
        _addressTextField.delegate = self;
    }
    return _addressTextField;
}
- (UIView *)btnView{
    if(!_btnView){
        _btnView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-70, self.view.bounds.size.width, 70)];
        _btnView.backgroundColor = [UIColor lightGrayColor];
        [_btnView addSubview:self.backBtn];
        [_btnView addSubview:self.reloadBtn];
        [_btnView addSubview:self.forwardBtn];
        [_btnView addSubview:self.historyBtn];

    }
    return _btnView;
}

- (UIButton *)backBtn{
    if(!_backBtn){
        _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_backBtn setTitle:@"back" forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)forwardBtn{
    if(!_forwardBtn){
        _forwardBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, 50, 50)];
        [_forwardBtn setTitle:@"forward" forState:UIControlStateNormal];
        [_forwardBtn addTarget:self action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forwardBtn;
}

- (UIButton *)reloadBtn{
    if(!_reloadBtn){
        _reloadBtn = [[UIButton alloc]initWithFrame:CGRectMake( 200,0, 50, 50)];
        [_reloadBtn setTitle:@"reload" forState:UIControlStateNormal];
        [_reloadBtn addTarget:self action:@selector(goReload) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reloadBtn;
}
- (UIButton *)historyBtn{
    if(!_historyBtn){
        _historyBtn = [[UIButton alloc]initWithFrame:CGRectMake( 300,0, 50, 50)];
        [_historyBtn setTitle:@"history" forState:UIControlStateNormal];
        [_historyBtn addTarget:self action:@selector(jumpToHistory) forControlEvents:UIControlEventTouchUpInside];
    }
    return _historyBtn;
}

- (void)goBack{
    [self.webView goBack];
}

- (void)goForward{
    [self.webView goForward];
}

- (void)goReload{
    [self.webView reload];
}

- (void)jumpToHistory{
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{

    decisionHandler(WKNavigationActionPolicyAllow);//允许加载

    NSLog(@"decidePolicy");
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"didCommitNavigation");
    [self.urlArr addObject:self.webView.URL];
    self.addressTextField.text = self.webView.URL.absoluteString;

}
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"didReceiveServerRedirectForProvisionalNavigation");

}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{

    NSLog(@"finish");
}

- (void)dealloc{

    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context{

    NSLog(@"%@", [change objectForKey:@"new"]);

    self.progressView.progress = self.webView.estimatedProgress;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_addressTextField resignFirstResponder];
    NSLog(@"%@", [NSString stringWithFormat:@"%@", _addressTextField.text]);
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: _addressTextField.text]]];
    [self.urlArr addObject:[NSURL URLWithString: _addressTextField.text]];
    return YES;
}
@end
