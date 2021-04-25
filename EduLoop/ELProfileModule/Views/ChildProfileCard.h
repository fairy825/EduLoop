//
//  ChildProfileCard.h
//  EduLoop
//
//  Created by mijika on 2020/12/9.
//

#import <UIKit/UIKit.h>
#import "ChildModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol ChildProfileCardDelegate;

@interface ChildProfileCard : UITableViewCell
@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) ChildModel *model;
@property(nonatomic,weak,readwrite) id<ChildProfileCardDelegate> delegate;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(ChildModel *)model;
- (void)loadData:(ChildModel *)data;
- (void)reload:(ChildModel *)data;
@end

@protocol ChildProfileCardDelegate<NSObject>

-(void)ChildProfileCardJumpToInputCode:(ChildProfileCard *)card;

@end
NS_ASSUME_NONNULL_END
