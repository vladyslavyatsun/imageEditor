//
//  CHEllipseRepresentation.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/22/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHEllipseRepresentation.h"

@implementation CHEllipseRepresentation
- (instancetype)initWithModelElement:(CHAbstractElement *)modelElement
{
    self = [super initWithModelElement:modelElement];
    
    if (self)
    {
        self.bezierPath = [NSBezierPath bezierPathWithOvalInRect:self.rect];
    }
    
    return self;
}
@end
