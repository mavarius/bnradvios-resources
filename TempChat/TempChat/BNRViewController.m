//
//  BNRViewController.m
//  TempChat
//
//  Created by Jonathan Blocksom on 1/9/13.
//  Copyright (c) 2013 Big Nerd Ranch, Inc. All rights reserved.
//

#import "BNRViewController.h"

#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>

@interface BNRViewController ()

@end

@implementation BNRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set text field delegate
    self.textField.delegate = self;
    
    [self connect:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)connect:(id)sender {
    struct addrinfo hints, *res;
    int sockfd;
    
    // first, load up address structs with getaddrinfo():
    
    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    
    getaddrinfo("192.168.1.4", "8081", &hints, &res);
    
    // make a socket:
    
    sockfd = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    
    // connect!
    connect(sockfd, res->ai_addr, res->ai_addrlen);
    
    // Read some data
    char buf[1024];
    size_t numBytesRead;
    numBytesRead = recv(sockfd, buf, 1023, 0);
    buf[numBytesRead] = '\0';
    
    NSLog(@"Received %d bytes: %s", numBytesRead, buf);
}

@end
