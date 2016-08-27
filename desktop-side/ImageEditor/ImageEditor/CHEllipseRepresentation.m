//
//  CHEllipseRepresentation.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/22/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHEllipseRepresentation.h"

@implementation CHEllipseRepresentation

- (void)draw
{
     self.bezierPath = [NSBezierPath bezierPathWithOvalInRect:self.rect];
    [super draw];
}
@end
