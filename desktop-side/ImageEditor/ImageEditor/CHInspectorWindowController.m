//
//  CHInspectorPanel.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/20/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHInspectorWindowController.h"
#import "CHAbstractElementRepresentation.h"

@interface CHInspectorWindowController ()
@property (nonatomic, assign) CGFloat originX;
@property (nonatomic, assign) CGFloat originY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@end

@implementation CHInspectorWindowController
- (instancetype) init
{
    return [super initWithWindowNibName:@"CHInspectorWindowController"];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}


#pragma mark getters & setters

- (CGFloat)originX
{
    return self.selectedElement.rect.origin.x;
}

- (void)setOriginX:(CGFloat)originX
{
    [self.selectedElement moveToPoint:NSMakePoint(originX, self.originY)];
}

- (CGFloat)originY
{
    return self.selectedElement.rect.origin.y;
}

- (void)setOriginY:(CGFloat)originY
{
    [self.selectedElement moveToPoint:NSMakePoint(self.originX, originY)];
}

- (CGFloat)width
{
    return self.selectedElement.rect.size.width;
}

- (void)setWidth:(CGFloat)width
{
    [self.selectedElement setNewWidth:width];
}

- (CGFloat)height
{
    return self.selectedElement.rect.size.height;
}

- (void)setHeight:(CGFloat)height
{
    [self.selectedElement setNewHeight:height];
}


+ (NSSet *)keyPathsForValuesAffectingOriginX
{
    return [NSSet setWithObject:@"selectedElement.rect"];
}

+ (NSSet *)keyPathsForValuesAffectingOriginY
{
    return [NSSet setWithObject:@"selectedElement.rect"];
}

+ (NSSet *)keyPathsForValuesAffectingWidth
{
    return [NSSet setWithObject:@"selectedElement.rect"];
}

+ (NSSet *)keyPathsForValuesAffectingHeight
{
    return [NSSet setWithObject:@"selectedElement.rect"];
}

- (void)dealloc
{
 //   [NSApp removeObserver:self forKeyPath:kCHSelectedElementPath];
    [super dealloc];
}

@end
