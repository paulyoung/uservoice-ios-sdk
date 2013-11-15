//
//  UVForum.m
//  UserVoice
//
//  Created by UserVoice on 11/23/09.
//  Copyright 2009 UserVoice Inc. All rights reserved.
//

#import "UVForum.h"
#import "UVCategory.h"

@implementation UVForum

@synthesize forumId;
@synthesize isPrivate;
@synthesize name;
@synthesize example;
@synthesize prompt;
@synthesize categories;
@synthesize suggestions;
@synthesize suggestionsNeedReload;
@synthesize suggestionsCount;

+ (id)getWithId:(int)forumId delegate:(id)delegate {
    return [self getPath:[self apiPath:[NSString stringWithFormat:@"/forums/%d.json", forumId]]
              withParams:nil
                  target:delegate
                selector:@selector(didRetrieveForum:)
                 rootKey:@"forum"];
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.forumId = [(NSNumber *)[dict objectForKey:@"id"] integerValue];
        self.name = [self objectOrNilForDict:dict key:@"name"];

        NSDictionary *topic = [[self objectOrNilForDict:dict key:@"topics"] objectAtIndex:0];
        
        self.suggestionsNeedReload = YES;
        self.example = [topic objectForKey:@"example"];
        self.prompt = [topic objectForKey:@"prompt"];
        self.suggestionsCount = [(NSNumber *)[topic objectForKey:@"open_suggestions_count"] integerValue];

        self.categories = [NSMutableArray array];
        NSMutableArray *categoryDicts = [self objectOrNilForDict:topic key:@"categories"];
        for (NSDictionary *categoryDict in categoryDicts) {
            [self.categories addObject:[[UVCategory alloc] initWithDictionary:categoryDict]];
        }
    }
    return self;
}

@end
