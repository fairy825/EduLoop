//
//  ELSplashView.m
//  EduLoop
//
//  Created by mijika on 2021/5/25.
//

#import "ELSplashView.h"
#import "ELScreen.h"

@interface ELSplashView()

@property(nonatomic, strong, readwrite)UIButton *button;

@end

@implementation ELSplashView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage imageNamed:@"splash"];
        [self addSubview:({
            _button = [[UIButton alloc] initWithFrame:UIRect(330, 100, 60, 40)];
            _button.backgroundColor = [UIColor lightGrayColor];
            [_button setTitle:@"跳过" forState:UIControlStateNormal];
            [_button addTarget:self action:@selector(_removeSplashView) forControlEvents:UIControlEventTouchUpInside];
            _button;
        })];
        self.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark -

- (void)_removeSplashView{
    NSURL *urlScheme = [NSURL URLWithString:@"GTTest://"];
       /**BOOL canOpenURL = [[UIApplication sharedApplication] canOpenURL:urlScheme];
       [[UIApplication sharedApplication] openURL:urlScheme options:@{} completionHandler:^(BOOL success) {
           //
       }];*/
    [self removeFromSuperview];
}
@end
