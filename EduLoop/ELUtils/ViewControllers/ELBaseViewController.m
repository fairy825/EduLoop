//
//  ELBaseViewController.m
//  EduLoop
//
//  Created by mijika on 2021/5/6.
//

#import "ELBaseViewController.h"

@interface ELBaseViewController ()

@end

@implementation ELBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn setTintColor:[UIColor blackColor]];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
