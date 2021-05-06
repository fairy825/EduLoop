//
//  LoginViewController.h
//  EduLoop
//
//  Created by mijika on 2021/4/4.
//

#import <UIKit/UIKit.h>
#import "ELBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : ELBaseViewController
@property(nonatomic,strong,readwrite) UIImageView *logo;
@property(nonatomic,strong,readwrite) UILabel *userNameLabel;
@property(nonatomic,strong,readwrite) UILabel *passwordLabel;
@property(nonatomic,strong,readwrite) UITextField *userNameTextField;
@property(nonatomic,strong,readwrite) UITextField *passwordTextField;
@property(nonatomic,strong,readwrite) UIView *inputView;
@property(nonatomic,strong,readwrite) UIButton *loginBtn;

@end

NS_ASSUME_NONNULL_END
