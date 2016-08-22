//
//  CHAbstractElementRepresentation.h
//  ImageEditor
//
//  Created by Владислав Яцун on 8/22/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class CHAbstractElement;

@interface CHAbstractElementRepresentation : NSObject
//@property (nonatomic, assign) CHAbstractElement *modelElement;
@property (nonatomic, assign) NSRect rect;
@property (nonatomic, getter=isSelected) BOOL select;

- (instancetype)initWithModelElement:(CHAbstractElement *)modelElement;
- (void)reloadRepresentation:(NSNotification *)notification;

+ (CHAbstractElementRepresentation *)elementRepresentationWithModelElement:(CHAbstractElement *)modelElement;
- (void)draw;
- (BOOL)hitTest:(NSPoint)aPoint;

@end
