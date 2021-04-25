//
//  InputRelationshipViewController.h
//  EduLoop
//
//  Created by mijika on 2021/4/25.
//

#import <UIKit/UIKit.h>
#import "ELBottomSelectOverlay.h"
#import "SettingDataTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface InputRelationshipViewController : UIViewController
@property(nonatomic,readwrite) NSInteger studentId;
@property(nonatomic,readwrite) NSInteger relationshipIndex;
@property(nonatomic,strong,readwrite) ELBottomSelectOverlay *overlay;
@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) NSMutableArray<SettingDataModel*>* models;

- (instancetype)initWithStudent:(NSInteger)studentId;
@end

NS_ASSUME_NONNULL_END
