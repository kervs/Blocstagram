//
//  EWEMediaFullScreenViewController.m
//  Blocstagram
//
//  Created by Kervins Valcourt on 8/21/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import "EWEMediaFullScreenViewController.h"
#import "EWEMedia.h"
#import "EWEImagesTableViewController.h"
#import "EWEDatasource.h"
#import "EWEMediaTableViewCell.h"

@interface EWEMediaFullScreenViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) EWEMedia *media;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic, strong) UIButton *shareButton;


@end

@implementation EWEMediaFullScreenViewController

- (instancetype) initWithMedia:(EWEMedia *)media {
    return [self initWithMedia:media andDelegate:nil];
}

- (instancetype) initWithMedia:(EWEMedia *)media andDelegate:(id<EWEMediaFullScreenDelegate>) delegate {
    self = [super init];
    
    if (self) {
        self.media = media;
        self.delegate = delegate;
    }
    
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scrollView = [UIScrollView new];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareMediaItem:fromController:)]) {
        self.shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.shareButton setTitle:@"Share" forState:UIControlStateNormal];
        [self.shareButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.shareButton];
    }
    

    self.imageView = [UIImageView new];
    self.imageView.image = self.media.image;
    
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
    
    self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapFired:)];
    self.doubleTap.numberOfTapsRequired = 2;
    
    [self.tap requireGestureRecognizerToFail:self.doubleTap];
    
    [self.scrollView addGestureRecognizer:self.tap];
    [self.scrollView addGestureRecognizer:self.doubleTap];
    
    [self.scrollView addSubview:self.imageView];
    self.scrollView.contentSize = self.media.image.size;
    
    
}
- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.scrollView.frame = self.view.bounds;
    
    CGSize scrollViewFrameSize = self.scrollView.frame.size;
    CGSize scrollViewContentSize = self.scrollView.contentSize;
    
    CGFloat scaleWidth = scrollViewFrameSize.width / scrollViewContentSize.width;
    CGFloat scaleHeight = scrollViewFrameSize.height / scrollViewContentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.shareButton.frame = CGRectMake(180, 30, 160.0, 40.0);
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 1;
}
- (void)centerScrollView {
    [self.imageView sizeToFit];
    
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - CGRectGetWidth(contentsFrame)) / 2;
    } else {
        contentsFrame.origin.x = 0;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - CGRectGetHeight(contentsFrame)) / 2;
    } else {
        contentsFrame.origin.y = 0;
    }
    
    self.imageView.frame = contentsFrame;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UIScrollViewDelegate

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerScrollView];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self centerScrollView];
}
#pragma mark - Gesture Recognizers

- (void) tapFired:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) doubleTapFired:(UITapGestureRecognizer *)sender {
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        CGPoint locationPoint = [sender locationInView:self.imageView];
        
        CGSize scrollViewSize = self.scrollView.bounds.size;
        
        CGFloat width = scrollViewSize.width / self.scrollView.maximumZoomScale;
        CGFloat height = scrollViewSize.height / self.scrollView.maximumZoomScale;
        CGFloat x = locationPoint.x - (width / 2);
        CGFloat y = locationPoint.y - (height / 2);
        
        [self.scrollView zoomToRect:CGRectMake(x, y, width, height) animated:YES];
    } else {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
}

-(void) buttonPressed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareMediaItem:fromController:)]) {
        [self.delegate shareMediaItem:self.media fromController:self];
    }
}

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
