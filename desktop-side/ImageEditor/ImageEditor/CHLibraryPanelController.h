//
//  CHLibraryPanel.h
//  ImageEditor
//
//  Created by Владислав Яцун on 8/20/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@protocol CHLibraryPanelProtocol
- (void)addImage:(NSString *)imagePath;
@end

@interface CHLibraryPanelController : NSWindowController
{
    id <CHLibraryPanelProtocol> delegate;
}

@end
