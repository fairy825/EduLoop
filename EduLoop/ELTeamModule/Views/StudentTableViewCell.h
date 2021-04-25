//
//  StudentTableViewCell.h
//  EduLoop
//
//  Created by mijika on 2021/4/25.
//

#import <UIKit/UIKit.h>
#import "StudentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface StudentTableViewCell : UITableViewCell
@property(nonatomic,strong,readwrite) UILabel *nameLabel;
@property (nonatomic, strong, readwrite) StudentModel *data;
@property(nonatomic,strong,readwrite) UIView *bgView;
@property(nonatomic,strong,readwrite) UIImageView *avatarImage;
@property(nonatomic,strong,readwrite) UILabel *snoLabel;
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(CommentModel *)model;
- (void)loadData;
@end

NS_ASSUME_NONNULL_END
