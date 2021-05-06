//
//  IdentitySelectViewController.h
//  EduLoop
//
//  Created by mijika on 2021/4/4.
//

#import <UIKit/UIKit.h>
#import "IdentityCard.h"
#import "ELBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface IdentitySelectViewController : ELBaseViewController
@property(nonatomic,strong,readwrite) IdentityCard *parentCard;
@property(nonatomic,strong,readwrite) IdentityCard *teacherCard;
@property(nonatomic,readwrite) NSInteger type;
@property(nonatomic,readwrite) NSString *name;
@property(nonatomic,readwrite) NSString *password;
- (instancetype)initWithName:(NSString *)name Pass:(NSString *)password;
@end

NS_ASSUME_NONNULL_END
