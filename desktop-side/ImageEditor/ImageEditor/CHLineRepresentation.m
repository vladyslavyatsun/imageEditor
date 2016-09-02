//
//  CHLineRepresentation.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/22/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHLineRepresentation.h"
#import "CHAbstractElement.h"

@interface CHLineRepresentation()
@property (nonatomic, assign) BOOL lineInversion;
@end
@implementation CHLineRepresentation

- (instancetype)initWithModelElement:(CHAbstractElement *)modelElement
{
    self = [super initWithModelElement:modelElement];
    if (self)
    {
        self.rect = [self rectForLine];
    }
    return self;
}

- (void)reloadRepresentation:(NSNotification *)notification
{
    self.rect = [self rectForLine];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCHElementRepresentationDidUpdate object:self];
}

- (CGRect)rectForLine
{
    CGFloat x;
    CGFloat y;
    CGFloat width;
    CGFloat height;
    
    if (self.modelElement.endPoint.x >= self.modelElement.startPoint.x)
    {
        x = self.modelElement.startPoint.x;
        width = self.modelElement.endPoint.x - self.modelElement.startPoint.x;
    }
    else
    {
        x = self.modelElement.endPoint.x;
        width = self.modelElement.startPoint.x - self.modelElement.endPoint.x;
        self.lineInversion = YES;
    }
    
    if (self.modelElement.endPoint.y >= self.modelElement.startPoint.y)
    {
        y = self.modelElement.startPoint.y;
        height = self.modelElement.endPoint.y - self.modelElement.startPoint.y;
    }
    else
    {
        y = self.modelElement.endPoint.y;
        height = self.modelElement.startPoint.y - self.modelElement.endPoint.y;
        self.lineInversion = YES;
    }
    return NSMakeRect(x, y, width, height);
}

- (void)updateModelElement
{
    NSPoint startPoint;
    NSPoint endPoint;
    if (self.lineInversion)
    {
        startPoint = NSMakePoint(self.rect.origin.x, self.rect.origin.y + self.rect.size.height);
        endPoint = NSMakePoint(self.rect.origin.x + self.rect.size.width, self.rect.origin.y);
    }
    else
    {
        startPoint = NSMakePoint(self.rect.origin.x, self.rect.origin.y);
        endPoint = NSMakePoint(self.rect.origin.x + self.rect.size.width, self.rect.origin.y + self.rect.size.height);
    }
    
    [self.modelElement setStartPoint:startPoint];
    [self.modelElement setEndPoint:endPoint];

}

- (void)draw
{
    self.bezierPath = [NSBezierPath bezierPath];
    [self.bezierPath moveToPoint:self.modelElement.startPoint];
    [self.bezierPath lineToPoint:self.modelElement.endPoint];
    [super draw];
}

- (void)addPoint:(NSPoint)aPoint
{
    if (self.initialPoint.x)
    {
        self.modelElement.endPoint = aPoint;
    }
    else
    {
        [self.modelElement setStartPoint:aPoint];
        self.initialPoint = aPoint;
    }
}



@end
