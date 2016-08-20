//
//  CHCanvasView.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/19/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHCanvasView.h"
#import "CHAbstractElement.h"

@interface CHCanvasView()
@property (nonatomic, assign) NSMutableArray *elements;
@property (nonatomic, readwrite, retain) CHAbstractElement *anElement;
@end

@implementation CHCanvasView


- (instancetype) initWithElements:(NSArray *)figures
{
    self = [super init];
    if(self)
    {
        _elements = [[NSMutableArray alloc]init];
        [_elements addObjectsFromArray:figures];
    }
    
    return self;
}





- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    
    [[NSColor whiteColor] set];
    
    NSRectFill(dirtyRect);
    
    NSLog(@"width  ------------ x %f ---------------- %f",dirtyRect.origin.x, dirtyRect.size.width);
    
    for (CHAbstractElement *figure in self.elements)
    {
        [figure draw];
    }
}


#pragma mark - mouse events
- (void)mouseDown:(NSEvent *)event
{
    
    NSPoint locationInView = [self convertPoint:event.locationInWindow fromView:nil];
    
    //CHAbstractElement *figure = (CHAbstractElement *)[[CHAbstractElement lineWithInitialPoint:locationInView] retain];
    
    if (self.anElement != nil)
    {
        self.anElement.color = [NSColor redColor];
        self.anElement.thickness = 4.0;
        [self.elements addObject:self.anElement];
    
        [self.anElement release];
    }
    else
    {
        for (CHAbstractElement *element in self.elements)
        {
            BOOL containsInView = [element.path containsPoint:locationInView];
            NSLog(@" >>>>> %d", containsInView);
        }
    }
    
    
    [self setNeedsDisplay:YES];
}

- (void)mouseDragged:(NSEvent *)event
{
    NSPoint locationInView = [self convertPoint:event.locationInWindow fromView:nil];
    
    CHAbstractElement *figure = [self.elements lastObject];
    [figure addPoint:locationInView];
    
    [self setNeedsDisplay:YES];
    
}

- (BOOL)isOpaque
{
    return YES;
}


#warning - test method
- (NSMutableArray *)elements
{
    if(!_elements)
    {
        _elements = [[NSMutableArray alloc]init];
    }
    return _elements;
}

@end
