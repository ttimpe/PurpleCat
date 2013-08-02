//
//  MainViewController.h
//  PurpleCat
//
//  Created by Tobias Timpe on 02.08.13.
//

#import <UIKit/UIKit.h>
@interface MainViewController : UIViewController <UITextViewDelegate> {
    UITextView *textView;
    NSMutableArray *connectedSockets;
}
-(void)addLineToOutput:(NSString*)line;
@end
