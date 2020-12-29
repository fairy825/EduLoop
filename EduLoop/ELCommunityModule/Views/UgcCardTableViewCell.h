//
//  UgcCardTableViewCell.h
//  EduLoop
//
//  Created by mijika on 2020/12/24.
//

#import <UIKit/UIKit.h>
#import "UgcCard.h"
NS_ASSUME_NONNULL_BEGIN
@protocol UgcCardTableViewCellDelegate<NSObject>
-(void)clickTrashButtonTableViewCell:(UITableViewCell *)tableViewCell;
-(void)clickCommentButtonTableViewCell:(UITableViewCell *)tableViewCell;
-(void)clickPhoto:(UIImage *)photo TableViewCell:(UITableViewCell *)tableViewCell;
@end

@interface UgcCardTableViewCell : UITableViewCell
@property(nonatomic,strong,readwrite) UgcCard *ugcCard;
@property(nonatomic,weak,readwrite) id<UgcCardTableViewCellDelegate> delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(UgcModel *)model;
@end

NS_ASSUME_NONNULL_END
