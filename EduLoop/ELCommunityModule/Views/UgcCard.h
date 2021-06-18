//
//  UgcCard.h
//  EduLoop
//
//  Created by mijika on 2020/12/18.
//

#import <UIKit/UIKit.h>
#import "AvatarCard.h"
#import "UgcModel.h"
#import "MomentsModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol UgcCardDelegate<NSObject>
-(void)clickTrashButtonTableViewCell:(UITableViewCell *)tableViewCell;
-(void)clickCommentButtonTableViewCell:(UITableViewCell *)tableViewCell;
-(void)clickThumbButtonTableViewCell:(UITableViewCell *)tableViewCell ugcTextImgCard:(UIView *) ugcTextImgCard;
-(void)clickPhoto:(NSString *)url TableViewCell:(UITableViewCell *)tableViewCell;
@end

@interface UgcCard : UIView

@property (nonatomic, strong, readwrite) MomentsModel *data;
@property(nonatomic,strong,readwrite) UIView *bgView;
@property(nonatomic,strong,readwrite) UIView *seperateView;
@property(nonatomic,strong,readwrite) AvatarCard *avatarCard;
@property(nonatomic,strong,readwrite) UIButton *trashButton;
@property(nonatomic,strong,readwrite) UIView *btnsView;
@property(nonatomic,readwrite) BOOL hasTrash;
@property(nonatomic,weak,readwrite) id<UgcCardDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame Data:(MomentsModel *)model;
- (void)reload;
-(void)hideBtns;

@end

NS_ASSUME_NONNULL_END
