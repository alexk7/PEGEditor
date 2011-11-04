//
//  Controller.m
//  PEGEditor
//
//  Created by Alexandre Cossette on 11-11-04.
//  Copyright (c) 2011 Alexandre Cossette. All rights reserved.
//

#import "Controller.h"

@implementation Controller

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSFontManager* fontManager = [NSFontManager sharedFontManager];
    NSFont* font = [NSFont userFixedPitchFontOfSize:0.0];
    [fontManager setSelectedFont:font isMultiple:NO];
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
    return NO;
}

@end
