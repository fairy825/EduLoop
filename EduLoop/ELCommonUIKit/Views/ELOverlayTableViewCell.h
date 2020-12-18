//
//  ELOverlayTableViewCell.h
//  EduLoop
//
//  Created by mijika on 2020/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ELOverlayTableViewCell : UITableViewCell

@property(nonatomic,strong,readwrite) UILabel *choiceLabel;
@property(nonatomic,copy,readwrite) dispatch_block_t clickItemBlock;
@end

NS_ASSUME_NONNULL_END
