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
@property (assign) IBOutlet NSButton *pointerButton;
@property (assign) IBOutlet NSButton *ellipseButton;
@property (assign) IBOutlet NSButton *lineButton;
@property (assign) IBOutlet NSButton *rectangleButton;
@property (assign) NSButton *selectedInstrument;
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
    self.selectedInstrument.state = 0;
    self.selectedInstrument = self.pointerButton;
    self.pointerButton.state = 1;
}

- (IBAction)selectLine:(id)sender
{
    [self.currentDocumentWindowController setToolForDrawOnCanvas:kCHLineTool];
    self.selectedInstrument.state = 0;
    self.selectedInstrument = self.lineButton;
    self.lineButton.state = 1;
}

- (IBAction)selectRectangle:(id)sender
{
    [self.currentDocumentWindowController setToolForDrawOnCanvas:kCHRectangleTool];
    self.selectedInstrument.state = 0;
    self.selectedInstrument = self.rectangleButton;
    self.rectangleButton.state = 1;
}

- (IBAction)selectEllipse:(id)sender
{
    [self.currentDocumentWindowController setToolForDrawOnCanvas:kCHEllipseTool];
    self.selectedInstrument.state = 0;
    self.selectedInstrument = self.ellipseButton;
    self.ellipseButton.state = 1;
}

@end
