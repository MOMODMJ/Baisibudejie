//
//  MOWebViewController.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/19.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOWebViewController.h"
#import "MOSquare.h"
#import "MOSquareButton.h"
@interface MOWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBack;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForward;

@end

@implementation MOWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = square.name;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goBack:(id)sender {
    [self.webView goBack];
}
- (IBAction)goForward:(id)sender {
    [self.webView goForward];
}

- (IBAction)refresh:(id)sender {
    [self.webView reload];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
