//
//  MainViewController.m
//  PurpleCat
//
//  Created by Tobias Timpe on 02.08.13.
//

#import "MainViewController.h"

#import "RBVolumeButtons.h"
@interface MainViewController () {
    int currentLine;
    NSString *verboseOutput;
    NSTimer *timer;
    NSTimer *progressTimer;
    UIImageView *appleLogoView;
    float maxNumberOfLines;
    UIProgressView *progressView;
    
}

@end

@implementation MainViewController

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
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    appleLogoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"apple-logo"]];
    [appleLogoView setFrame:self.view.frame];
    [appleLogoView setContentMode:UIViewContentModeCenter];
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProgress)];
    tapped.numberOfTapsRequired = 1;
    [appleLogoView addGestureRecognizer:tapped];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(respring)
                                   userInfo:nil
                                    repeats:NO];
    
    
	// Do any additional setup after loading the view.
    textView = [[UITextView alloc] initWithFrame:CGRectOffset(self.view.frame,0,0)];
    textView.backgroundColor = [UIColor blackColor];
    textView.textColor = [UIColor whiteColor];
    textView.font = [UIFont fontWithName:@"Menlo-Bold" size:10];
    CGSize helloSize = [@"Hello" sizeWithFont:textView.font];
    maxNumberOfLines = self.view.frame.size.height/helloSize.height;
    NSLog(@"Max number of lines is: %f", maxNumberOfLines);

    textView.delegate = self;
    textView.scrollEnabled = NO;
    textView.selectable = NO;
    textView.editable = NO;
    NSLog(@"tt0001m_: %@", [UIFont fontNamesForFamilyName:@"Menlo"]);
    [self.view addSubview:textView];
    [self.view addSubview:appleLogoView];
    RBVolumeButtons *volumeButtons = [[RBVolumeButtons alloc] init];
    volumeButtons.upBlock = ^{
        [timer invalidate];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HELLO" message:@"HELLO" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
        
    };
    
}
-(void)respring{
    [appleLogoView removeFromSuperview];
    [self startScrollingVerboseOutput];
    NSLog(@"Starting scroll");
    
}

-(void)startScrollingVerboseOutput {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"verbose"
                                                     ofType:@"log"];
    verboseOutput = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"Log has %i lines", [[verboseOutput componentsSeparatedByString:@"\n"] count]);
 //   NSLog(@"DUMP FILE: %@", verboseOutput);
    currentLine = 0;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.0001f target:self selector:@selector(scrollLine) userInfo:nil repeats:YES];
   
}
-(void)addLineToOutput:(NSString*)line {
    NSMutableArray *lines = [NSMutableArray arrayWithArray:[textView.text componentsSeparatedByString:@"\n"]];
    
    
    if ([lines count] < maxNumberOfLines-1) {
        [lines addObject:line];
    }
    else {
        [lines removeObjectAtIndex:0];
        [lines addObject:line];
    }
    textView.text = [lines componentsJoinedByString:@"\n"];
    
}
-(void)scrollLine {
    NSLog(@"line: %i", currentLine);
    if (currentLine >500) {
        [timer invalidate];
        [self makeLoader];
        NSLog(@"Done");
        
    }
    
    [self addLineToOutput:[[verboseOutput componentsSeparatedByString:@"\n"] objectAtIndex:currentLine]];


    currentLine++;
}

-(void)makeLoader {
    
    UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [indicator setFrame:self.view.frame];
    [textView removeFromSuperview];
    [self.view addSubview:indicator];
    [indicator startAnimating];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(finishBoot) userInfo:nil repeats:NO];
    
}

-(void)showProgress {
    [timer invalidate];
    [textView removeFromSuperview];
    NSLog(@"PROGRESS");
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [progressView setFrame:CGRectMake(40, 300, 240, 20)];
    progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgressBar) userInfo:nil repeats:YES];
    [self.view addSubview:progressView];
    
    
}
-(void)updateProgressBar {
    if (progressView.progress < 1) {
        progressView.progress = progressView.progress + 0.01f;
    }
    else {
        [progressTimer invalidate];
        
    }
    
    
}
-(void)finishBoot{
    exit(0);
}
                               
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
