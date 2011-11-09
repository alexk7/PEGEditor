//
//  Document.h
//  PEGEditor
//
//  Created by Alexandre Cossette on 11-11-04.
//  Copyright (c) 2011 Alexandre Cossette. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <string>
#include <map>

typedef std::map<std::string, NSInteger> Locations;

@interface Document : NSDocument
{
    NSTextView *textView;
    std::string text;
    Locations locations;
}

@property (strong) IBOutlet NSTextView *textView;
@end
