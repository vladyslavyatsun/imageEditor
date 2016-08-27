//
//  CHRectangleRepresentation.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/22/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHRectangleRepresentation.h"

@implementation CHRectangleRepresentation

- (void)draw
{
    self.bezierPath = [NSBezierPath bezierPathWithRect:self.rect];
    [super draw];
}
@end
