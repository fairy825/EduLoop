//
//  ELTabViewController.m
//  EduLoop
//
//  Created by mijika on 2021/5/9.
//

#import "ELTabViewController.h"

@interface ELTabViewController ()

@end

@implementation ELTabViewController
-(void)viewDidAppear:(BOOL)animated{
  if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
  }
}
   
-(void)viewWillDisappear:(BOOL)animated{
  self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}



@end
