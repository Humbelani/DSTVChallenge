//
//  FriendsList.m
//  ChatApp
//
//  Created by DVT on 2016/10/25.
//  Copyright © 2016 DVT. All rights reserved.
//

#import "FriendsList.h"
#import "FriendsCell.h"
#import "FriendDetails.h"

@interface FriendsList ()

@end

@implementation FriendsList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showFriendsList];
    
    self.friendsTable.delegate = self;
    self.friendsTable.dataSource = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    FriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[FriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *item = [self.friendsList objectAtIndex:indexPath.row];
    
    cell.friendAliasName.text = item[@"alias"];
    
    
    if ([item[@"status"] isEqualToString:@"Offline"]){
        cell.lastSeen.text = [NSString stringWithFormat:@"Last seen: %@" ,item[@"lastSeen"]];
    }else{
        cell.lastSeen.text = [NSString stringWithFormat:@"Status: %@", item[@"status"]];
    }
    
    NSURL *url = [NSURL URLWithString:item[@"imageURL"]];
//    if (url.absoluteString.length == 0){
        cell.friendImage.image = [UIImage imageNamed:@"No_image.png"];
//    }else{
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    FriendsCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell)
                        updateCell.friendImage.image = image;
                });
                
            }
        }
    }];
        [task resume];//}
    

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *item = [self.friendsList objectAtIndex:indexPath.row];
    self.passAlias = item[@"alias"];
    self.passStatus = item[@"status"];
    self.passLastSeenDate = item[@"lastSeen"];
    self.firstName = item[@"firstName"];
    self.passlastName = item[@"lastName"];
    self.passDOB = item[@"dateOfBirth"];
    
    [self performSegueWithIdentifier:@"toDetailScreen" sender:self];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"tapped button at row: %li",(long)indexPath.row);
    
    
    NSDictionary *item = [self.friendsList objectAtIndex:indexPath.row];
    self.passAlias = item[@"alias"];
    self.passStatus = item[@"status"];
    self.passLastSeenDate = item[@"lastSeen"];
    self.firstName = item[@"firstName"];
    self.passlastName = item[@"lastName"];
    self.passDOB = item[@"dateOfBirth"];
    self.passImage = item[@"imageURL"];
    
    [self performSegueWithIdentifier:@"toDetailScreen" sender:self];
}

-(void)showFriendsList{
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://mobileexam.dstv.com/friends;uniqueID=%@;name=%@",self.guid, self.firstName]];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if(error == nil)
                                                        {
                                                            NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                            
                                                            NSData *convertStringToData = [text dataUsingEncoding:NSUTF8StringEncoding];
                                                        
                                                        self.friendsList = [[NSMutableArray alloc] init];
                                                        
                                                            id json = [NSJSONSerialization JSONObjectWithData:convertStringToData options:0 error:nil];
                                                            
                                                            if ([json isKindOfClass:[NSDictionary class]])
                                                            {
                                                                NSDictionary* friendArray = (NSDictionary*)json[@"friends"];
                                                                NSLog(@"Found %lu friends", (unsigned long)[friendArray count]);
                                                                
//                                                                for (NSDictionary* friend in friendArray){
//                                                                    NSString* item = [[NSString alloc] init];
//                                                                    item = [friend objectForKey:@"alias"];
                                                                
                                                                   // [self.friendsList addObject:friendArray];
                                                                    
                                                                    NSLog(@"Found %lu friendslist", (unsigned long)[self.friendsList count]);
                                                                    
                                                                //}
                                                            }
                                                            
                                                            self.friendsList = json[@"friends"];
                                                            [self.friendsTable reloadData];
                                                            
                                                            NSLog(@"Data = %@",text);
                                                        
                                                       }
                                                        
                                                    }];
    
    [dataTask resume];
 
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toDetailScreen"]) {
        
        FriendDetails *friendsDetail = [segue destinationViewController];
        friendsDetail.imageString = self.passImage;
        friendsDetail.aliasString = self.passAlias;
        friendsDetail.lastSeenString = self.passLastSeenDate;
        friendsDetail.fullNameString = [NSString stringWithFormat:@"%@ %@", self.firstName, self.passlastName];
        friendsDetail.dateOfBirthString = self.passDOB;
        friendsDetail.statusString = self.passStatus;
        
        
        [segue.destinationViewController setTitle:[NSString stringWithFormat:@"%@'s Details", self.firstName]];
    }}


@end
