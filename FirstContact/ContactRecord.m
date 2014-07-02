//
//  ContactRecord.m
//  FirstContact
//
//  Created by Eri Tange on 2014/04/27.
//  Copyright (c) 2014年 Eri Tange. All rights reserved.
//

#import "ContactRecord.h"
#import "ContactRecordManager.h"

static NSString *const kEncodeKeyRecordID = @"RecordID";
static NSString *const kEncodeKeyPropertyID = @"PropertyID";
static NSString *const kEncodeKeyMultiValueIdentifer = @"MultiValueIdentifer";

@interface ContactRecord()
@property(assign,nonatomic)ABRecordID recordID;
@end

@implementation ContactRecord

-(id)initWithPerson:(ABRecordRef)person property:(ABPropertyID)property identifer:(ABMultiValueIdentifier)identifer{
    
    self = [super init];
    if (self) {
        //内部的にはABRecordRefを直接持たずにABRecordRefを示すIDを保持する
        _recordID = ABRecordGetRecordID(person);
        _propertyID = property;
        _multiValueIdentifer = identifer;
    }
    return self;
}

//NSCodingのデコードメソッド
-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [self init];
    if (self) {
        //NSCoderから各プロパティの値をデコードする
        _recordID = [aDecoder decodeInt32ForKey:kEncodeKeyRecordID];
        _propertyID = [aDecoder decodeInt32ForKey:kEncodeKeyPropertyID];
        _multiValueIdentifer = [aDecoder decodeInt32ForKey:kEncodeKeyMultiValueIdentifer];
    }
    return self;
}

//NSCodingのエンコードメソッド
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    //各プロパティの値をエンコードする
    [aCoder encodeInt32:_recordID forKey:kEncodeKeyPropertyID];
    [aCoder encodeInt32:_propertyID forKey:kEncodeKeyPropertyID];
    [aCoder encodeInt32:_multiValueIdentifer forKey:kEncodeKeyMultiValueIdentifer];
}

-(ABRecordRef)person{
    ABAddressBookRef addressBook = [[ContactRecordManager sharedManager] addressBook];
    return ABAddressBookGetPersonWithRecordID(addressBook, self.recordID);
}

@end
