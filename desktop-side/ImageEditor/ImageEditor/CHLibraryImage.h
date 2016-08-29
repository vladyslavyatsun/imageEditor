//
//  CHLibraryImage.h
//  ImageEditor
//
//  Created by Владислав Яцун on 8/29/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHLibraryImage : NSObject
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, readwrite, getter=isReadOnly) BOOL readOnly;

- (instancetype)initWithTitle:(NSString *)title url:(NSURL *)url readOnly:(BOOL)readOnly;
@end
