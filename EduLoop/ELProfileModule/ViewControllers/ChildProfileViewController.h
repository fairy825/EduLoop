//
//  ChildProfileViewController.h
//  EduLoop
//
//  Created by mijika on 2020/12/9.
//

#import <UIKit/UIKit.h>
#import "ChildProfileCard.h"
#import "ELFloatingButton.h"
#import "StudentModel.h"
#import "ELBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChildProfileViewController : ELBaseViewController
@property(nonatomic,strong,readwrite) ChildProfileCard *childProfileCard;
@property(nonatomic,readwrite) NSInteger page;
@property(nonatomic,strong,readwrite) ELFloatingButton *addBtn;

@property(nonatomic,strong,readwrite) UITableView *profileTableView;
@property(nonatomic,strong,readwrite) NSMutableArray<ChildModel*>* models;

@end

NS_ASSUME_NONNULL_END
