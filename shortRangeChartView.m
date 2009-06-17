#import "shortRangeChartView.h"
#import <QuartzCore/QuartzCore.h>  // Needed for animations
#import "S1AppDelegate.h"
#import "SystemInfoViewController.h"
#import "player.h"
#import "warpViewController.h"

@interface shortRangeChartView()

@property (nonatomic) BOOL piecesOnTop;  
@property (nonatomic) CGPoint startTouchPosition;
@end


@interface shortRangeChartView (PrivateMethods)
-(UILabel *) newLabelWithOffset:(float)offset numberOfLines:(NSUInteger) lines;
-(UIImageView *)newPieceViewWithImageNamed:(NSString *)imageName atPostion:(CGPoint)centerPoint;
-(void)animateFirstTouchAtPoint:(CGPoint)touchPoint forView:(UIImageView *)theView;
-(void)animateView:(UIImageView *)theView toPosition:(CGPoint) thePosition;
-(void) dispatchFirstTouchAtPoint:(CGPoint)touchPoint forEvent:(UIEvent *)event;
-(void) dispatchTouchEvent:(UIView *)theView toPosition:(CGPoint)position;
-(void) dispatchTouchEndEvent:(UIView *)theView toPosition:(CGPoint)position;
-(void)drawView:(CGContextRef)context bounds:(CGRect)bounds;
@end


@implementation shortRangeChartView

#define GROW_ANIMATION_DURATION_SECONDS 0.15    // Determines how fast a piece size grows when it is moved.
#define SHRINK_ANIMATION_DURATION_SECONDS 0.15  // Determines how fast a piece size shrinks when a piece stops moving.

@synthesize piecesOnTop;
@synthesize startTouchPosition;

#pragma mark -
#pragma mark === Setting up and tearing down ===
#pragma mark

-(void)drawShortRange:(int)index {
	Index = index;
}

-(void) ShowAveragePriceInSystem
{
	
	
}

warpViewController * targetViewController = 0;

-(void) doWarp {
	if (targetViewController==0)
		targetViewController = [[warpViewController alloc] initWithNibName:@"warp" bundle:nil];
	//[self.window.navigationController pushViewController:targetViewController animated:YES];
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	[app.navigationController  pushViewController:targetViewController animated:YES];
	//[targetViewController release];
	//[targetViewController Update
	//[app.gamePlayer doWarp:false];
}

-(void)drawRect:(CGRect) rect 
{
	[self drawView:UIGraphicsGetCurrentContext() bounds:self.bounds];
}

- (void)didMoveToWindow {
	
	Index = -1;
	
	[super didMoveToWindow];
	//[self drawRect:CGRectMake(0,0,0,0)];
	[self setNeedsDisplay];
}


#define STRING_INDENT 20

