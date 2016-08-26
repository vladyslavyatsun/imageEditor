//
//  CHDocumentModelController.h
//  ImageEditor
//
//  Created by Владислав Яцун on 8/22/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CHAbstractElement;

extern NSString * const kCHDocumentModelControllerDidAddElement;
extern NSString * const kCHDocumentModelControllerDidRemoveElememt;
extern NSString * const kCHKeyOfDocumentModelControllerNotificationsUserInfo;

@interface CHDocumentModelController : NSObject
@property (nonatomic, readonly) NSArray<CHAbstractElement *> *elementsArray;

- initWithElementsArray:(NSArray<CHAbstractElement *> *)elementsArray;

- (void)addElement:(CHAbstractElement *)anElement;
- (void)removeElement:(CHAbstractElement *)anElement;

@end
