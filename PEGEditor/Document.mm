//
//  Document.m
//  PEGEditor
//
//  Created by Alexandre Cossette on 11-11-04.
//  Copyright (c) 2011 Alexandre Cossette. All rights reserved.
//

#import "Document.h"
#include "PEGParser.h"

using namespace PEGParser;

static void CreateLink(NSTextStorage* _textStorage, const boost::uint32_t* _utf32Text, Iterator _iId)
{
    NSRange linkRange = { _iId->value - _utf32Text, _iId->length };
    NSString* linkText = [[_textStorage string] substringWithRange:linkRange];
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"peg://%@", linkText]];
    NSDictionary* linkAttribs = [NSDictionary dictionaryWithObjectsAndKeys:
                                 url, NSLinkAttributeName,
                                 [NSNumber numberWithInt:NSSingleUnderlineStyle], NSUnderlineStyleAttributeName,
                                 [NSColor blueColor], NSForegroundColorAttributeName,
                                 NULL];
    [_textStorage addAttributes:linkAttribs range:linkRange];
}

static void UpdateExprAttribs(NSTextStorage* _textStorage, const boost::uint32_t* _utf32Text, Iterator _iExpr)
{
    assert(_iExpr->type == SymbolType_Expression);
	
	for (Iterator iSeq = Traverse(_iExpr); iSeq->type == SymbolType_Sequence; ++iSeq)
	{
		for (Iterator iItem = Traverse(iSeq); iItem->type == SymbolType_Item; ++iItem)
		{
			/*char cPrefix = *iItem->value;
			if (cPrefix == '&')
			{
			}
			else if (cPrefix == '!')
			{
			}*/
			
			Iterator iPrimary = Traverse(iItem);
			assert(iPrimary->type == SymbolType_Primary);
			Iterator i = Traverse(iPrimary);
			if (i->type == SymbolType_Identifier)
			{
				CreateLink(_textStorage, _utf32Text, i);
			}
			else if (i->type == SymbolType_Expression)
			{
				UpdateExprAttribs(_textStorage, _utf32Text, i);
			}
            /*
			else if (i->type == SymbolType_LITERAL)
			{
				for (Iterator iChar = Traverse(i); iChar->type == SymbolType_Char; ++iChar)
				{
				}
			}
			else if (i->type == SymbolType_CLASS)
			{
				for (Iterator iRange = Traverse(i); iRange->type == SymbolType_Range; ++iRange)
				{
					Iterator iChar = Traverse(iRange);
					assert(iChar->type == SymbolType_Char);
					if ((++iChar)->type == SymbolType_Char)
					{
					}
				}
			}
			else //dot
			{
			}*/
			
			/*char cSuffix = iPrimary->value[iPrimary->length];
			if (cSuffix == '?')
			{
			}
			else if (cSuffix == '*')
			{
			}
			else if (cSuffix == '+')
			{
			}*/
        }
	}
}

static void UpdateAttributes(NSTextView* textView, std::map<std::string, NSInteger>& _locations)
{
    NSString* nsText = [textView string];
    NSTextStorage* textStorage = [textView textStorage]; 
    const boost::uint32_t* utf32Text = reinterpret_cast<const boost::uint32_t*>([nsText cStringUsingEncoding:NSUTF32StringEncoding]);
    PEGParser::Iterator iGrammar = Traverse(SymbolType_Grammar, utf32Text);
    bool success = iGrammar->success;
    
    NSUInteger textLength = [nsText length];
    [textView setTextColor:nil range:NSMakeRange(0, textLength)];
    if (!success)
    {
        NSUInteger parsedLength = iGrammar->length;
        [textView setTextColor:[NSColor redColor] range:NSMakeRange(parsedLength, textLength - parsedLength)];
    }
    
    _locations.clear();
	for (Iterator iDef = Traverse(iGrammar); iDef->type == SymbolType_Definition; ++iDef)
	{
		Iterator i = Traverse(iDef);
		assert(i->type == SymbolType_Identifier);
        _locations[[[nsText substringWithRange:NSMakeRange(i->value - utf32Text, i->length)] UTF8String]] = i->value - utf32Text;
        CreateLink(textStorage, utf32Text, i);
        ++i; //leftarrow
        UpdateExprAttribs(textStorage, utf32Text, ++i);
	}    
}

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
    UpdateAttributes(textView, locations);
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
    UpdateAttributes(textView, locations);
}

- (BOOL)textView:(NSTextView*)tV clickedOnLink:(id)link atIndex:(unsigned)charIndex
{
    if ([[link scheme] isEqualToString:@"peg"])
    {
        NSString* host = [link host];
        NSRange range = { locations[[host UTF8String]], [host length] };
        [textView scrollRangeToVisible:range];
        [textView showFindIndicatorForRange:range];
        return YES;
    }
    return NO;
}

@end
