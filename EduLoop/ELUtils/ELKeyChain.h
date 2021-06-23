//
//  ELKeyChain.h
//  EduLoop
//
//  Created by mijika on 2021/6/22.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>
NS_ASSUME_NONNULL_BEGIN
//NSString* const ELKeychainService = @"com.el.keychain";

@interface ELKeyChain : NSObject
+ (void)keychainDeleteWithAccountIdentifier:(NSString *)accountId andServiceIdentifier:(NSString *)serviceId;
+ (BOOL)keychainSaveData:(id)aData withAccountIdentifier:(NSString *)accountId andServiceIdentifier:(NSString *)serviceId;
+ (BOOL)keychainUpdataData:(id)data withAccountIdentifier:(NSString *)accountId andServiceIdentifier:(NSString *)serviceId;
+ (id)keychainGetDataWithAccountIdentifier:(NSString *)accountId andServiceIdentifier:(NSString *)serviceId;
+ (id)keychainGetMuchDataWithServiceIdentifier:(NSString *)serviceId;
+ (NSMutableDictionary *)keychainDicWithAccountId:(NSString *)accountId andServiceId:(NSString *)serviceId;
+ (NSMutableDictionary *)keychainDicWithServiceId:(NSString *)serviceId;
@end

NS_ASSUME_NONNULL_END
