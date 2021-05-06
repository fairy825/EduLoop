//
//  ChildProfileEditViewController.h
//  EduLoop
//
//  Created by mijika on 2021/4/16.
//

#import <UIKit/UIKit.h>
#import "SettingDataTableViewCell.h"
#import "ChildModel.h"
#import "ELBottomSelectOverlay.h"
#import "ELBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChildProfileEditViewController : ELBaseViewController

@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) NSMutableArray<SettingDataModel*>* models;
@property(nonatomic,readwrite) NSInteger relationshipIndex;
@property(nonatomic,readwrite) NSInteger gradeIndex;
@property(nonatomic,readwrite) UIImage *avatarImage;
@property(nonatomic,strong,readwrite) ChildModel *child;
@property(nonatomic,strong,readwrite) ELBottomSelectOverlay *overlay;
@property(nonatomic,strong,readwrite) ELBottomSelectOverlay *overlay1;
@property(nonatomic,readwrite) BOOL editMode;
@property(nonatomic,readwrite) NSString *teamCode;
- (instancetype)initWithData:(ChildModel *)data;
- (instancetype)initWithTeamCode:(NSString *)teamCode;
@end

NS_ASSUME_NONNULL_END
