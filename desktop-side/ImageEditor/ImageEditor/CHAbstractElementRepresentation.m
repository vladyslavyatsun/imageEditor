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


NSString * const kCHElementRepresentationDidUpdate = @"element representation update";
@implementation CHAbstractElementRepresentation 

- (instancetype)initWithModelElement:(CHAbstractElement *)modelElement
{
    self = [super init];
    
    if (self)
    {
        _modelElement = [modelElement retain];
        _rect = NSMakeRect(modelElement.startPoint.x,
                           modelElement.startPoint.y,
                           modelElement.endPoint.x - modelElement.startPoint.x,
                           modelElement.endPoint.y - modelElement.startPoint.y);
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadRepresentation:)
                                                     name:kCHAbstractElementDidUpdate
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCHElementRepresentationDidUpdate object:self];
}

- (BOOL)hitTest:(NSPoint)aPoint
{
    return NSPointInRect(aPoint, self.rect);
}

- (void)moveToPoint:(NSPoint)aPoint
{
    self.rect = NSMakeRect(aPoint.x, aPoint.y, self.rect.size.width, self.rect.size.height);
    
    [self updateModelElement];
    
    [self didChangeValueForKey:@"rect"];
}

- (void)setNewWidth:(CGFloat)aWidth
{
    self.rect = NSMakeRect(self.rect.origin.x, self.rect.origin.y, aWidth, self.rect.size.height);
    
    [self updateModelElement];
    
    [self didChangeValueForKey:@"rect"];
}

- (void)setNewHeight:(CGFloat)aHeight
{
    self.rect = NSMakeRect(self.rect.origin.x, self.rect.origin.y, self.rect.size.width, aHeight);
    
    [self updateModelElement];

    [self didChangeValueForKey:@"rect"];
}

- (void)updateModelElement
{
    NSPoint startPoint = NSMakePoint(self.rect.origin.x, self.rect.origin.y);
    NSPoint endPoint = NSMakePoint(self.rect.size.width + startPoint.x, self.rect.size.height + startPoint.y);
    [self.modelElement setStartPoint:startPoint];
    [self.modelElement setEndPoint:endPoint];
}

- (void)pasteboard:(NSPasteboard *)pasteboard item:(NSPasteboardItem *)item provideDataForType:(NSString *)type
{
    if ([type compare:(NSString *)kUTTypeImage] == NSOrderedSame)
    {
        if (self.modelElement)
        {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.modelElement];
            [pasteboard setData:data forType:(NSString *)kUTTypeImage];
            NSLog(@"");
        }
    }
}


- (void)draw
{
    NSLog(@"owerwrite this method");
}

- (void)dealloc
{
    [_modelElement release];
    [super dealloc];
}

@end
