//
//  CHDocumentWindowController.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/21/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHDocumentWindowController.h"
#import "CHCanvasView.h"
#import "CHAbstractElementRepresentation.h"
#import "CHAbstractElement.h"

@interface CHDocumentWindowController ()
@property (nonatomic, retain) CHCanvasView *documentView;
@end

@implementation CHDocumentWindowController

- (instancetype)init
{
    self = [super initWithWindowNibName:@"CHDocument"];
    if (self)
    {
        _documentView = [[CHCanvasView alloc] init];
        [self.window setContentView:self.documentView];
    }
    
    return self;
}

- (void)windowDidLoad
{
   
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}


- (void)addImageOnViewWithInitialPoint:(NSPoint)aPoint path:(NSString *)aPath
{
    NSImage *image = [[[NSImage alloc] initWithContentsOfFile:aPath] autorelease];
    NSPoint point = NSMakePoint(300, 300);
    
    CHAbstractElement *baseElement = (CHAbstractElement *)[[CHAbstractElement imageWithStartPoint:aPoint endPoint:point image:image] retain] ;
    
    CHAbstractElementRepresentation *element = (CHAbstractElementRepresentation *)[CHAbstractElementRepresentation elementRepresentationWithModelElement:baseElement];
    [self.documentView addElementOnView:element];
}

- (void)dealloc
{
    [_documentView release];
    [super dealloc];
}

@end
