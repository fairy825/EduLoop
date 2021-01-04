//
//  ChatDetailViewController.m
//  EduLoop
//
//  Created by mijika on 2021/1/4.
//

#import "ChatDetailViewController.h"
#import "UIColor+EHTheme.h"
@interface ChatDetailViewController ()

@end

@implementation ChatDetailViewController

- (instancetype)initWithModel:(ChatAllModel *)model{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor eh_f6f6f6];
    [self setNavagationBar];
}

- (void)setNavagationBar{
    [self setTitle:@"xx"];
}
@end
