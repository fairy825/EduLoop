//
//  IdentitySelectViewController.h
//  EduLoop
//
//  Created by mijika on 2021/4/4.
//

#import <UIKit/UIKit.h>
#import "IdentityCard.h"
NS_ASSUME_NONNULL_BEGIN

@interface IdentitySelectViewController : UIViewController
@property(nonatomic,strong,readwrite) IdentityCard *parentCard;
@property(nonatomic,strong,readwrite) IdentityCard *teacherCard;
@property(nonatomic,readwrite) NSInteger type;

@end

NS_ASSUME_NONNULL_END
