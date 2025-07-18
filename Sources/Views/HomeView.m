//
//  HomeView.m
//  Hayden-Says
//
//  Created by Hayden Howell on 7/16/25.
//

#import "HomeView.h"


@implementation HomeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor systemBackgroundColor];

        CGFloat buttonWidth = 200;
        CGFloat buttonHeight = 50;

        // Dropdown button
        self.dropdownButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.dropdownButton setTitle:@"Choose Saying" forState:UIControlStateNormal];
        self.dropdownButton.frame = CGRectMake((frame.size.width - buttonWidth) / 2, (frame.size.height - buttonHeight) / 2 - 50, buttonWidth, buttonHeight);
        [self addSubview:self.dropdownButton];

        // Play Sound button
        self.playSoundButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.playSoundButton setTitle:@"Play" forState:UIControlStateNormal];
        self.playSoundButton.frame = CGRectMake((frame.size.width - buttonWidth) / 2, (frame.size.height - buttonHeight) / 2 + 30, buttonWidth, buttonHeight);
        [self addSubview:self.playSoundButton];

    }
    return self;
}

@end
