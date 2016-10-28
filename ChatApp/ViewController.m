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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.spinner.hidden = YES;
    [self.spinner stopAnimating];
    self.loginButton.enabled = YES;
    self.loginButton.titleLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
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
        self.loginButton.enabled = NO;
        [self login];
        
    }
    
}


-(void)login{
    
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    
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
                                      
                                      if(!error){
                                          
                                          NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                          
                                          
                                          if ([(NSHTTPURLResponse *)response statusCode] >= 200 && [(NSHTTPURLResponse *)response statusCode] < 300){
                                              
                                              NSData *convertStringToData = [body dataUsingEncoding:NSUTF8StringEncoding];
                                              
                                              id json = [NSJSONSerialization JSONObjectWithData:convertStringToData options:0 error:nil];
                                              
                                              guid = json[@"guid"];
                                              firstName = json[@"firstName"];
                                              if ([json[@"result"] isEqual:@(1)]){
                                                  [self.spinner  stopAnimating];
                                                  self.spinner.hidden = YES;
                                                  dispatch_async(dispatch_get_main_queue(),  ^{
                                                      [self performSegueWithIdentifier:@"toFriendsList" sender:self];
                                                      [self.spinner  stopAnimating];
                                                      self.spinner.hidden = YES;
                                                  });
                                                  
                                              }else{
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^ {
                                                      [self alertStatus:@"Login Failed!" :@"Username/Password is incorrect" :1];
                                                      [self.spinner stopAnimating];
                                                      self.spinner.hidden = YES;

                                                  });
                                                 }
                                              
                                          }else{
                                              [self alertStatus:@"OOpse" :@"server is down" :2];
                                          }
                                          
                                          NSLog(@"Response Body:\n%@\n", body);
                                          [self.spinner stopAnimating];
                                          self.loginButton.enabled = YES;
                                          self.spinner.hidden = YES;
                                      }
                                      else{
                                          dispatch_async(dispatch_get_main_queue(), ^ {
                                              [self alertStatus:@"Error!" :error.localizedDescription :3];
                                              [self.spinner stopAnimating];
                                              self.spinner.hidden = YES;
                                              self.loginButton.enabled = YES;
                                          });
                                        }
                   
                                      self.spinner.hidden = YES;
                                      
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
        [self.spinner stopAnimating];
        self.spinner.hidden = YES;
    }}


@end
