//
//  ContactService.m
//  FirstContact
//
//  Created by Eri Tange on 2014/04/27.
//  Copyright (c) 2014年 Eri Tange. All rights reserved.
//

//与えられたContactRecordに基づいて電話をかける、メールを開く
#import "ContactService.h"
#import "ContactRecord.h"

@implementation ContactService

+(void)contactWithRecord:(ContactRecord *)record{
    
    //値を取得
    ABMultiValueRef multiValue = ABRecordCopyValue(record.person, record.propertyID);
    CFIndex index = ABMultiValueGetIndexForIdentifier(multiValue, record.multiValueIdentifer);
    NSString *value = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(multiValue, index);
    CFRelease(multiValue);
    
    //プロパティの種類に応じてスキームを組み立てる
    NSString *scheme;
    if (record.propertyID == kABPersonPhoneProperty) {
        NSString *phoneNumber = [value stringByReplacingOccurrencesOfString:@"" withString:@""];
        scheme = [NSString stringWithFormat:@"tel:%@",phoneNumber];
    }else{
        scheme = [NSString stringWithFormat:@"mailto:%@",value];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scheme]];
}



@end
