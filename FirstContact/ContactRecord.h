//
//  ContactRecord.h
//  FirstContact
//
//  Created by Eri Tange on 2014/04/27.
//  Copyright (c) 2014年 Eri Tange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactRecord : NSObject

-(id)initWithPerson:(ABRecordRef)person property:(ABPropertyID)property identifer:(ABMultiValueIdentifier)identifer;

@property(readonly,nonatomic)ABRecordRef person;
@property(readonly,nonatomic)ABPropertyID propertyID;
@property(readonly,nonatomic)ABMultiValueIdentifier multiValueIdentifer;



@end
