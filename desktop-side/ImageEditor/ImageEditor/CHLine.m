//
//  CHLine.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/19/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHLine.h"

@implementation CHLine

- (void)addPoint:(NSPoint)point
{
    [self.path removeAllPoints];
    [self.path moveToPoint:self.initialPoint];
    [self.path lineToPoint:point];
}



@end
