//
//  FriendDetails.h
//  ChatApp
//
//  Created by DVT on 2016/10/26.
//  Copyright © 2016 DVT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendDetails : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *friendImage;
@property (weak, nonatomic) IBOutlet UILabel *friendAlias;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UIImageView *statusImage;


@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *dateOfBirth;

@property (weak, nonatomic) IBOutlet UILabel *lastSeenLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastSeenDate;


@property (strong, nonatomic) NSString *aliasString;
@property (strong, nonatomic) NSString *imageString;
@property (strong, nonatomic) NSString *statusString;
@property (strong, nonatomic) NSString *fullNameString;
@property (strong, nonatomic) NSString *dateOfBirthString;
@property (strong, nonatomic) NSString *lastSeenString;


@end
