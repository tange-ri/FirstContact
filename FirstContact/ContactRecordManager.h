//
//  ContactRecordManager.h
//  FirstContact
//
//  Created by Eri Tange on 2014/04/27.
//  Copyright (c) 2014年 Eri Tange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactRecordManager : NSObject

//アプリケーション内で共通のインスタンスを返す
+(instancetype)sharedManager;
-(BOOL)save;

@property(readonly,nonatomic)NSMutableArray *records;
@property(readonly,nonatomic)ABAddressBookRef addressBook;



@end
