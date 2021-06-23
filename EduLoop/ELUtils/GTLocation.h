//
//  GTLocation.h
//  EduLoop
//
//  Created by mijika on 2021/6/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTLocation : NSObject
+ (GTLocation *)locationManager;
- (void)checkLocationAuthorization;

@end

NS_ASSUME_NONNULL_END
