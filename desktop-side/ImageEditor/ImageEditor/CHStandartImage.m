//
//  CHStandartImage.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/20/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHStandartImage.h"

@implementation CHStandartImage
- (instancetype)initWithPath:(NSString *)path withTitle:(NSString *)title
{
    self = [super init];
    if (self)
    {
        _path = path;
        _title = title;
    }
    return self;
}
@end
