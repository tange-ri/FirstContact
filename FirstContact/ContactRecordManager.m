//
//  ContactRecordManager.m
//  FirstContact
//
//  Created by Eri Tange on 2014/04/27.
//  Copyright (c) 2014年 Eri Tange. All rights reserved.
//

#import "ContactRecordManager.h"

@implementation ContactRecordManager

+(instancetype)sharedManager{
    static id manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        manager = [[self alloc] init];
    });
    return manager;
}

//ファイルの保存先を返す
-(NSString *)filePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *name = @"records.plist";
    
    return [path stringByAppendingPathComponent:name];
    
}

-(void)dealloc{
    CFRelease(_addressBook);
}

-(BOOL)save{
    //データをファイルに書き出し
    return [NSKeyedArchiver archiveRootObject:self.records toFile:[self filePath]];
}



-(id)init{
    
    self =[super init];
    if (self) {
        //ファイルからデータを読み込む
        NSMutableArray *records =[NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];
        //データがない場合は空の配列を設定
        if (!records) {
            records = [NSMutableArray array];
        }
        
        _addressBook = ABAddressBookCreateWithOptions(nil, nil);
        _records = records;
    }
    
    return self;
}



@end
