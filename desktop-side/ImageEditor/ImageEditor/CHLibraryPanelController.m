//
//  CHLibraryPanel.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/20/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHLibraryPanelController.h"

#warning - 1
// gavno!!! panel doesn`t know about document
#import "CHDocumentWindowController.h"

NSString * const kCHImageIdentifier = @"image";
NSString * const kCHTitleIdentifier = @"title";
NSString * const kCHResourcesDirectoryName = @"image";

@interface CHLibraryPanelController ()
@property (nonatomic, retain) NSMutableArray *mImagePathArray;
@end

@implementation CHLibraryPanelController

- (instancetype) init
{
    self = [super initWithWindowNibName:@"CHLibraryPanelController"];
    
    if (self)
    {
        
        _mImagePathArray = [[NSMutableArray alloc] init];
        [self loadImages];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)loadImages
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    [self.mImagePathArray addObjectsFromArray:[mainBundle pathsForResourcesOfType:@"png" inDirectory:@"image"]];
}



- (IBAction)onTableDoubleClickAction:(NSTableView *)sender
{
    NSInteger row = sender.selectedRow;
    if (row > -1)
    {
        NSDocument *curentDocument = [NSDocumentController sharedDocumentController].currentDocument;
        CHDocumentWindowController *documentWindow = curentDocument.windowControllers.lastObject;
        
        [documentWindow addImageOnViewWithInitialPoint:NSZeroPoint path:self.mImagePathArray[row]];
    }
}


- (void)dealloc
{
    [super dealloc];
}
@end
