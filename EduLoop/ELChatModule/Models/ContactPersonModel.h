//
//  ContactPerson.h
//  EduLoop
//
//  Created by mijika on 2021/1/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactPersonModel : NSObject
@property(nonatomic,strong,readwrite) NSString *name;
@property(nonatomic,strong,readwrite) NSString *identity;
@property(nonatomic,strong,readwrite) NSString *symbol;
@property(nonatomic,strong,readwrite) NSString *avatar;

@end

NS_ASSUME_NONNULL_END
