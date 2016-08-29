//
//  CHDocumentsWindowController.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/28/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHDocumentsWindowController.h"

@interface CHDocumentsWindowController ()<NSTableViewDelegate, NSTableViewDelegate>
@property (assign) IBOutlet NSTableView *documentsTable;
@end

@implementation CHDocumentsWindowController

- (instancetype)init
{
    return [self initWithWindowNibName:@"CHDocumentsWindowController"];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma mark fill table
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *result = nil;
//    
//    NSString *path = [self.mImagePathArray objectAtIndex:row];
//    if ([tableColumn.identifier isEqualToString:kCHLibraryTableImageCellIdentifier])
//    {
//        result = [tableView makeViewWithIdentifier:kCHLibraryTableImageCellIdentifier owner:self];
//        result.imageView.image = [[[NSImage alloc] initWithContentsOfFile:path] autorelease];
//    }
//    if ([tableColumn.identifier isEqualToString:kCHLibraryTableTitleCellIdentifier])
//    {
//        result = [tableView makeViewWithIdentifier:kCHLibraryTableTitleCellIdentifier owner:self];
//        result.textField.stringValue = path.lastPathComponent.stringByDeletingPathExtension;
//    }
    return result;
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return 0;
}



@end
