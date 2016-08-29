//
//  CHInspectorPanel.h
//  ImageEditor
//
//  Created by Владислав Яцун on 8/20/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class CHAbstractElementRepresentation;

@interface CHInspectorWindowController : NSWindowController
@property (nonatomic, assign) CHAbstractElementRepresentation *selectedElement;
@end
