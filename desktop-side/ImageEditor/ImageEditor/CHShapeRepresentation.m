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
        _bezierPath = [[NSBezierPath bezierPath] retain];
    }
    return self;
}


- (void)reloadRepresentation:(NSNotification *)notification
{
    CHShape *modelElement = notification.object;
    
    self.color = modelElement.color;
}

- (BOOL)hitTest:(NSPoint)aPoint
{
    return [self.bezierPath containsPoint:aPoint];
}

- (void)draw
{
    [self.color set];
    [self.bezierPath stroke];
}

- (void)dealloc
{
    [_color release];
    [_bezierPath release];
    [super dealloc];
}

@end
