//
//  CHLibraryImage.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/29/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHLibraryImage.h"

@implementation CHLibraryImage
- (instancetype)initWithTitle:(NSString *)title url:(NSURL *)url readOnly:(BOOL)readOnly
{
    self = [super init];
    if (self)
    {
        _title = [title copy];
        _url = [url copy];
        _readOnly = readOnly;
    }
    return self;
}


- (void)setTitle:(NSString *)title
{
    if (![self isReadOnly] && _title != title)
    {
        NSError *renameError = nil;
        
        NSString *titleWithoutSpaces = [title stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSURL *newURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", _url.absoluteString.stringByDeletingLastPathComponent, titleWithoutSpaces]];
        [[NSFileManager defaultManager] moveItemAtURL:_url toURL:newURL error:&renameError];
        
        if (!renameError)
        {
            [_title release];
            _title = [titleWithoutSpaces copy];
            [_url release];
            _url = [newURL copy];
        }
    }
}


- (void)dealloc
{
    [_title release];
    [_url release];
    [super dealloc];
}
@end
