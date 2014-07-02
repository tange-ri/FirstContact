//
//  ContactService.h
//  FirstContact
//
//  Created by Eri Tange on 2014/04/27.
//  Copyright (c) 2014年 Eri Tange. All rights reserved.
//

#import <Foundation/Foundation.h>

//これはなんでしょう…
@class ContactRecord;

@interface ContactService : NSObject
+(void)contactWithRecord:(ContactRecord *)record;

@end
