//
//  ViewController.h
//  ChatApp
//
//  Created by DVT on 2016/10/24.
//  Copyright © 2016 DVT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (IBAction)LoginAction:(UIButton *)sender;

@end

