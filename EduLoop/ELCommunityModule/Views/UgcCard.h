//
//  UgcCard.h
//  EduLoop
//
//  Created by mijika on 2020/12/18.
//

#import <UIKit/UIKit.h>
#import "AvatarCard.h"
#import "UgcModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol UgcCardDelegate<NSObject>
-(void)clickTrashButtonTableViewCell:(UITableViewCell *)tableViewCell;
-(void)clickCommentButtonTableViewCell:(UITableViewCell *)tableViewCell;
-(void)clickPhoto:(UIImage *)photo TableViewCell:(UITableViewCell *)tableViewCell;
@end

@interface UgcCard : UIView

@property (nonatomic, strong, readwrite) UgcModel *data;
@property(nonatomic,strong,readwrite) UIView *bgView;
@property(nonatomic,strong,readwrite) UIView *seperateView;
@property(nonatomic,strong,readwrite) AvatarCard *avatarCard;
@property(nonatomic,strong,readwrite) UIButton *trashButton;
@property(nonatomic,readwrite) BOOL hasTrash;
@property(nonatomic,weak,readwrite) id<UgcCardDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame Data:(UgcModel *)model;
- (void)hideBtns;
- (void)reload;
@end

NS_ASSUME_NONNULL_END
