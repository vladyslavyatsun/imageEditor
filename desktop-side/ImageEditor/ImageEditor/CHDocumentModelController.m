//
//  CHDocumentModelController.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/22/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHDocumentModelController.h"
#import "CHAbstractElement.h"

NSString * const kCHDocumentModelControllerDidAddElement = @"element added";
NSString * const kCHDocumentModelControllerDidRemoveElememt = @"element removed";
NSString * const kCHKeyOfDocumentModelControllerNotificationsUserInfo = @"element";

@interface CHDocumentModelController ()
@property (nonatomic, retain) NSMutableArray *mElementsArray;
@end

@implementation CHDocumentModelController

- (instancetype)init
{
    return [self initWithElementsArray:nil];
}

- initWithElementsArray:(NSArray<CHAbstractElement *> *)elementsArray
{
    self = [super init];
    
    if (self)
    {
        _mElementsArray = [[NSMutableArray alloc] init];
        [_mElementsArray addObjectsFromArray:elementsArray];
    }
    return self;
}


- (void)addElement:(CHAbstractElement *)anElement
{
    if (anElement)
    {
        [self.mElementsArray addObject:anElement];
        [[NSNotificationCenter defaultCenter] postNotificationName:kCHDocumentModelControllerDidAddElement
                                                            object:self
                                                          userInfo:@{kCHKeyOfDocumentModelControllerNotificationsUserInfo:anElement}];
    }
}

- (void)removeElement:(CHAbstractElement *)anElement
{
    if ([self.mElementsArray containsObject:anElement])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCHDocumentModelControllerDidRemoveElememt
                                                            object:self
                                                          userInfo:@{kCHKeyOfDocumentModelControllerNotificationsUserInfo:anElement}];
        
        [self.mElementsArray removeObject:anElement];
        
    }
}

- (NSArray<CHAbstractElement *> *)elementsArray
{
    return self.mElementsArray;
}


- (void)dealloc
{
    [_mElementsArray release];
    [super dealloc];
}

@end
