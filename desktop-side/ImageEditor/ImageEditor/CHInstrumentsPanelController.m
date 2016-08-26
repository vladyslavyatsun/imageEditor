//
//  CHInstrumentsPanel.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/20/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHInstrumentsPanelController.h"
#import "CHDocumentWindowController.h"

@interface CHInstrumentsPanelController ()

@end

@implementation CHInstrumentsPanelController

- (instancetype) init
{
    return [super initWithWindowNibName:@"CHInstrumentsPanelController"];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (IBAction)selectPointer:(id)sender
{
    [self.currentDocumentWindowController setToolForDrawOnCanvas:kCHPointerTool];
}

- (IBAction)selectLine:(id)sender
{
    [self.currentDocumentWindowController setToolForDrawOnCanvas:kCHLineTool];
}

- (IBAction)selectRectangle:(id)sender
{
    [self.currentDocumentWindowController setToolForDrawOnCanvas:kCHRectangleTool];
}

- (IBAction)selectEllipse:(id)sender
{
    [self.currentDocumentWindowController setToolForDrawOnCanvas:kCHEllipseTool];
}

@end
