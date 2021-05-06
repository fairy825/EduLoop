//
//  UgcDetailPageViewController.h
//  EduLoop
//
//  Created by mijika on 2020/12/21.
//

#import <UIKit/UIKit.h>
#import "UgcCard.h"
#import "CommentEditView.h"
#import "CommentModel.h"
#import "MomentsModel.h"
#import "ChatBoard.h"
#import "ELBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface UgcDetailPageViewController : ELBaseViewController
@property(nonatomic,readwrite) int page;
@property(nonatomic,readwrite) NSInteger commentId;

@property(nonatomic,strong,readwrite) UgcCard *summaryUgcCard;
@property(nonatomic,strong,readwrite) UILabel *commentNumLabel;
@property(nonatomic,strong,readwrite) UITableView *commentTableView;
@property(nonatomic,strong,readwrite) ChatBoard *chatBoard;
@property(nonatomic,strong,readwrite) NSMutableArray<CommentModel *>* commentModels;
@property(nonatomic,strong,readwrite) MomentsModel* ugcModel;
- (instancetype)initWithModel:(MomentsModel *)model;
@end

NS_ASSUME_NONNULL_END
