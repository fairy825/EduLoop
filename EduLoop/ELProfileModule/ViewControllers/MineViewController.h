//
//  ViewController.h
//  EduLoop
//
//  Created by mijika on 2020/12/2.
//

#import <UIKit/UIKit.h>
#import "MineInfoCard.h"
#import "MineToolCard.h"
#import "MineMiscCard.h"

@interface MineViewController : UIViewController
@property(nonatomic,strong,readwrite) UIView *container;
@property(nonatomic,strong,readwrite) MineInfoCard *header;
@property(nonatomic,strong,readwrite) MineToolCard *toolCard;
@property(nonatomic,strong,readwrite) MineMiscCard *miscCard;
@property(nonatomic,strong,readwrite) UIButton *logOutBtn;
@property(nonatomic,strong,readwrite) NSArray<NSString*> *miscTitles;
@property(nonatomic,strong,readwrite) NSArray<NSString*> *miscDetails;
@end

