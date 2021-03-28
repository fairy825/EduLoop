//
//  ELBottomSelectOverlayCellTableViewCell.h
//  EduLoop
//
//  Created by mijika on 2021/3/28.
//

#import <UIKit/UIKit.h>
#import "ELOverlayTableViewCell.h"
#import "TeamModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ELBottomSelectOverlayCell: UITableViewCell

@property(nonatomic,strong,readwrite) TeamModel *data;
@property(nonatomic,strong,readwrite) UILabel *choiceLabel;
@property(nonatomic,copy,readwrite) dispatch_block_t clickItemBlock;
-(void)loadData;
@end

NS_ASSUME_NONNULL_END
