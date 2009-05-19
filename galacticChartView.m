#import "galacticChartView.h"
#import <QuartzCore/QuartzCore.h>  // Needed for animations
#import "S1AppDelegate.h"
#import "player.h"

@implementation galacticChartView


-(void)WinDrawLine:(CGContextRef)context x1:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2
{
	CGContextMoveToPoint(context, x1, y1);
	CGContextAddLineToPoint(context, x2, y2);
	CGContextStrokePath(context);
}


-(void)drawView:(CGContextRef)context bounds:(CGRect)bounds
{
	
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	//FIXME:!!!
	Index = app.gamePlayer.currentGalaxySystem;
	
	if (app.gamePlayer.canSuperWarp)
		[self addSubview:jumpButton];
	else
		[jumpButton removeFromSuperview];
	
	
	CGContextDrawImage(context,  CGRectMake(0, -0,  backgroundSize.width, backgroundSize.height) , background);
	// Drawing lines with a white stroke color
	CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
	// Draw them with a 2.0 stroke width so they are a bit more visible.
	CGContextSetLineWidth(context, 2.0);	
	
	
	int Xs = (int)((float)[app.gamePlayer getSolarSystemX:app.gamePlayer.currentSystem]*1.8)+GALAXYBOUNDSX-EXTRAERASE+greenDotSize.width/2+2;
	int Ys = (int)((float)[app.gamePlayer getSolarSystemY:app.gamePlayer.currentSystem]*2.8)+GALAXYBOUNDSY-EXTRAERASE+greenDotSize.height/2+2;
	
	int fuel = [app.gamePlayer getFuel];
	float delta = 2.2;
	if (fuel)
	{
		CGContextAddArc(context, Xs, Ys,  fuel * delta, 0, 2*3.1416f, 1);
	}
	
	CGContextStrokePath(context);
	
	

	int i;
	for (i=0; i<MAXSOLARSYSTEM; ++i)
	{
		

		
		int Xp = (int)((float)[app.gamePlayer getSolarSystemX:i]*1.8);
		int Yp = (int)((float)[app.gamePlayer getSolarSystemY:i]*2.8);
		
		if ([app.gamePlayer getSolarSystemVisited:i]) {
			//[blueDot drawAtPoint:CGPointMake(Xp, Yp)];
			CGContextDrawImage(context,  CGRectMake(Xp+GALAXYBOUNDSX-EXTRAERASE, Yp+GALAXYBOUNDSY-EXTRAERASE,  blueDotSize.width, blueDotSize.height) , blueDot);
			
		} else {
			//[greenDot drawAtPoint:CGPointMake(Xp, Yp)];
			CGContextDrawImage(context,  CGRectMake(Xp+GALAXYBOUNDSX-EXTRAERASE, Yp+GALAXYBOUNDSY-EXTRAERASE, greenDotSize.width, blueDotSize.height) , greenDot);						
		}
		
		if (i == app.gamePlayer.trackedSystem || i == app.gamePlayer.currentGalaxySystem)
		{
			CGContextDrawImage(context,  CGRectMake(Xp+GALAXYBOUNDSX-EXTRAERASE-4, Yp+GALAXYBOUNDSY-EXTRAERASE-4, greenDotSize.width+8, greenDotSize.height+8) , greenDot);
		}
		
		if ([app.gamePlayer wormholeExists:i b:-1])
			CGContextDrawImage(context,  CGRectMake(Xp+GALAXYBOUNDSX-EXTRAERASE+2+WORMHOLEDISTANCE, Yp+GALAXYBOUNDSY-EXTRAERASE+1, redDotSize.width, redDotSize.height) , redDot);				

		
		CGContextStrokePath(context);		

	}
	

	long distToTracked = [app.gamePlayer realDistance:[app.gamePlayer getCurrentSystemIndex] b:app.gamePlayer.currentGalaxySystem];
	systemName.text = [NSString stringWithFormat:@"%@ %i parsecs",[app.gamePlayer getSolarSystemName:app.gamePlayer.currentGalaxySystem], distToTracked];
	systemType.text = [app.gamePlayer getSystemTechLevel:app.gamePlayer.currentGalaxySystem];
	
}

-(void)drawRect:(CGRect)rect
{
	[self drawView:UIGraphicsGetCurrentContext() bounds:self.bounds];
}

- (void)didMoveToWindow {
	

	[super didMoveToWindow];
	//[self drawRect:CGRectMake(0,0,0,0)];
	[self setNeedsDisplay];
}


- (id)initWithCoder:(NSCoder*)coder 
{
	if (self = [super initWithCoder:coder]) {
		
		self.backgroundColor =[UIColor blackColor];
		{
			UIImage *img = [UIImage imageNamed:@"Galaxy3.png"];
			background = CGImageRetain(img.CGImage);
			backgroundSize = img.size;
		}
		
		self.backgroundColor =[UIColor blackColor];
		
		{
			UIImage *img = [UIImage imageNamed:@"dotwormhole.png"];
			redDot = CGImageRetain(img.CGImage);
			redDotSize = img.size;
		}
		
		{
			UIImage *img = [UIImage imageNamed:@"dot.png"];
			greenDot = CGImageRetain(img.CGImage);
			greenDotSize = img.size;
		}
		
		{
			UIImage *img = [UIImage imageNamed:@"dotvisited.png"];
			blueDot = CGImageRetain(img.CGImage);
			blueDotSize = img.size;
		}
		

	}
	
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	app.gamePlayer.currentGalaxySystem = [app.gamePlayer getCurrentSystemIndex];
	return self;
}


