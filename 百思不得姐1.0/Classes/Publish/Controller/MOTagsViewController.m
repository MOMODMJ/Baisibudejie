//
//  MOTagsViewController.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/23.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOTagsViewController.h"
#import "MOTagButton.h"

@interface MOTagsViewController ()
/*标签内容View*/
@property (nonatomic,weak) UIView *contentView;
/** 文本输入框 */
@property (nonatomic, weak) UITextField *textField;

/** 添加按钮 */
@property (nonatomic, weak) UIButton *addButton;
/** 所有的标签按钮 */
@property (nonatomic, strong) NSMutableArray *tagButtons;
@end

@implementation MOTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupContentView];
    
    [self setupTextfield];
}

#pragma mark -  第一步
- (void)setupNav{
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setupContentView{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, MAINSCREENWIDTH, MAINSCREENHEIGHT-64)];
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

- (void)setupTextfield{
    UITextField *textField = [[UITextField alloc]init];
    textField.width = MAINSCREENWIDTH;
    textField.height = 25;
    textField.placeholder = @"多个标签用逗号或者换行隔开";
    
    // 设置了占位文字内容以后, 才能设置占位文字的颜色
    [textField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [textField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
    [textField becomeFirstResponder];

    
    [self.contentView addSubview:textField];
    self.textField = textField;
}

#pragma mark -  第二步

//懒加载 负责装载 标签 的数组
- (NSMutableArray *)tagButtons
{
    if (!_tagButtons) {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

//懒加载蓝色添加标签，与textfield下方同步显示。 标签1号-只显示，故只需要创建一次！
- (UIButton *)addButton
{
    //判断加载
    if (!_addButton) {
        //创建添加按钮
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //设置button的frame，以便显示出来
        addButton.width = self.contentView.width;
        addButton.height = 35;
        
        //设置文字颜色，大小，背景颜色
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        addButton.titleLabel.font = [UIFont systemFontOfSize:14];
        addButton.backgroundColor = [UIColor blueColor];
        
        //设置内边距
        addButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
       
        // 让按钮内部的文字和图片都左对齐
        addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        //添加到内容视图里
        [self.contentView addSubview:addButton];
        
        //添加点击方法
        [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        //保存
        _addButton = addButton;
    }
    return _addButton;
}

// 添加一个"标签按钮"， 标签2号， 添加到contentView中的蓝色标签
- (void)addButtonClick{
    
    //封装一个标签按钮
    MOTagButton *tagButton = [MOTagButton buttonWithType:UIButtonTypeCustom];
    
    
    //tagbutton的文字与textfield同步
    [tagButton setTitle:self.textField.text forState:UIControlStateNormal];
    tagButton.height = self.textField.height;
    
    //加入到contentView中
    [self.contentView addSubview:tagButton];
    
    //加入到可变数组中
    [self.tagButtons addObject:tagButton];
    
    // 更新标签按钮的frame
    [self updateTagButtonFrame];
    
    // 清空textField文字
    self.textField.text = nil;
    self.addButton.hidden = YES;
    
    //给标签按钮加方法，删除要用到
    [tagButton addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - 删除标签
- (void)tagButtonClick:(MOTagButton *)tagButton{
    
    [tagButton removeFromSuperview];
    [self.tagButtons removeObject:tagButton];
    
    // 重新更新所有标签按钮的frame
    [UIView animateWithDuration:0.25 animations:^{
        [self updateTagButtonFrame];
    }];
}

//文字改变时要执行的操作：蓝色标签的显示隐藏，以及位置，显示内容和标签文本框的最终frame
- (void)textDidChange{
    
    if (self.textField.hasText) { // 有文字
        // 显示"添加标签"的按钮,把textfield的文字赋给按钮，同步显示
        self.addButton.hidden = NO;
        self.addButton.y = CGRectGetMaxY(self.textField.frame) + 10;
        [self.addButton setTitle:[NSString stringWithFormat:@"添加标签: %@", self.textField.text] forState:UIControlStateNormal];
    } else { // 没有文字
        // 隐藏"添加标签"的按钮
        self.addButton.hidden = YES;
    }
    
    // 更新标签和文本框的frame
    [self updateTagButtonFrame];
    
}


//更新标签，文本框最终的frame
- (void)updateTagButtonFrame{
    
    // 更新标签按钮的frame
    for (int i = 0; i<self.tagButtons.count; i++) {
        MOTagButton *tagButton = self.tagButtons[i];
        
        if (i == 0) { // 最前面的标签按钮
            tagButton.x = 0;
            tagButton.y = 0;
        } else { // 其他标签按钮
            MOTagButton *lastTagButton = self.tagButtons[i - 1];
            // 计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + 5;
            // 计算当前行右边的宽度
            CGFloat rightWidth = self.contentView.width - leftWidth;
            if (rightWidth >= tagButton.width) { // 按钮显示在当前行
                tagButton.y = lastTagButton.y;
                tagButton.x = leftWidth;
            } else { // 按钮显示在下一行
                tagButton.x = 0;
                tagButton.y = CGRectGetMaxY(lastTagButton.frame) + 5;
            }
        }
    }
    
    // 最后一个标签按钮
    MOTagButton *lastTagButton = [self.tagButtons lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + 5;
    
    // 更新textField的frame
    if (self.contentView.width - leftWidth >= [self textFieldTextWidth]) {
        self.textField.y = lastTagButton.y;
        self.textField.x = leftWidth;
    } else {
        self.textField.x = 0;
        self.textField.y = CGRectGetMaxY(lastTagButton.frame) + 5;
    }
}
/**
 * textField的文字宽度
 */
- (CGFloat)textFieldTextWidth
{
    CGFloat textW = [self.textField.text sizeWithAttributes:@{NSFontAttributeName : self.textField.font}].width;
    return MAX(100, textW);
}
#pragma mark - 最后一步
- (void)done{
    
}




@end
