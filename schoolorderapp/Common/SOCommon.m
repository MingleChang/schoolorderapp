//
//  SOCommon.m
//  schoolorderapp
//
//  Created by cjw on 16/1/7.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOCommon.h"

@interface SOCommon()

@end

@implementation SOCommon
+(NSData *)encodeDataFromDictionary:(NSDictionary *)dic{
    NSData *lData=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSData *lBase64Data=[SOCommon data_encrypt:lData];
    return [lBase64Data base64EncodedDataWithOptions:0];
}
+(NSData *)encodeDataFromString:(NSString *)string{
    NSData *lData=[string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *lBase64Data=[SOCommon data_encrypt:lData];
    return [lBase64Data base64EncodedDataWithOptions:0];
}
+(NSString *)encodeFromDictionary:(NSDictionary *)dic{
    NSData *lData=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSData *lBase64Data=[SOCommon data_encrypt:lData];
    NSString *lString=[lBase64Data base64EncodedStringWithOptions:0];
    return lString;
}

+(NSString *)encodeFromString:(NSString *)string{
    NSData *lData=[string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *lBase64Data=[SOCommon data_encrypt:lData];
    NSString *lString=[lBase64Data base64EncodedStringWithOptions:0];
    return lString;
}

+(NSString *)decodeFromString:(NSString *)string{
    NSData* lBase64Data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    NSData *lData=[SOCommon data_encrypt:lBase64Data];
    NSString *lString=[[NSString alloc]initWithData:lData encoding:NSUTF8StringEncoding];
    return lString;
}
+(NSString *)decodeFromData:(NSData *)data{
    NSData* lBase64Data = [[NSData alloc] initWithBase64EncodedData:data options:0];
    NSData *lData=[SOCommon data_encrypt:lBase64Data];
    NSString *lString=[[NSString alloc]initWithData:lData encoding:NSUTF8StringEncoding];
    return lString;
}

//加密和解密算法
+(NSData *)data_encrypt:(NSData *)data{
    int p_IA1 = 0x2DB12EE;
    int p_IC1 = 0x013A85F;
    int M_Key = 0x534CA75;
    int ID_Key = 0x2EAD25A;
    
    int Key_0=M_Key;
    int ID_0=ID_Key;

    Byte *byte=(Byte *)data.bytes;
    for (int i=0; i<data.length; i++) {
        Key_0 = p_IA1 * (Key_0 % ID_0) + p_IC1;
        byte[i] ^= ((Key_0 >> 15) + 0xe3) & 0xFF;
    }
    
    NSData *lData=[NSData dataWithBytes:byte length:data.length];
    return lData;
}

#pragma mark - Get Character
+(NSString *)getHeaderAlphabet:(NSString*)hanzi{
    NSMutableString *str = [[NSMutableString alloc]initWithString:hanzi];
    CFStringTransform((__bridge CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    if (str.length!=0) {
        NSString *lFirstChar=[[str substringToIndex:1] uppercaseString];
        NSArray *alphabets = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
        if ([alphabets containsObject:lFirstChar]) {
            return lFirstChar;
        }
        return @"#";
    }
    return @"#";
}

+(NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = @"WIFI";
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
//                case 0:
//                    state = @"无网络";
//                    //无网模式
//                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                    state = @"WIFI";
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}
@end