-(void)drawView:(CGContextRef)context bounds:(CGRect)bounds
{
//	context = UIGraphicsGetCurrentContext();
//	if (context == nil)
//		return;
	int Xs = (int)((SHORTRANGEWIDTH >> 1) + SHORTRANGEBOUNDSX);
	int Ys = (int)((SHORTRANGEHEIGHT >> 1) + BOUNDSY);
	int delta = (SHORTRANGEWIDTH / (MAXRANGE << 1));
	
	
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
	CGContextDrawImage(context,  CGRectMake(0, -0,  backgroundSize.width, backgroundSize.height) , background);
	
	//FIXME:!!!
	if (Index == -1)
		Index = [app.gamePlayer getCurrentSystemIndex];
	
	// Drawing lines with a white stroke color
	CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
	// Draw them with a 2.0 stroke width so they are a bit more visible.
	CGContextSetLineWidth(context, 2.0);	
	
	int fuel = [app.gamePlayer getFuel];
	if (fuel)
	{
		CGContextAddArc(context, Xs, Ys,  fuel * delta, 0, 2*3.1416f, 1);
	}
	
	CGContextStrokePath(context);
	
	if (app.gamePlayer.trackedSystem >= 0)
	{
		long distToTracked = [app.gamePlayer realDistance:[app.gamePlayer getCurrentSystemIndex] b:app.gamePlayer.trackedSystem];//   b:<#(int)b#> RealDistance(SolarSystem[COMMANDER.CurSystem], SolarSystem[TrackedSystem]);
		if (distToTracked > 0)
		{		
			
			int dX = (int)(25.0 * ((float)[app.gamePlayer getSolarSystemX:[app.gamePlayer getCurrentSystemIndex]]  - (float)[app.gamePlayer getSolarSystemX:app.gamePlayer.trackedSystem] ) / 
					   (float)distToTracked);
			int dY = (int)(25.0 * ((float)[app.gamePlayer getSolarSystemY:[app.gamePlayer getCurrentSystemIndex]]  - (float)[app.gamePlayer getSolarSystemY:app.gamePlayer.trackedSystem]) / 
					   (float)distToTracked);
			
			// draw directional arrow from planet -- I'd do this in color if it were easier.
			
			int dY3 = -(int)(4.0 * ((float)[app.gamePlayer getSolarSystemX:[app.gamePlayer getCurrentSystemIndex]]  - (float)[app.gamePlayer getSolarSystemX:app.gamePlayer.trackedSystem]) / 
						 (float)distToTracked);		
			int dX3 = (int)(4.0 * ((float)[app.gamePlayer getSolarSystemY:[app.gamePlayer getCurrentSystemIndex]]  - (float)[app.gamePlayer getSolarSystemY:app.gamePlayer.trackedSystem]) / 
						(float)distToTracked);
			
			CGContextMoveToPoint(context,  Xs - dX,Ys - dY);
			CGContextAddLineToPoint(context,Xs - dX3,Ys - dY3);
			CGContextStrokePath(context);
			
			CGContextMoveToPoint(context,  Xs - dX,Ys - dY);
			CGContextAddLineToPoint(context, Xs + dX3, Ys + dY3);
			CGContextStrokePath(context);
			
		
		}
	}

	
	
	// Two loops: first draw the names and then the systems. The names may
	// overlap and the systems may be drawn on the names, but at least every
	// system is visible.
	int j, i, Xp, Yp;
	for (j=0; j<2; ++j)
	{
		for (i=0; i<MAXSOLARSYSTEM; ++i)
		{
			if ((ABS( [app.gamePlayer getSolarSystemX:i]  - [app.gamePlayer getSolarSystemX:Index]  ) <= MAXRANGE) &&
				(ABS( [app.gamePlayer getSolarSystemY:i]  - [app.gamePlayer getSolarSystemY:Index] ) <= MAXRANGE))
			{
				Xp = (int)((SHORTRANGEWIDTH >> 1) + 
						   ([app.gamePlayer getSolarSystemX:i]  - [app.gamePlayer getSolarSystemX:Index]) * 
						   (SHORTRANGEWIDTH / (MAXRANGE << 1)) +
						   SHORTRANGEBOUNDSX - EXTRAERASE);
				Yp = (int)((SHORTRANGEHEIGHT >> 1) + 
						   ([app.gamePlayer getSolarSystemY:i]  - [app.gamePlayer getSolarSystemY:Index] ) * 
						   (SHORTRANGEHEIGHT / (MAXRANGE << 1)) +
						   BOUNDSY - EXTRAERASE);
				if (j == 1)
				{
					if (i == [app.gamePlayer warpSystem])
					{
						CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);
						CGContextMoveToPoint(context, Xp-4, Yp+7);
						CGContextAddLineToPoint(context, Xp+16, Yp+7);
						CGContextStrokePath(context);

						CGContextMoveToPoint(context, Xp+7, Yp-4);
						CGContextAddLineToPoint(context, Xp+7, Yp+16);
						CGContextStrokePath(context);
						CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
						
					}
					if ([app.gamePlayer getSolarSystemVisited:i]) {
						//[blueDot drawAtPoint:CGPointMake(Xp, Yp)];
						CGContextDrawImage(context,  CGRectMake(Xp, Yp,  blueDotSize.width, blueDotSize.height) , blueDot);

					} else {
						//[greenDot drawAtPoint:CGPointMake(Xp, Yp)];
						CGContextDrawImage(context,  CGRectMake(Xp, Yp, greenDotSize.width, blueDotSize.height) , greenDot);						
					}

					
					if ([app.gamePlayer wormholeExists:i b:-1 ])
					{
						delta = WORMHOLEDISTANCE * (SHORTRANGEWIDTH / (MAXRANGE << 1));
						if ([app.gamePlayer wormholeExists:i b:app.gamePlayer.warpSystem])
						{
					
							CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);
							CGContextMoveToPoint(context, Xp+delta/2-2, Yp+7+delta/2+4);
							CGContextAddLineToPoint(context, Xp+18+delta/2+6, Yp+7+delta/2+4);
							CGContextStrokePath(context);
							
							CGContextMoveToPoint(context, Xp+7+delta/2+4, Yp-4+delta/2+2);
							CGContextAddLineToPoint(context, Xp+7+delta/2+4, Yp+18+delta/2+6);
							CGContextStrokePath(context);
							CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);	
							
//							WinDrawLine( Xp-2+delta, Yp+3, Xp+8+delta, Yp+3 );
//							WinDrawLine( Xp+3+delta, Yp-2, Xp+3+delta, Yp+8 );
						}
						CGContextDrawImage(context,  CGRectMake(Xp+delta/2, Yp+delta/2, redDotSize.width, redDotSize.height) , redDot);	
					}
					
				}
				else
				{
					[[UIColor whiteColor] set];
					CGPoint point = CGPointMake(Xp, Yp - 12);
					float fontSize = 9.0;
					UIFont *font = [UIFont systemFontOfSize:fontSize];

					NSString * currentDisplayString = [app.gamePlayer getSolarSystemName:i];
					[currentDisplayString drawAtPoint:point forWidth:(self.bounds.size.width-STRING_INDENT) withFont:font fontSize:fontSize lineBreakMode:UILineBreakModeMiddleTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines]; 					
				}
					 
					
			}
		}
	}
	
	// if they're tracking, and they want range info:
	if (app.gamePlayer.trackedSystem >= 0 && app.gamePlayer.showTrackedRange)
	{
		/*
		StrPrintF(SBuf, "%d", distToTracked);
		StrCat(SBuf, " parsecs to ");
		StrCat(SBuf, SolarSystemName[SolarSystem[TrackedSystem].NameIndex]);
		DrawChars( SBuf, 0, 149);
		 */
	}
 	
}

