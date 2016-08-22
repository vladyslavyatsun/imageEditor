//
//  CHAbstractElementRepresentation.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/22/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHAbstractElementRepresentation.h"
#import "CHAbstractElement.h"
#import "CHImageRepresentation.h"
#import "CHLineRepresentation.h"
#import "CHRectangleRepresentation.h"
#import "CHEllipseRepresentation.h"

#import "CHLine.h"
#import "CHRectangle.h"
#import "CHEllipse.h"
#import "CHImage.h"

@implementation CHAbstractElementRepresentation

- (instancetype)initWithModelElement:(CHAbstractElement *)modelElement
{
    self = [super init];
    
    if (self)
    {
//        _modelElement = [modelElement retain];
        _rect = NSMakeRect(modelElement.startPoint.x,
                           modelElement.startPoint.y,
                           modelElement.endPoint.x - modelElement.startPoint.x,
                           modelElement.endPoint.y - modelElement.startPoint.y);
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadRepresentation:)
                                                     name:kCHElementDidUpdate
                                                   object:modelElement];
    }
    
    return self;
}

+ (CHAbstractElementRepresentation *)elementRepresentationWithModelElement:(CHAbstractElement *)modelElement
{
    CHAbstractElementRepresentation *result = nil;
    
    if ([modelElement isKindOfClass:[CHImage class]])
    {
        result = [[[CHImageRepresentation alloc] initWithModelElement:modelElement] autorelease];
    }
    
    if ([modelElement isKindOfClass:[CHLine class]])
    {
        result = [[[CHLineRepresentation alloc] initWithModelElement:modelElement] autorelease];
    }
    
    if ([modelElement isKindOfClass:[CHRectangle class]])
    {
        result = [[[CHRectangleRepresentation alloc] initWithModelElement:modelElement] autorelease];
    }
    
    if ([modelElement isKindOfClass:[CHEllipse class]])
    {
        result = [[[CHEllipseRepresentation alloc] initWithModelElement:modelElement] autorelease];
    }
    
    return result;
}

- (void)reloadRepresentation:(NSNotification *)notification
{
    CHAbstractElement *modelElement = notification.object;
    
    self.rect = NSMakeRect(modelElement.startPoint.x,
                       modelElement.startPoint.y,
                       modelElement.endPoint.x - modelElement.startPoint.x,
                       modelElement.endPoint.y - modelElement.startPoint.y);
}

- (BOOL)hitTest:(NSPoint)aPoint
{
    return NSPointInRect(aPoint, self.rect);
}

- (void)draw
{
    NSLog(@"owerwrite thih method");
}

@end
