//
//  MainViewController.m
//  PurpleCat
//
//  Created by Tobias Timpe on 02.08.13.
//

#import "MainViewController.h"


@interface MainViewController () {
    int currentLine;
    NSString *verboseOutput;
    NSTimer *timer;
    UIImageView *appleLogoView;
    float maxNumberOfLines;
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
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    appleLogoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"apple-logo"]];
    [appleLogoView setFrame:self.view.frame];
    [appleLogoView setContentMode:UIViewContentModeCenter];
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(respring)
                                   userInfo:nil
                                    repeats:NO];
    
    
	// Do any additional setup after loading the view.
    textView = [[UITextView alloc] initWithFrame:CGRectOffset(self.view.frame,0,0)];
    textView.backgroundColor = [UIColor blackColor];
    textView.textColor = [UIColor whiteColor];
    textView.font = [UIFont fontWithName:@"Menlo-Bold" size:11];
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

    
    
}
-(void)respring{
    [appleLogoView removeFromSuperview];
    [self startScrollingVerboseOutput];
    NSLog(@"Starting scroll");
    
}

-(void)startScrollingVerboseOutput {
    verboseOutput = [NSString stringWithContentsOfFile:@"/Users/tobias/verbose.log" encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"Log has %i lines", [[verboseOutput componentsSeparatedByString:@"\n"] count]);
 //   NSLog(@"DUMP FILE: %@", verboseOutput);
    currentLine = 0;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.0001f target:self selector:@selector(scrollLine) userInfo:nil repeats:YES];
   
}
-(void)addLineToOutput:(NSString*)line {
    NSMutableArray *lines = [NSMutableArray arrayWithArray:[textView.text componentsSeparatedByString:@"\n"]];
    
    
    if ([lines count] < maxNumberOfLines) {
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

-(void)finishBoot{
    exit(0);
}
                               
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
