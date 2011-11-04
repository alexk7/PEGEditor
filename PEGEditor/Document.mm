//
//  Document.m
//  PEGEditor
//
//  Created by Alexandre Cossette on 11-11-04.
//  Copyright (c) 2011 Alexandre Cossette. All rights reserved.
//

#import "Document.h"

@implementation Document
@synthesize textView;

- (NSString *)windowNibName
{
    return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    [textView setString: [NSString stringWithUTF8String:text.c_str()]];
    [textView setFont: [[NSFontManager sharedFontManager] selectedFont]];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    return [NSData dataWithBytes:text.data() length:text.size()];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    text = static_cast<const char*>([data bytes]);
    return YES;
}

- (void)textDidChange: (NSNotification *) notification
{
    text = [[textView string] UTF8String];
}

@end
