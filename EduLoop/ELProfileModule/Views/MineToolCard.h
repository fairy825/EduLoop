//
//  MineToolCard.h
//  EduLoop
//
//  Created by mijika on 2020/12/3.
//

#import <UIKit/UIKit.h>
#import "MineToolCardItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineToolCard : UIView
@property (nonatomic) NSArray<MineToolCardItem*> *items;
@end

NS_ASSUME_NONNULL_END
