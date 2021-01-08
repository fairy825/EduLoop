//
//  AddressListViewController.h
//  EduLoop
//
//  Created by mijika on 2021/1/5.
//

#import <UIKit/UIKit.h>
#import "ContactPersonModel.h"
#import "ELSearchBar.h"
NS_ASSUME_NONNULL_BEGIN

@interface AddressListViewController : UIViewController
@property(nonatomic,strong,readwrite) NSMutableArray<NSMutableArray<ContactPersonModel *> *> *dataSource;
@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) NSMutableArray<NSString *> *titleArray;
@property(nonatomic,strong,readwrite) UIView *defaultView;
@property(nonatomic,strong,readwrite) ELSearchBar *searchBar;

@end

NS_ASSUME_NONNULL_END
