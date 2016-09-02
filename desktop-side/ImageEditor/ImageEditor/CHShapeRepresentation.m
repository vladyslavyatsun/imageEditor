//
//  CHShapeRepresentation.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/22/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHShapeRepresentation.h"
#import "CHShape.h"

@implementation CHShapeRepresentation


- (instancetype)initWithModelElement:(CHAbstractElement *)modelElement
{
    self = [super initWithModelElement:modelElement];
    
    if (self)
    {
        _color = ((CHShape *)modelElement).color;
        _initialPoint = self.modelElement.startPoint;
    }
    return self;
}


- (void)reloadRepresentation:(NSNotification *)notification
{
    CHShape *modelElement = notification.object;
    self.color = modelElement.color;
    [super reloadRepresentation:notification];
}


- (void)addPoint:(NSPoint)aPoint
{
        NSPoint newStartPoint = self.modelElement.startPoint;
        NSPoint newEndPoint = self.modelElement.endPoint;
        
        
        if (aPoint.x >= self.initialPoint.x)
        {
            newStartPoint.x = self.initialPoint.x;
            newEndPoint.x = aPoint.x;
        }
        else
        {
            newStartPoint.x = aPoint.x;
            newEndPoint.x = self.initialPoint.x;
        }
    
        if (aPoint.y >= self.initialPoint.y)
        {
            newStartPoint.y = self.initialPoint.y;
            newEndPoint.y = aPoint.y;
        }
        else
        {
            newStartPoint.y = aPoint.y;
            newEndPoint.y = self.initialPoint.y;
        }
    
        [self.modelElement setStartPoint:newStartPoint];
        [self.modelElement setEndPoint:newEndPoint];
}

- (void)draw
{
    [self.color set];

    if ([self isSelected])
    {
        [NSGraphicsContext saveGraphicsState];
        NSSetFocusRingStyle(NSFocusRingAbove);
        [self.bezierPath stroke];
        [NSGraphicsContext restoreGraphicsState];
    }
    else
    {
        [self.bezierPath stroke];
    }
}

- (void)dealloc
{
    [_color release];
    [_bezierPath release];
    [super dealloc];
}

@end
