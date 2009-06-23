#import "HelpViewControllerRENAME.h"

@implementation HelpViewControllerRENAME

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DNHELP" ofType:@"html"];  
	NSData *htmlData = [NSData dataWithContentsOfFile:filePath];  
	if (htmlData) {  
		[webView loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@"http://noplacehere.com"]];  
	} 
}
@end
