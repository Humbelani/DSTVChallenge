//
//  FriendsList.h
//  ChatApp
//
//  Created by DVT on 2016/10/25.
//  Copyright © 2016 DVT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsList : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLSessionDelegate>
@property(strong, nonatomic) NSString *guid;
@property(strong, nonatomic) NSString *firstName;
@property(strong, nonatomic) NSMutableArray *friendsList;

@property(strong, nonatomic) NSString *passImage;
@property(strong, nonatomic) NSString *passAlias;
@property(strong, nonatomic) NSString *passStatus;
@property(strong, nonatomic) NSString *passLastSeenDate;
@property(strong, nonatomic) NSString *passDOB;
@property(strong, nonatomic) NSString *passlastName;



@property (weak, nonatomic) IBOutlet UITableView *friendsTable;




@end
