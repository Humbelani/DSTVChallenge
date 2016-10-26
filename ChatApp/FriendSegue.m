//
//  FriendSegue.m
//  ChatApp
//
//  Created by DVT on 2016/10/26.
//  Copyright © 2016 DVT. All rights reserved.
//

#import "FriendSegue.h"

@implementation FriendSegue

- (void)perform {
    UIViewController *source = self.sourceViewController;
    UIViewController *destination = self.destinationViewController;
    [UIView transitionWithView:source.navigationController.view duration:2
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [source.navigationController pushViewController:destination animated:NO];
                    }
                    completion:NULL];
}

@end
