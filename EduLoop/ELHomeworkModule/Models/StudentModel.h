//
//  StudentModel.h
//  EduLoop
//
//  Created by mijika on 2021/4/4.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "ChildModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface StudentModel : JSONModel

@property(nonatomic,readwrite) NSInteger id;
@property(nonatomic,strong,readwrite) NSString<Optional> *sno;
@property(nonatomic,strong,readwrite) NSString<Optional> *name;
@property(nonatomic,strong,readwrite) NSString<Optional> *relationship;
@property(nonatomic,strong,readwrite) NSString<Optional> *faceImage;
@property(nonatomic,strong,readwrite) NSString<Optional> *qrcode;
@property(nonatomic,readwrite) BOOL sex;
@property(nonatomic,readwrite) NSInteger grade;

@property(nonatomic,readwrite) NSNumber <Optional> *teamId;
@property(nonatomic,strong,readwrite) NSString<Optional> *teamName;
@end

NS_ASSUME_NONNULL_END
