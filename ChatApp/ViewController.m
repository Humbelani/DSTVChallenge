//
//  ViewController.m
//  ChatApp
//
//  Created by DVT on 2016/10/24.
//  Copyright © 2016 DVT. All rights reserved.
//

#import "ViewController.h"
#import "FriendsList.h"

@interface ViewController ()
{
    NSString *guid;
    NSString *firstName;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showHideKeyboard];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showHideKeyboard{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    [self.view resignFirstResponder];
}

- (IBAction)LoginAction:(UIButton *)sender {
    
    if ([self.username.text isEqualToString:@""] || [self.password.text isEqualToString:@""]){
        [self alertStatus:@"Login Failed!" :@"Username/Password field cannot be blank" :0];
    }else{
    [self login];
    }

}

-(void)login{

    NSDictionary *postDict = @{@"username":self.username.text,@"password":self.password.text};
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDict options:0 error:nil];
    NSString *postLength = [NSString stringWithFormat:@"%lu" , (unsigned long)[postData length]];
    NSURL *url = [NSURL URLWithString:@"http://mobileexam.dstv.com/login"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/JSON" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      
                                      NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      
                                      
                                      if ([(NSHTTPURLResponse *)response statusCode] >= 200 && [(NSHTTPURLResponse *)response statusCode] < 300){
                                          
                                          NSData *convertStringToData = [body dataUsingEncoding:NSUTF8StringEncoding];
                                          
                                          id json = [NSJSONSerialization JSONObjectWithData:convertStringToData options:0 error:nil];
                                          
                                          guid = json[@"guid"];
                                          firstName = json[@"firstName"];
                                          if ([json[@"result"] isEqual:@(1)]){
                                              
                                              dispatch_async(dispatch_get_main_queue(),  ^{
                                                  [self performSegueWithIdentifier:@"toFriendsList" sender:self];
                                            });
                                              
                                          
                                             
                                          }else{
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^ {
                                                  [self alertStatus:@"Login Failed!" :@"Username/Password is incorrect" :1];
                                              });
                                              
                                             
                                          }

                                      }else{
                                          [self alertStatus:@"OOpse" :@"server is down" :2];
                                      }
                                      
                                      NSLog(@"Response Body:\n%@\n", body);
                                      
                                      
                                  }];
    [task resume];
}

- (void) alertStatus:(NSString *)title :(NSString *)message :(int) tag
{

    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toFriendsList"]) {
        
        
          FriendsList *friendsList = [segue destinationViewController];
          friendsList.guid = guid;
          friendsList.firstName = firstName;
        
        
        [segue.destinationViewController setTitle:@"Friends"];
    }}


@end
