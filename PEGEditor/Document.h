//
//  Document.h
//  PEGEditor
//
//  Created by Alexandre Cossette on 11-11-04.
//  Copyright (c) 2011 Alexandre Cossette. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <string>

@interface Document : NSDocument
{
    NSTextView *textView;
    std::string text;
}

@property (strong) IBOutlet NSTextView *textView;
@end
