//
//  InputTeamCodeViewController.h
//  EduLoop
//
//  Created by mijika on 2021/4/5.
//

#import <UIKit/UIKit.h>
#import <QuickSecurityCode/QuickSecurityCode.h>

NS_ASSUME_NONNULL_BEGIN

@interface InputTeamCodeViewController : UIViewController
@property(nonatomic,strong,readwrite) UILabel *introLabel;
@property(nonatomic,strong,readwrite) QuickSecurityCode *codeField;

@end

NS_ASSUME_NONNULL_END