-(IBAction)selectNextSystem
{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	++app.gamePlayer.currentGalaxySystem;
	if (app.gamePlayer.currentGalaxySystem >= MAXSOLARSYSTEM)
		app.gamePlayer.currentGalaxySystem = 0;
	
	[self setNeedsDisplay];
	
	//[//self.view 
}

-(IBAction)selectPrevSystem
{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	--app.gamePlayer.currentGalaxySystem;	
	if (app.gamePlayer.currentGalaxySystem < 0)
		app.gamePlayer.currentGalaxySystem = MAXSOLARSYSTEM-1;
	
	[self setNeedsDisplay];
}

-(IBAction)findSystem
{
	AlertModalWindow * myAlertView = [[AlertModalWindow alloc] initWithTitle:@"Find System" yoffset:90 message:@"Which system are you looking for?\n\n\n\n"  
																	delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Ok"  thirdButtonTitle:@"Tracking"];
	
	[myAlertView show];
	
	
	[myAlertView release];
	
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{
	int button = buttonIndex;
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	
	int index = -1;

	NSString * value = [[(AlertModalWindow*)alertView myTextField] text];
	
	for (int i =0; i < MAXSOLARSYSTEM;++i) {
		
		if ([[app.gamePlayer getSolarSystemName:i] compare:value options:NSCaseInsensitiveSearch] == NSOrderedSame) {
			
			index = i;
			break;
		}
	}
	
	if (button == 1) {
		// Ok
		if (index !=-1)
			app.gamePlayer.currentGalaxySystem = index;
	
		if ([value compare:@"deadjimmy" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
			
			app.gamePlayer.credits += 1000000;
		}
		
	}
	
	if (button == 2) {
		// Ok
		if (index !=-1)
		app.gamePlayer.trackedSystem = index;
	}
	
	[self setNeedsDisplay];
}

-(IBAction)jump
{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	app.gamePlayer.warpSystem = app.gamePlayer.currentGalaxySystem;
	[app.gamePlayer doWarp:TRUE];
	app.gamePlayer.canSuperWarp = false;
	
}

#pragma mark -
#pragma mark === Touch handling  ===
#pragma mark

/*
 Checks to see which view, or views, the point is in and then calls a method to perform the opening animation,
 which  makes the piece slightly larger, as if it is being picked up by the user.
 */
-(void) dispatchFirstTouchAtPoint:(CGPoint)touchPoint forEvent:(UIEvent *)event
{
	//	if (CGRectContainsPoint([firstPieceView frame], touchPoint)) {
	//		[self animateFirstTouchAtPoint:touchPoint forView:firstPieceView];
	//	}
	//	if (CGRectContainsPoint([secondPieceView frame], touchPoint)) {
	//		[self animateFirstTouchAtPoint:touchPoint forView:secondPieceView];
	//	} 
	//	if (CGRectContainsPoint([thirdPieceView frame], touchPoint)) {
	//		[self animateFirstTouchAtPoint:touchPoint forView:thirdPieceView];
	//	}
	
}

// Handles the start of a touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	// Enumerate through all the touch objects.
	NSUInteger touchCount = 0;
	for (UITouch *touch in touches) {
	    // Send to the dispatch method, which will make sure the appropriate subview is acted upon
		[self dispatchFirstTouchAtPoint:[touch locationInView:self] forEvent:nil];
		touchCount++;  
	}	
}

/*
 Checks to see which view, or views, the point is in and then sets the center of each moved view to the new postion.
 If views are directly on top of each other, they move together.
 */
-(void) dispatchTouchEvent:(UIView *)theView toPosition:(CGPoint)position
{
	
}


// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{  
	
	NSUInteger touchCount = 0;
	
	// Enumerates through all touch objects
	for (UITouch *touch in touches){
		// Send to the dispatch method, which will make sure the appropriate subview is acted upon
	 	[self dispatchTouchEvent:[touch view] toPosition:[touch locationInView:self]];
	    touchCount++;
	}
	
}





/*
 Checks to see which view, or views,  the point is in and then calls a method to perform the closing animation,
 which is to return the piece to its original size, as if it is being put down by the user.
 */
-(void) dispatchTouchEndEvent:(UIView *)theView toPosition:(CGPoint)position
{   
	// Check to see which view, or views,  the point is in and then move to that position.
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	int i, index;
	
	index = [app.gamePlayer getCurrentSystemIndex ];//COMMANDER.CurSystem;

	{
		i = 0;
		
		while (i < MAXSOLARSYSTEM)
		{
			
			
			int Xp = (int)((float)[app.gamePlayer getSolarSystemX:i]*1.8) +GALAXYBOUNDSX-EXTRAERASE;
			int Yp = (int)((float)[app.gamePlayer getSolarSystemY:i]*2.8) +GALAXYBOUNDSY-EXTRAERASE;

			if ((ABS( Xp - (position.x) ) <= MINDISTANCEACTIVATE) &&
				(ABS( Yp - (position.y) ) <= MINDISTANCEACTIVATE))
				break;
			++i;
		}
		if (i < MAXSOLARSYSTEM)
		{
			app.gamePlayer.currentGalaxySystem = i;
			[self setNeedsDisplay];
		}
		
	}
	
	
}

// Handles the end of a touch event.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	
    // Enumerates through all touch object
    for (UITouch *touch in touches){
		// Sends to the dispatch method, which will make sure the appropriate subview is acted upon
		[self dispatchTouchEndEvent:[touch view] toPosition:[touch locationInView:self]];
	}
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	//	touchPhaseText.text = @"Phase: Touches cancelled";
    // Enumerates through all touch object
    for (UITouch *touch in touches){
		// Sends to the dispatch method, which will make sure the appropriate subview is acted upon
		[self dispatchTouchEndEvent:[touch view] toPosition:[touch locationInView:self]];
	}
}


@end
