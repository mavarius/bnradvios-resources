//
//  BNRMasterViewController.m
//  AllThumbs
//
//  Created by Jonathan Blocksom on 10/12/12.
//  Copyright (c) 2012 Big Nerd Ranch, Inc. All rights reserved.
//

#import "BNRMasterViewController.h"

#import "BNRDetailViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface BNRMasterViewController () {
    NSMutableArray *_objects;
}

@property (nonatomic, strong) ALAssetsLibrary *library;

@end

@implementation BNRMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.detailViewController = (BNRDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    _objects = [[NSMutableArray alloc] init];
    
    if (self.library == nil) {
        self.library = [[ALAssetsLibrary alloc] init];
        // Lifetime of objects retrieved from an ALAssetsLibrary
        // object is limited to the lifetime of the ALAssetsLibrary
    }
    
    // Enumerate the photo album groups
    [self.library enumerateGroupsWithTypes:ALAssetsGroupAll
                                usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                    NSLog(@"Asset group %@", group);
                                    if (group != nil) {
                                        // Found a group
                                        [_objects addObject:group];
                                    } else {
                                        // Finished enumerating, reload table
                                        [self.tableView reloadData];
                                    }
                                } failureBlock:^(NSError *error) {
                                    NSLog(@"Failure %@", error);
                                }
     ];
    
    self.title = @"Albums";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count: %d", _objects.count);
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    ALAssetsGroup *object = _objects[indexPath.row];
    cell.textLabel.text = [object valueForProperty:ALAssetsGroupPropertyName];;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSObject *object = _objects[indexPath.row];
        self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSObject *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
