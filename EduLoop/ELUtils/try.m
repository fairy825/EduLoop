//
//  try.m
//  EduLoop
//
//  Created by mijika on 2021/6/1.
//
#import <Foundation/Foundation.h>

@interface Dog : NSObject
@end
@implementation Dog
{
     NSString* toSetName;
    NSString* isName;
    NSString* name;
//    NSString* _name;
//    NSString* _isName;
}
 -(void)setName:(NSString*)name{
     toSetName = name;
 }
-(NSString*)getName{
    return toSetName;
}
+(BOOL)accessInstanceVariablesDirectly{
    return NO;
}
-(id)valueForUndefinedKey:(NSString *)key{
    NSLog(@"出现异常，该key不存在%@",key);
    return nil;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
     NSLog(@"出现异常，该key不存在%@",key);
}
@end
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        Dog* dog = [Dog new];
        [dog setValue:@"newName" forKey:@"name"];
        NSString* name = [dog valueForKey:@"name"];
        NSLog(@"%@",name);
    }
    return 0;
}
