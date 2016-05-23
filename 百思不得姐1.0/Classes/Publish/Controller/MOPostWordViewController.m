//
//  MOPostWordViewController.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/20.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOPostWordViewController.h"
#import "MOPublishView.h"
#import "MOPlaceholderTextView.h"
#import "MOAddTagsToolBarView.h"
#import "MOTagsViewController.h"

@interface MOPostWordViewController ()<UITextViewDelegate>

/*发布文字界面的textView*/
@property (nonatomic,weak) MOPlaceholderTextView *textView;
/*toolbar*/
@property (nonatomic,weak) MOAddTagsToolBarView *toolbar;
@end

@implementation MOPostWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupTextView];
    
    [self setupToolBar];
    
}

- (void)setupNav{
    self.title = @"发表文字";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;//默认不能点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeEnabled) name:UITextViewTextDidChangeNotification object:nil];
    
    [self.navigationController.navigationBar layoutIfNeeded];
    
    
}

- (void)setupTextView{
    MOPlaceholderTextView *placeholdertextView  = [[MOPlaceholderTextView alloc]init];
    placeholdertextView.frame = self.view.bounds;
    placeholdertextView.placeholdertext = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。";
    self.textView =  placeholdertextView;
     placeholdertextView.delegate = self;
    [self.view addSubview: placeholdertextView];

}

- (void)setupToolBar{
    MOAddTagsToolBarView *toolbar = [MOAddTagsToolBarView toolbar];
    
    toolbar.width = self.view.width;
    toolbar.y = self.view.height - toolbar.height;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(presentView) name:@"addtagsViewController" object:nil];
}
- (void)presentView{
    MOTagsViewController *tagsV =[[MOTagsViewController alloc]init];
    [self.navigationController pushViewController:tagsV animated:YES];
}

//监听键盘的弹出和隐藏g
- (void)keyboardWillChangeFrame:(NSNotification *)note{
    //键盘最终的frame
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, keyboardF.origin.y-MAINSCREENHEIGHT);
    }];
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)becomeEnabled{
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)cancel{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)post{
    
    MOLog(@"发布点击");
}

//让textView成为第一响应者，在拖拉的时候才能退掉键盘
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
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
