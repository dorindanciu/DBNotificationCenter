//
//  DBNotificationCenterViewController.m
//  DBNotificationCenter
//
//  Created by Dorin Danciu on 10/7/12.
//  Copyright (c) 2012 Dorin Danciu. All rights reserved.
//

#define TOUCHABLE_AREA 80.0
#define TOP_OFFSET 40

typedef enum{
    NotificationCenterMovingDirectionUp,
    NotificationCenterMovingDirectionDown
} NotificationCenterMovingDirection;

#import "DBNotificationCenterViewController.h"

@interface DBNotificationCenterViewController (){
    BOOL                                isMoving;
    NotificationCenterMovingDirection   direction;
}

@end

@implementation DBNotificationCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [self.view addGestureRecognizer:panGesture];
        [panGesture release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Touch Methods
- (void)handlePan:(UIPanGestureRecognizer *)recognizer{
    
    if (_isSlideActionAvailable) {
       
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            CGPoint startPoint = [recognizer locationInView:self.view];
            if (startPoint.y > self.view.frame.size.height - TOUCHABLE_AREA)
            {
                isMoving = YES;
            }
        }
        
        if (recognizer.state == UIGestureRecognizerStateChanged) {
            if (isMoving)
            {
                CGPoint translation = [recognizer translationInView:self.view];
                if (recognizer.view.center.y + translation.y < self.view.frame.size.height/2) {
                    recognizer.view.center = CGPointMake(recognizer.view.center.x,
                                                         recognizer.view.center.y + translation.y);
                    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
                    
                    if (translation.y != 0) {
                        (translation.y > 0) ? (direction = NotificationCenterMovingDirectionDown) : (direction = NotificationCenterMovingDirectionUp);
                    }
                }
            }
        }
        
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            if (isMoving) {
                
                CGPoint velocity = [recognizer velocityInView:self.view];
                CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
                CGFloat distanceLeft;
                CGPoint finalPoint;
                
                CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

                if ((((screenHeight + self.view.frame.origin.y) > TOUCHABLE_AREA) && direction == NotificationCenterMovingDirectionDown)
                    || (direction == NotificationCenterMovingDirectionDown  && magnitude > 500)) {
                    finalPoint = CGPointMake(recognizer.view.center.x,recognizer.view.frame.size.height/2);
                    distanceLeft = 0 - self.view.frame.origin.y;
                }else{
                    finalPoint = CGPointMake(recognizer.view.center.x,-screenHeight/2 + TOP_OFFSET);
                    distanceLeft = screenHeight + self.view.frame.origin.y;
                }
                
                CGFloat duration = MIN(distanceLeft / sqrtf(velocity.y * velocity.y), 0.35);
                [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    recognizer.view.center = finalPoint;
                } completion:nil];
                
                isMoving = NO;
            }
        }
    }
}


@end
