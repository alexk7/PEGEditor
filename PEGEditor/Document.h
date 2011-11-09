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

@interface Document : NSDocument
{
    NSTextView *textView;
    std::string text;
    std::map<std::string, NSInteger> locations;
}

@property (strong) IBOutlet NSTextView *textView;
@end
