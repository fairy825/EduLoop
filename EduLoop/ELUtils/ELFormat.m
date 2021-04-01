//
//  ELFormat.m
//  EduLoop
//
//  Created by mijika on 2021/4/1.
//

#import "ELFormat.h"

@implementation ELFormat

+ (BOOL)isNumber:(NSString *)strValue
{
    if (strValue == nil || [strValue length] <= 0)
    {
        return NO;
    }
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSString *filtered = [[strValue componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if (![strValue isEqualToString:filtered])
    {
        return NO;
    }
    return YES;
}

+ (NSString *)stringFromNSNumber:(NSNumber *)intValue{
    if(intValue==nil)
        return @"";
    return intValue.stringValue;
}

+ (NSString *)stringFromNSInteger:(NSInteger)intValue{
    return [NSString stringWithFormat:@"%ld",intValue];
}

+ (NSString *)safeString:(NSString *)str{
    return str==nil?@"":str;
}

@end
