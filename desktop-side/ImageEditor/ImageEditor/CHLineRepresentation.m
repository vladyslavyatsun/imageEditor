//
//  CHLineRepresentation.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/22/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHLineRepresentation.h"
#import "CHAbstractElement.h"

@implementation CHLineRepresentation
- (instancetype)initWithModelElement:(CHAbstractElement *)modelElement
{
    self = [super initWithModelElement:modelElement];
    
    if (self)
    {
        self.bezierPath = [NSBezierPath bezierPath];
        [self.bezierPath moveToPoint:modelElement.startPoint];
        [self.bezierPath lineToPoint:modelElement.endPoint];
    }
    
    return self;
}
@end
