//
//  EWEImagesTableViewController.m
//  Blocstagram
//
//  Created by Kervins Valcourt on 8/15/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import "EWEImagesTableViewController.h"
#import "EWEUser.h"
#import "EWEMedia.h"
#import "EWEComment.h"
#import "EWEDatasource.h"
#import "EWEMediaTableViewCell.h"
#import "EWEMediaFullScreenViewController.h"
#import "EWEMediaFullScreenAnimator.h"


@interface EWEImagesTableViewController () <EWEMediaTableViewCellDelegate, UIViewControllerTransitioningDelegate>
@property (nonatomic, weak) UIImageView *lastTappedImageView;




@end

@implementation EWEImagesTableViewController



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
       
           }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[EWEDatasource sharedInstance] addObserver:self forKeyPath:@"mediaItems" options:0 context:nil];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControlDidFire:) forControlEvents:UIControlEventValueChanged];
  
    
    [self.tableView registerClass:[EWEMediaTableViewCell class] forCellReuseIdentifier:@"mediaCell"];
}

- (void) dealloc {
   [[EWEDatasource sharedInstance] removeObserver:self forKeyPath:@"mediaItems"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSArray *) item {
    return [[EWEDatasource sharedInstance] mediaItems];
}

- (void) refreshControlDidFire:(UIRefreshControl *) sender{
    [[EWEDatasource sharedInstance]requestNewItemsWithCompletionHandler:^(NSError *error) {
        [sender endRefreshing];
    }];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == [EWEDatasource sharedInstance] && [keyPath isEqualToString:@"mediaItems"]) {
        // We know mediaItems changed.  Let's see what kind of change it is.
        int kindOfChange = [change[NSKeyValueChangeKindKey] intValue];
        
        if (kindOfChange == NSKeyValueChangeSetting) {
            // Someone set a brand new images array
            [self.tableView reloadData];
        }
     else if (kindOfChange == NSKeyValueChangeInsertion ||
                 kindOfChange == NSKeyValueChangeRemoval ||
                 kindOfChange == NSKeyValueChangeReplacement) {
        // We have an incremental change: inserted, deleted, or replaced images
        
        // Get a list of the index (or indices) that changed
        NSIndexSet *indexSetOfChanges = change[NSKeyValueChangeIndexesKey];
        
        // Convert this NSIndexSet to an NSArray of NSIndexPaths (which is what the table view animation methods require)
        NSMutableArray *indexPathsThatChanged = [NSMutableArray array];
        [indexSetOfChanges enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [indexPathsThatChanged addObject:newIndexPath];
        }];
        
        // Call `beginUpdates` to tell the table view we're about to make changes
        [self.tableView beginUpdates];
        
        // Tell the table view what the changes are
        if (kindOfChange == NSKeyValueChangeInsertion) {
            [self.tableView insertRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
        } else if (kindOfChange == NSKeyValueChangeRemoval) {
            [self.tableView deleteRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
        } else if (kindOfChange == NSKeyValueChangeReplacement) {
            [self.tableView reloadRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        // Tell the table view that we're done telling it about changes, and to complete the animation
        [self.tableView endUpdates];
        }

    }
}
- (void) infiniteScrollIfNecessary {
    NSIndexPath *bottomIndexPath = [[self.tableView indexPathsForVisibleRows] lastObject];
    
    if (bottomIndexPath && bottomIndexPath.row == [EWEDatasource sharedInstance].mediaItems.count - 1) {
        // The very last cell is on screen
        [[EWEDatasource sharedInstance] requestOldItemsWithCompletionHandler:nil];
    }
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self infiniteScrollIfNecessary];
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self item].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    // Configure the cell...
    EWEMediaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mediaCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.mediaItem = self.item[indexPath.row];
    return cell;
    

}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EWEMedia *item = self.item[indexPath.row];
    return [EWEMediaTableViewCell heightForMediaItem:item width:CGRectGetWidth(self.view.frame)];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EWEMedia *item = [EWEDatasource sharedInstance].mediaItems[indexPath.row];
    if (item.image) {
        return 350;
    } else {
        return 150;
    }
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
    
        
        EWEMedia *item = [EWEDatasource sharedInstance].mediaItems[indexPath.row];
        [[EWEDatasource sharedInstance] deleteMediaItem:item];
        }
        
    
    
}

- (void) cell:(EWEMediaTableViewCell *)cell didLongPressImageView:(UIImageView *)imageView {
    NSMutableArray *itemsToShare = [NSMutableArray array];
    
    if (cell.mediaItem.caption.length > 0) {
        [itemsToShare addObject:cell.mediaItem.caption];
    }
    
    if (cell.mediaItem.image) {
        [itemsToShare addObject:cell.mediaItem.image];
    }
    
    if (itemsToShare.count > 0) {
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        [self presentViewController:activityVC animated:YES completion:nil];
    }
}

#pragma mark - EWEMediaTableViewCellDelegate

- (void) cell:(EWEMediaTableViewCell *)cell didTapImageView:(UIImageView *)imageView {
    self.lastTappedImageView = imageView;
    EWEMediaFullScreenViewController *fullScreenVC = [[EWEMediaFullScreenViewController alloc] initWithMedia:cell.mediaItem];
    fullScreenVC.transitioningDelegate = self;
    fullScreenVC.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:fullScreenVC animated:YES completion:nil];
}



#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    
    EWEMediaFullScreenAnimator *animator = [EWEMediaFullScreenAnimator new];
    animator.presenting = YES;
    animator.cellImageView = self.lastTappedImageView;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    EWEMediaFullScreenAnimator *animator = [EWEMediaFullScreenAnimator new];
    animator.cellImageView = self.lastTappedImageView;
    return animator;
}

/*

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
