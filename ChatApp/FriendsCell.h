//
//  FriendsCell.h
//  ChatApp
//
//  Created by DVT on 2016/10/25.
//  Copyright © 2016 DVT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *friendImage;
@property (weak, nonatomic) IBOutlet UILabel *friendAliasName;
@property (weak, nonatomic) IBOutlet UILabel *lastSeen;


@end
