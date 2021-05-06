//
//  ELBottomSelectOverlay.h
//  EduLoop
//
//  Created by mijika on 2021/3/23.
//

#import <UIKit/UIKit.h>
#import "ELOverlay.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ELBottomSelectOverlayDelegate;

@interface ELBottomSelectOverlay : ELBottomOverlay
@property(nonatomic,readwrite) BOOL isSingle;
@property(nonatomic,strong,readwrite) NSString *title;
@property(nonatomic,strong,readwrite) NSArray *subTitles;
@property(nonatomic,strong,readwrite) UIView *container;
@property(nonatomic,strong,readwrite) UIView *innerContainer;
@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) UILabel *titleLabel;
@property(nonatomic,strong,readwrite) NSMutableArray<NSNumber *> *selectedIdxs;

@property(nonatomic,weak,readwrite) id<ELBottomSelectOverlayDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title;
- (void)reload;
@end

@protocol ELBottomSelectOverlayDelegate<NSObject>
@optional
-(void)ELBottomSelectOverlay:(ELBottomSelectOverlay*)overlay updateChosedTeams:(int)idx Add:(BOOL)isAdd;
-(void)ELBottomSelectOverlay:(ELBottomSelectOverlay*)overlay singleUpdateChosedTeams:(int)idx Add:(BOOL)isAdd;
@end
NS_ASSUME_NONNULL_END
