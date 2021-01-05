//
//  AddressListTableViewCell.h
//  EduLoop
//
//  Created by mijika on 2021/1/5.
//

#import <UIKit/UIKit.h>
#import "ContactPersonModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AddressListTableViewCell : UITableViewCell
@property (nonatomic, strong, readwrite) ContactPersonModel *data;
@property(nonatomic,strong,readwrite) UIView *bgView;
@property(nonatomic,strong,readwrite) UIView *seperateView;
@property(nonatomic,strong,readwrite) UIImageView *avatarImage;
@property(nonatomic,strong,readwrite) UILabel *nameLabel;
@property(nonatomic,strong,readwrite) UILabel *identityLabel;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(ContactPersonModel *)model;
- (void)loadData;
@end

NS_ASSUME_NONNULL_END
