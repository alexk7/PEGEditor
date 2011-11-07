//
//  Document.m
//  PEGEditor
//
//  Created by Alexandre Cossette on 11-11-04.
//  Copyright (c) 2011 Alexandre Cossette. All rights reserved.
//

#import "Document.h"
#include "PEGParser.h"

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
    PEGParser::Iterator i = PEGParser::Traverse(PEGParser::SymbolType_Grammar, text.c_str());
    bool success = i->success;
    
    size_t textLength = text.size();
    [textView setTextColor:nil range:NSMakeRange(0, textLength)];
    if (!success)
    {
        size_t parsedLength = i->length;
        [textView setTextColor:[NSColor redColor] range:NSMakeRange(parsedLength, textLength - parsedLength)];
    }
}

@end
