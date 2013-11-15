//
//  UVSuccessViewController.m
//  UserVoice
//
//  Created by Austin Taylor on 10/23/13.
//  Copyright (c) 2013 UserVoice Inc. All rights reserved.
//

#import "UVSuccessViewController.h"

@implementation UVSuccessViewController

- (void)loadView {
    [super loadView];
    self.view = [UIView new];
    self.view.frame = [self contentFrame];
    self.view.backgroundColor = [UIColor colorWithRed:0.26f green:0.31f blue:0.35f alpha:1.0f];
    UILabel *title = [UILabel new];
    title.text = _titleText;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:26];
    title.textAlignment = NSTextAlignmentCenter;
    UILabel *text = [UILabel new];
    text.text = _text;
    text.textColor = [UIColor whiteColor];
    text.font = [UIFont systemFontOfSize:15];
    text.textAlignment = NSTextAlignmentCenter;
    UIButton *button = [UIButton new];
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.3f].CGColor;
    button.layer.cornerRadius = 14.0;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:NSLocalizedStringFromTable(@"Close", @"UserVoice", nil) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self configureView:self.view
               subviews:NSDictionaryOfVariableBindings(title, text, button)
            constraints:@[@"|-[title]-|", @"|-[text]-|", @"[button(>=90)]", @"V:|-160-[title]-16-[text]-60-[button(==28)]"]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