/*
 Unarchives the view that is stored in the xib file.
 Initializes the main view and adds three subviews, each of which have the appearance of a piece that the user can move.
 Also creates two text labels, one that displays the touch phase, and the other that displays touch information (such as swipe, number of touches). 
 */
- (id)initWithCoder:(NSCoder*)coder 
{
	if (self = [super initWithCoder:coder]) {
		
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

		{
			UIImage *img = [UIImage imageNamed:@"ShortRange3.png"];
			background = CGImageRetain(img.CGImage);
			backgroundSize = img.size;
		}
		
		
		Index = -1;
		// Set up the ability to track multiple touches.
		[self setMultipleTouchEnabled:NO];
	}
	return self;
}




// Releases necessary resources. 
- (void)dealloc
{

	// Release the labels
	CGImageRelease(redDot);
	CGImageRelease(blueDot);
	CGImageRelease(greenDot);

	[super dealloc];	
}

#pragma mark -
#pragma mark === Touch handling  ===
#pragma mark

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
 Checks to see which view, or views, the point is in and then sets the center of each moved view to the new postion.
 If views are directly on top of each other, they move together.
 */
-(void) dispatchTouchEvent:(UIView *)theView toPosition:(CGPoint)position
{

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

/*
 Checks to see which view, or views,  the point is in and then calls a method to perform the closing animation,
 which is to return the piece to its original size, as if it is being put down by the user.
 */
-(void) dispatchTouchEndEvent:(UIView *)theView toPosition:(CGPoint)position
{   
	// Check to see which view, or views,  the point is in and then move to that position.
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	int Xp, Yp, i, index;

	index = [app.gamePlayer getCurrentSystemIndex ];//COMMANDER.CurSystem;
	
	i = 0;
	while (i < MAXWORMHOLE)
	{
		Xp = (int)((SHORTRANGEWIDTH >> 1) + 
				   
				   ([app.gamePlayer getSolarSystemX:[app.gamePlayer getWormhole:i]] + WORMHOLEDISTANCE - [app.gamePlayer getSolarSystemX:index]) * 
				   (SHORTRANGEWIDTH / (MAXRANGE << 1)) +
				   SHORTRANGEBOUNDSX);
		Yp = (int)((SHORTRANGEHEIGHT >> 1) + 
				   ([app.gamePlayer getSolarSystemY:[app.gamePlayer getWormhole:i]] - [app.gamePlayer getSolarSystemY:index]) * 
				   (SHORTRANGEHEIGHT / (MAXRANGE << 1)) +
				   BOUNDSY);
		if ((ABS( Xp - (position.x) ) <= MINDISTANCEACTIVATE) &&
			(ABS( Yp - (position.y) ) <= MINDISTANCEACTIVATE))
			break;
		++i;
	}
	if (i < MAXWORMHOLE)
	{
		if (index != [app.gamePlayer getWormhole:i]) {
			
		}
		//FrmCustomAlert( WormholeOutOfRangeAlert, SolarSystemName[i < MAXWORMHOLE-1 ? Wormhole[i+1] : Wormhole[0]], SolarSystemName[Wormhole[i]], "" );
		else
		{
			app.gamePlayer.warpSystem = (i < MAXWORMHOLE-1 ? [app.gamePlayer getWormhole:i+1] : [app.gamePlayer getWormhole:0] );
			if (!app.gamePlayer.alwaysInfo)
				[self ShowAveragePriceInSystem];
			else
				[self doWarp];
			return;
		}
	}
	
	
	
	
	
	if ((position.x >= SHORTRANGEBOUNDSX-EXTRAERASE) &&
		(position.x <= SHORTRANGEBOUNDSX+SHORTRANGEWIDTH+EXTRAERASE) &&
		(position.y >= BOUNDSY-EXTRAERASE) &&
		(position.y <= BOUNDSY+SHORTRANGEHEIGHT+EXTRAERASE))
	{
		i = 0;

		while (i < MAXSOLARSYSTEM)
		{
			Xp = (int)((SHORTRANGEWIDTH >> 1) + 
					   ([app.gamePlayer getSolarSystemX:i]  - [app.gamePlayer getSolarSystemX:index]) * 
					   (SHORTRANGEWIDTH / (MAXRANGE << 1)) +
					   SHORTRANGEBOUNDSX);
			Yp = (int)((SHORTRANGEHEIGHT >> 1) + 
					   ([app.gamePlayer getSolarSystemY:i]  - [app.gamePlayer getSolarSystemY:index]) * 
					   (SHORTRANGEHEIGHT / (MAXRANGE << 1)) +
					   BOUNDSY);
			if ((ABS( Xp - (position.x) ) <= MINDISTANCEACTIVATE) &&
				(ABS( Yp - (position.y) ) <= MINDISTANCEACTIVATE))
				break;
			++i;
		}
		if (i < MAXSOLARSYSTEM)
		{
			app.gamePlayer.warpSystem = i;
			if (!app.gamePlayer.alwaysInfo  && [app.gamePlayer realDistance: [app.gamePlayer getCurrentSystemIndex] b:app.gamePlayer.warpSystem] <= [app.gamePlayer getFuel] &&
				[app.gamePlayer realDistance: [app.gamePlayer getCurrentSystemIndex] b:app.gamePlayer.warpSystem] > 0) {
				
				[self ShowAveragePriceInSystem];
				
				// FIXME::!!!!!
			}
			else
				[self doWarp];
			//CurForm = ExecuteWarpForm;
		}
		
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

#pragma mark -
#pragma mark === Animating subviews ===
#pragma mark

// Scales up a view slightly which makes the piece slightly larger, as if it is being picked up by the user.
- (void)animateFirstTouchAtPoint:(CGPoint)touchPoint forView:(UIImageView *)theView 
{
	// Pulse the view by scaling up, then move the view to under the finger.
//	NSValue *touchPointValue = [[NSValue valueWithCGPoint:touchPoint] retain];
//	[UIView beginAnimations:nil context:touchPointValue];
//	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
//	CGAffineTransform transform = CGAffineTransformMakeScale(1.2, 1.2);
//	theView.transform = transform;
//	[UIView commitAnimations];
}

// Scales down the view and moves it to the new position. 
- (void)animateView:(UIImageView *)theView toPosition:(CGPoint) thePosition
{
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:SHRINK_ANIMATION_DURATION_SECONDS];
	// Set the center to the final postion
//	theView.center = thePosition;
	// Set the transform back to the identity, thus undoing the previous scaling effect.
//	theView.transform = CGAffineTransformIdentity;
//	[UIView commitAnimations];	
}


@end
