//
//  UVWelcomeViewController.m
//  UserVoice
//
//  Created by UserVoice on 12/15/09.
//  Copyright 2009 UserVoice Inc. All rights reserved.
//

#include <QuartzCore/QuartzCore.h>
#import "UVRootViewController.h"
#import "UVClientConfig.h"
#import "UVAccessToken.h"
#import "UVRequestToken.h"
#import "UVSession.h"
#import "UVUser.h"
#import "UVWelcomeViewController.h"
#import "UVSuggestionListViewController.h"
#import "UVConfig.h"
#import "UVStyleSheet.h"
#import "UVInitialLoadManager.h"
#import "UVPostIdeaViewController.h"
#import "UVContactViewController.h"

@implementation UVRootViewController

@synthesize viewToLoad;
@synthesize loader;

- (id)init {
    if (self = [super init]) {
        self.viewToLoad = @"welcome";
    }
    return self;
}

- (id)initWithViewToLoad:(NSString *)theViewToLoad {
    if (self = [super init]) {
        self.viewToLoad = theViewToLoad;
    }
    return self;
}

- (void)dismissUserVoice {
    loader.dismissed = YES;
    [super dismissUserVoice];
}

- (void)pushNextView {
    UVSession *session = [UVSession currentSession];
    if ((![UVAccessToken exists] || session.user) && session.clientConfig && [self.navigationController.viewControllers count] == 1) {
        CATransition* transition = [CATransition animation];
        transition.duration = 0.3;
        transition.type = kCATransitionFade;
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        UVBaseViewController *next = nil;
        if ([self.viewToLoad isEqualToString:@"welcome"])
            next = [UVWelcomeViewController new];
        else if ([self.viewToLoad isEqualToString:@"suggestions"])
            next = [UVSuggestionListViewController new];
        else if ([self.viewToLoad isEqualToString:@"new_suggestion"])
            next = [UVPostIdeaViewController new];
        else if ([self.viewToLoad isEqualToString:@"new_ticket"])
            next = [UVContactViewController new];

        next.firstController = YES;
        [self.navigationController pushViewController:next animated:NO];
    }
}


#pragma mark ===== Basic View Methods =====

- (void)loadView {
    [super loadView];

    self.navigationItem.title = NSLocalizedStringFromTable(@"Feedback & Support", @"UserVoice", nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Close", @"UserVoice", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(dismissUserVoice)];

    self.view = [[UIView alloc] initWithFrame:[self contentFrame]];
    self.view.backgroundColor = [UVStyleSheet backgroundColor];

    UIView *loading = [[UIView alloc] initWithFrame:CGRectMake(0, 120, self.view.bounds.size.width, 100)];
    loading.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    if ([activity respondsToSelector:@selector(setColor:)]) {
        [activity setColor:[UIColor grayColor]];
    } else {
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    activity.center = CGPointMake(loading.bounds.size.width/2, 40);
    [loading addSubview:activity];
    [activity startAnimating];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, loading.frame.size.width, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedStringFromTable(@"Loading...", @"UserVoice", nil);
    [label sizeToFit];
    label.center = CGPointMake(loading.bounds.size.width/2, 85);
    [loading addSubview:label];
    [loading sizeToFit];
    [self.view addSubview:loading];
}

- (void)viewWillAppear:(BOOL)animated {
    self.loader = [UVInitialLoadManager loadWithDelegate:self action:@selector(pushNextView)];
}

@end
