//
//  CHLibraryPanel.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/20/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHLibraryPanelController.h"
#import "CHDocumentWindowController.h"

NSString * const kCHResourcesDirectoryName = @"images";
NSString * const kCHLibraryTableImageCellIdentifier = @"image";
NSString * const kCHLibraryTableTitleCellIdentifier = @"title";
@interface CHLibraryPanelController ()<NSTableViewDataSource, NSTableViewDelegate>
@property (assign) IBOutlet NSTableView *libraryTable;
@property (nonatomic, retain) NSMutableArray<NSString *> *mImagePathArray;
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
    
    [self.window registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
    
    [self.libraryTable setDraggingSourceOperationMask:NSDragOperationLink forLocal:NO];
    [self.libraryTable setDraggingSourceOperationMask:NSDragOperationMove forLocal:YES];
    [self.libraryTable registerForDraggedTypes:[NSArray arrayWithObject:NSTIFFPboardType]];
}

- (void)loadImages
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    [self.mImagePathArray addObjectsFromArray:[mainBundle pathsForResourcesOfType:@"png" inDirectory:kCHResourcesDirectoryName]];
}


#pragma mark fill table
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *result = nil;
    
    NSString *path = [self.mImagePathArray objectAtIndex:row];
    if ([tableColumn.identifier isEqualToString:kCHLibraryTableImageCellIdentifier])
    {
        result = [tableView makeViewWithIdentifier:kCHLibraryTableImageCellIdentifier owner:self];
        result.imageView.image = [[NSImage alloc] initWithContentsOfFile:path];
    }
    if ([tableColumn.identifier isEqualToString:kCHLibraryTableTitleCellIdentifier])
    {
        result = [tableView makeViewWithIdentifier:kCHLibraryTableTitleCellIdentifier owner:self];
        result.textField.stringValue = path.lastPathComponent.stringByDeletingPathExtension;
    }
    return result;
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.mImagePathArray.count;
}

- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard
{
    BOOL result = NO;
        
    NSInteger row = [rowIndexes firstIndex];
    
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:self.mImagePathArray[row]];
    
    if (image)
    {
        NSData *data = [image TIFFRepresentation];
        [pboard setData:data forType:NSTIFFPboardType];
        
        result = YES;
    }
    
    [image release];
    
    return result;
}

- (void)tableView:(NSTableView *)tableView draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint forRowIndexes:(NSIndexSet *)rowIndexes
{
    [session enumerateDraggingItemsWithOptions:NSDraggingItemEnumerationConcurrent forView:nil classes:@[[NSImage class]] searchOptions:@{} usingBlock:
     ^(NSDraggingItem *draggingItem, NSInteger index, BOOL *stop)
    {
        NSUInteger selectedRow = rowIndexes.firstIndex;
        
        NSImage *image = [[[NSImage alloc] initWithContentsOfFile:self.mImagePathArray[selectedRow]] autorelease];
        
        [draggingItem setDraggingFrame:NSMakeRect(session.draggingLocation.x - (image.size.width / 2), session.draggingLocation.y - (image.size.height / 2), image.size.width, image.size.height) contents:image];
    }];
}


- (IBAction)onTableDoubleClickAction:(NSTableView *)sender
{
    NSInteger row = sender.selectedRow;
    if (row > -1)
    {
        [self.currentDocumentWindowController addImageOnViewWithInitialPoint:NSZeroPoint path:self.mImagePathArray[row]];
    }
}


- (void)dealloc
{
    [super dealloc];
}
@end
