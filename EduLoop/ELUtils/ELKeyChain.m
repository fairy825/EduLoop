//
//  ELKeyChain.m
//  EduLoop
//
//  Created by mijika on 2021/6/22.
//

#import "ELKeyChain.h"

@implementation ELKeyChain

+ (NSMutableDictionary *)keychainDicWithAccountId:(NSString *)accountId andServiceId:(NSString *)serviceId{
    
    //构建一个存取条件,实质是一个字典
    //指定服务类型是普通密码
    NSString *classKey = (__bridge NSString *)kSecClass;
    NSString *classValue = (__bridge NSString *)kSecClassGenericPassword;
    //指定安全类型是任何时候都可以访问
    NSString *accessibleKey = (__bridge NSString *)kSecAttrAccessible;
    NSString *accessibleValue = (__bridge NSString *)kSecAttrAccessibleAlways;
    //指定服务的账户名 可以与服务名相同 账户名可以对应多个服务名
    NSString *accountKey = (__bridge NSString *)kSecAttrAccount;
    NSString *accountValue = accountId;
    //指定服务的名字 可以与服务账户名相同
    NSString *serviceKey = (__bridge NSString *)kSecAttrService;
    NSString *serviceValue = serviceId;
    NSDictionary *keychainItems = @{classKey      : classValue,
                                    accessibleKey : accessibleValue,
                                    accountKey    : accountValue,
                                    serviceKey    : serviceValue};
    return keychainItems.mutableCopy;
}


+ (NSMutableDictionary *)keychainDicWithServiceId:(NSString *)serviceId{
    
    //构建一个存取条件,实质是一个字典
    //指定服务类型是普通密码
    NSString *classKey = (__bridge NSString *)kSecClass;
    NSString *classValue = (__bridge NSString *)kSecClassGenericPassword;
    //指定安全类型是任何时候都可以访问
    NSString *accessibleKey = (__bridge NSString *)kSecAttrAccessible;
    NSString *accessibleValue = (__bridge NSString *)kSecAttrAccessibleAlways;
    //指定服务的名字 可以与服务账户名相同
    NSString *serviceKey = (__bridge NSString *)kSecAttrService;
    NSString *serviceValue = serviceId;
    NSDictionary *keychainItems = @{classKey      : classValue,
                                    accessibleKey : accessibleValue,
                                    serviceKey    : serviceValue};
    return keychainItems.mutableCopy;
}


+ (BOOL)keychainSaveData:(id)aData withAccountIdentifier:(NSString *)accountId andServiceIdentifier:(NSString *)serviceId{
    // 获取存储的数据的条件
    NSMutableDictionary * saveQueryDic = [self keychainDicWithAccountId:accountId andServiceId:serviceId];
    // 删除旧的数据
    SecItemDelete((CFDictionaryRef)saveQueryDic);
    // 设置新的数据
    [saveQueryDic setObject:[NSKeyedArchiver archivedDataWithRootObject:aData] forKey:(id)kSecValueData];
    // 添加数据
    OSStatus saveState = SecItemAdd((CFDictionaryRef)saveQueryDic, nil);
    // 释放对象
    saveQueryDic = nil ;
    // 判断是否存储成功
    if (saveState == errSecSuccess) {
        return YES;
    }
    return NO;
}

+ (void)keychainDeleteWithAccountIdentifier:(NSString *)accountId andServiceIdentifier:(NSString *)serviceId{
    // 获取删除数据的查询条件
    NSMutableDictionary * deleteQueryDic = [self keychainDicWithAccountId:accountId andServiceId:serviceId];
    // 删除指定条件的数据
    SecItemDelete((CFDictionaryRef)deleteQueryDic);
    deleteQueryDic = nil ;
}

+ (BOOL)keychainUpdataData:(id)data withAccountIdentifier:(NSString *)accountId andServiceIdentifier:(NSString *)serviceId{
    // 通过标记获取数据更新的条件
    NSMutableDictionary * updataQueryDic = [self keychainDicWithAccountId:accountId andServiceId:serviceId];
    // 创建更新数据字典
    NSMutableDictionary * newDic = @{}.mutableCopy;
    // 存储数据
    [newDic setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    // 获取存储的状态
    OSStatus  updataStatus = SecItemUpdate((CFDictionaryRef)updataQueryDic, (CFDictionaryRef)newDic);
    updataQueryDic = nil;
    newDic = nil;
    // 判断是否更新成功
    if (updataStatus == errSecSuccess) {
        return  YES ;
    }
    return NO;
}

+ (id)keychainGetDataWithAccountIdentifier:(NSString *)accountId andServiceIdentifier:(NSString *)serviceId{
    id idObject = nil ;
    // 通过标记获取数据查询条件
    NSMutableDictionary * readQueryDic = [self keychainDicWithAccountId:accountId andServiceId:serviceId];
    // 查询结果返回到 kSecValueData (此项必选)
    [readQueryDic setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    // 只返回搜索到的第一条数据 (此项必选)
        [readQueryDic setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];

    // 创建一个对象接受结果
    CFDataRef keyChainData = nil ;
    // 通过条件查询数据
    if (SecItemCopyMatching((CFDictionaryRef)readQueryDic , (CFTypeRef *)&keyChainData) == noErr){
        @try {
            //转换类型
            idObject = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)(keyChainData)];
        } @catch (NSException * exception){
            NSLog(@"Unarchive of search data where %@ failed of %@ ",serviceId,exception);
        }
    }
    if (keyChainData) {
        CFRelease(keyChainData);
    }
    readQueryDic = nil;
    // 返回数据
    return idObject ;
}

+ (id)keychainGetMuchDataWithServiceIdentifier:(NSString *)serviceId{
    id idObject = nil ;
    // 通过标记获取数据查询条件
    NSMutableDictionary * readQueryDic = [self keychainDicWithServiceId:serviceId];
    // 查询结果返回到 kSecValueData (此项必选)
    [readQueryDic setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    // 只返回搜索到的第一条数据 (此项必选)
    [readQueryDic setObject:(id)kSecMatchLimitAll forKey:(id)kSecMatchLimit];

    // 创建一个对象接受结果
    CFDataRef keyChainData = nil ;
    // 通过条件查询数据
    if (SecItemCopyMatching((CFDictionaryRef)readQueryDic , (CFTypeRef *)&keyChainData) == noErr){
        @try {
            //转换类型
            idObject = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)(keyChainData)];
        } @catch (NSException * exception){
            NSLog(@"Unarchive of search data where %@ failed of %@ ",serviceId,exception);
        }
    }
    if (keyChainData) {
        CFRelease(keyChainData);
    }
    readQueryDic = nil;
    // 返回数据
    return idObject ;
}

@end
