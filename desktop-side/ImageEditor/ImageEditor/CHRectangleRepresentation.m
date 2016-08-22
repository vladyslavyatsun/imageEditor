//
//  CHRectangleRepresentation.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/22/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHRectangleRepresentation.h"

@implementation CHRectangleRepresentation
- (instancetype)initWithModelElement:(CHAbstractElement *)modelElement
{
    self = [super initWithModelElement:modelElement];
    
    if (self)
    {
        self.bezierPath = [NSBezierPath bezierPathWithRect:self.rect];
    }
    
    return self;
}
@end
