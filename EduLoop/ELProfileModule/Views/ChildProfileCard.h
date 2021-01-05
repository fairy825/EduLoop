//
//  ChildProfileCard.h
//  EduLoop
//
//  Created by mijika on 2020/12/9.
//

#import <UIKit/UIKit.h>
#import "ChildModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChildProfileCard : UITableViewCell
@property(nonatomic,strong,readwrite) UITableView *tableView;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(ChildModel *)model;
- (void)loadData:(ChildModel *)data;
@end

NS_ASSUME_NONNULL_END
