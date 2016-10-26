//
//  FriendDetails.m
//  ChatApp
//
//  Created by DVT on 2016/10/26.
//  Copyright © 2016 DVT. All rights reserved.
//

#import "FriendDetails.h"

@interface FriendDetails ()

@end

@implementation FriendDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showStatusIndicator];
    [self receivedFriendDetails];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)receivedFriendDetails{
    self.friendAlias.text = self.aliasString;
    self.status.text = [NSString stringWithFormat:@"Status: %@", self.statusString];
    self.fullName.text = self.fullNameString;
    self.dateOfBirth.text = self.dateOfBirthString;
    self.lastSeenDate.text = self.lastSeenString;
    
    NSURL *url = [NSURL URLWithString:self.imageString];
  
        self.friendImage.image = [UIImage imageNamed:@"No_image.png"];
         NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.friendImage.image = image;
                    });
                    
                }
            }
        }];
        [task resume];
    
    
    if ([self.statusString isEqualToString:@"Offline"]) {
        self.lastSeenDate.hidden = NO;
        self.lastSeenLabel.hidden = NO;
    }else{
        self.lastSeenDate.hidden = YES;
        self.lastSeenLabel.hidden = YES;
    }
    
    
  }

-(void)showStatusIndicator{
    
    NSString *status = self.statusString;
//    self.statusImage = [[UIImageView alloc] init];
    
    if ([status isEqualToString:@"Online"]) {
        self.statusImage.image = [UIImage imageNamed:@"Status-user-online"];
    }else if ([status isEqualToString:@"Away"]) {
        self.statusImage.image = [UIImage imageNamed:@"Status-user-away.png"];
    }else if([status isEqualToString:@"Busy"]) {
        self.statusImage.image = [UIImage imageNamed:@"Status-user-busy.png"];
    }else{
        self.statusImage.image = [UIImage imageNamed:@"Status-user-offline.png"];
    }
}


@end
