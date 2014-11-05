//
//  ViewController.m
//  MySafari
//
//  Created by miganbec on 05/11/14.
//  Copyright (c) 2014 miganbec. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) CGFloat lastContentOffset;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.urlTextField becomeFirstResponder];
    self.webView.scrollView.delegate = self;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.titleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.urlTextField.text = [webView.request.URL absoluteString];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *urlString = self.urlTextField.text;
    [self loadWebPage:urlString];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField.text.length == 0) {
        textField.placeholder = @"Ingresa una dirección";
    }
    return YES;
}

- (void) loadURLString: (NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (IBAction)onBackButtonPressed:(id)sender {
    if (![self.webView canGoBack]) {
        NSLog(@"No se puede ir hacia atrás");
    } else {
        [self.webView goBack];
    }
}

- (IBAction)onForwardButtonPressed:(id)sender {
    if (![self.webView canGoForward]) {
        NSLog(@"No se puede ir hacia adelante");
    } else {
        [self.webView goForward];
    }
}
- (IBAction)onStopLoadingButtonPressed:(id)sender {
    [self.webView stopLoading];
}

- (IBAction)onReloadButtonPressed:(id)sender {
    [self.webView reload];
}

- (void) loadWebPage:(NSString *)urlString {
    if ([urlString rangeOfString:@"https://" options:NSAnchoredSearch].location == NSNotFound) {
        NSString *urlWithHttpAdded = [NSString stringWithFormat:@"https://%@", urlString];
        NSLog(@"Escribió: %@", urlString);
        NSLog(@"Se envía: %@", urlWithHttpAdded);
        [self loadURLString:urlWithHttpAdded];
    } else {
        [self loadURLString:urlString];
    }
}

- (IBAction)onPlusButtonPressed:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.message = @"¡Próximamente!";
    [alertView addButtonWithTitle:@"Ok"];
    [alertView show];
}

- (IBAction)onClearButtonPressed:(id)sender {
    self.urlTextField.text = nil;
    self.urlTextField.placeholder = @"Ingresa una dirección";
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.lastContentOffset = scrollView.contentOffset.y;
    if (self.lastContentOffset < scrollView.contentOffset.y) {
        self.urlTextField.alpha = 0.0;
    } else {
        self.urlTextField.alpha = 1.0;
    }
}

@end
