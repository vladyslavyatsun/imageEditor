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

- (void)setOriginX:(CGFloat)x forElement:(CHAbstractElementRepresentation *)element
{
    [[self.undoManager prepareWithInvocationTarget:self] setOriginX:element.rect.origin.x forElement:self.selectedElement];
    
    [element moveToPoint:NSMakePoint(x, element.rect.origin.y)];
}

- (void)setOriginX:(CGFloat)originX
{
    [self setOriginX:originX forElement:self.selectedElement];
}

- (CGFloat)originY
{
    return self.selectedElement.rect.origin.y;
}

- (void)setOriginY:(CGFloat)y forElement:(CHAbstractElementRepresentation *)element
{
    [[self.undoManager prepareWithInvocationTarget:self] setOriginY:element.rect.origin.y forElement:self.selectedElement];
    
    [element moveToPoint:NSMakePoint(element.rect.origin.x, y)];
}

- (void)setOriginY:(CGFloat)originY
{
    [self setOriginY:originY forElement:self.selectedElement];
}

- (CGFloat)width
{
    return self.selectedElement.rect.size.width;
}

- (void)setWidth:(CGFloat)width forElement:(CHAbstractElementRepresentation *)element
{
    [[self.undoManager prepareWithInvocationTarget:self] setWidth:element.rect.size.width forElement:self.selectedElement];
    
    [element setNewWidth:width];
}

- (void)setWidth:(CGFloat)width
{
    [self setWidth:width forElement:self.selectedElement];
}

- (CGFloat)height
{
    return self.selectedElement.rect.size.height;
}

- (void)setHeight:(CGFloat)height forElement:(CHAbstractElementRepresentation *)element
{
    [[self.undoManager prepareWithInvocationTarget:self] setHeight:element.rect.size.height forElement:self.selectedElement];
    
    [element setNewWidth:height];
}

- (void)setHeight:(CGFloat)height
{
    [self setHeight:height forElement:self.selectedElement];
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

- (NSUndoManager *)undoManager
{
    return [NSDocumentController sharedDocumentController].currentDocument.undoManager;
}

- (void)dealloc
{
 //   [NSApp removeObserver:self forKeyPath:kCHSelectedElementPath];
    [super dealloc];
}

@end
