//
//  ScanQRCodeViewController.h
//  EduLoop
//
//  Created by mijika on 2021/4/25.
//

#import <UIKit/UIKit.h>
#import <SGQRCode/SGQRCode.h>
NS_ASSUME_NONNULL_BEGIN

@interface ScanQRCodeViewController : UIViewController

@property (nonatomic, strong) SGQRCodeScanView *scanView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) BOOL stop;
@end

NS_ASSUME_NONNULL_END
