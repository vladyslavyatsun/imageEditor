//
//  CHDocumentModelController.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/22/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHDocumentModelController.h"
#import "CHAbstractElement.h"

NSString * const kCHDocumentModelDidAddElement = @"element added";
NSString * const kCHDocumentModelDidRemoveElememt = @"element removed";
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


- (void)addElement:(CHAbstractElement *)anElement;
{
    if (anElement)
    {
        [self.mElementsArray addObject:anElement];
        [[NSNotificationCenter defaultCenter] postNotificationName:kCHDocumentModelDidAddElement
                                                            object:self
                                                          userInfo:@{@"element":anElement}];
    }
}

- (void)removeElement:(CHAbstractElement *)anElement
{
    if ([self.mElementsArray containsObject:anElement])
    {
        [self.mElementsArray removeObject:anElement];
        [[NSNotificationCenter defaultCenter] postNotificationName:kCHDocumentModelDidRemoveElememt
                                                            object:self
                                                          userInfo:@{@"element":anElement}];
    }
}

- (NSArray<CHAbstractElement *> *)elementsArray
{
    return self.mElementsArray;
}

@end
