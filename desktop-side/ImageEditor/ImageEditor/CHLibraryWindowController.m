//
//  CHLibraryPanel.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/20/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHLibraryWindowController.h"
#import "CHDocumentWindowController.h"
#import "CHLibraryModelController.h"
#import "CHLibraryImage.h"

NSString * const kCHLibraryTableImageCellIdentifier = @"image";
NSString * const kCHLibraryTableTitleCellIdentifier = @"title";
@interface CHLibraryWindowController ()<NSTableViewDataSource>
@property (assign) IBOutlet NSTableView *libraryTable;
@property (nonatomic, retain) CHLibraryModelController *libraryModelController;
@end

@implementation CHLibraryWindowController

- (instancetype) init
{
    self = [super initWithWindowNibName:@"CHLibraryWindowController"];
    
    if (self)
    {
        _libraryModelController = [[CHLibraryModelController alloc] init];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [self.libraryModelController loadImagesWithTypes:[NSImage imageTypes]];
    
    [self.window registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
    
    [self.libraryTable registerForDraggedTypes:[NSArray arrayWithObjects:NSURLPboardType, NSFilenamesPboardType, nil]];
    [self.libraryTable setDraggingSourceOperationMask:NSDragOperationLink forLocal:NO];
}


- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id<NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation
{
    NSPasteboard* pboard = [info draggingPasteboard];
    NSURL *url = [NSURL URLFromPasteboard:pboard];
    NSImage *imageFile = nil;
    
    if (url)
    {
        imageFile = [[NSImage alloc] initWithContentsOfURL:url];
    }
    
    if (imageFile)
    {
        NSString *imageTitle = url.lastPathComponent;
        NSURL *imageURL = [NSURL fileURLWithPath:imageTitle relativeToURL:url];
        CHLibraryImage *image = [[CHLibraryImage alloc] initWithTitle:imageTitle.stringByDeletingPathExtension url:imageURL readOnly:NO];
        NSImage *imageData = [[NSImage alloc] initWithContentsOfFile:image.url.path];
        NSData *imageBinaryData = imageData.TIFFRepresentation;
        
        if ([self.libraryModelController loadImageData:imageBinaryData withFileName:url.lastPathComponent])
        {
            image.url = [NSURL fileURLWithPath:[self.libraryModelController.applicationSupportPath stringByAppendingPathComponent:imageTitle]];
            [self.libraryModelController addImageInLibrary:image withIndex:row];
        }
        
        [image release];
        [imageData release];
        [imageFile release];
    }
    
    return YES;
}


- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation
{
    NSDragOperation result = NSDragOperationNone;
    
    if ([info draggingSource] != self)
    {
        result = NSDragOperationCopy;
    }
    
    return result;
}


- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard
{
    BOOL result = NO;
        
    NSInteger row = [rowIndexes firstIndex];
    
    NSURL *imageUrl = [self.libraryModelController imageWithIndex:row].url;
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:imageUrl];
    
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
        
        NSURL *imageUrl = [self.libraryModelController imageWithIndex:selectedRow].url;
        NSImage *image = [[[NSImage alloc] initWithContentsOfURL:imageUrl] autorelease];
        
        [draggingItem setDraggingFrame:NSMakeRect(session.draggingLocation.x - (image.size.width / 2), session.draggingLocation.y - (image.size.height / 2), image.size.width, image.size.height) contents:image];
    }];
}


- (IBAction)onTableDoubleClickAction:(NSTableView *)sender
{
    NSInteger row = sender.selectedRow;
    if (row > -1)
    {
        NSURL *imageUrl = [self.libraryModelController imageWithIndex:row].url;
        [self.currentDocumentWindowController addImageOnViewWithInitialPoint:NSZeroPoint path:imageUrl];
    }
}


- (void)dealloc
{
    [_libraryModelController release];
    [super dealloc];
}
@end
