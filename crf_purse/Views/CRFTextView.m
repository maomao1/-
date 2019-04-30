//
//  CRFTextView.m
//  crf_purse
//
//  Created by maomao on 2017/7/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFTextView.h"
static CGFloat placeholderOffset = 0;
@interface CRFTextView()<UITextViewDelegate>{
    UILabel *_placeholderLabel;
    UILabel *_maxTextLengthLabel;
    NSInteger _maxTextLength;
    BOOL _isListenSelfSuperView;
}

@end
@implementation CRFTextView
- (void)setPlaceholder:(NSString *)placeholder {
    
    if (_placeholderLabel == nil) {
        _placeholderLabel = [[UILabel alloc] initWithFrame: CGRectMake(placeholderOffset+5, placeholderOffset, CGRectGetWidth(self.bounds) - placeholderOffset * 2, 20)];
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.userInteractionEnabled = false;
        _placeholderLabel.textColor = [UIColor colorWithWhite:0.75 alpha:1.000];
        
        _placeholderLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _placeholderLabel.font = self.font;
        [self addSubview: _placeholderLabel];
        [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(listenTextView:) name:UITextViewTextDidBeginEditingNotification object:self];
        [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(listenTextView:) name:UITextViewTextDidEndEditingNotification object:self];
        [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(listenTextView:) name:UITextViewTextDidChangeNotification object:self];
        
        self.textContainerInset = UIEdgeInsetsMake(placeholderOffset, placeholderOffset, placeholderOffset * 2, placeholderOffset);
        _placeholderLabel.hidden = self.text.length ? true : false;
        if(self.changeBlock){
            self.changeBlock();
        }
    }
    if ([placeholder isEqualToString:@""]) {
        [_maxTextLengthLabel removeFromSuperview];
    }
    _placeholderLabel.text = placeholder;
}

- (void)setMaxTextLength:(NSInteger)maxTextLength {
    _maxTextLength = maxTextLength;
    self.delegate = self;
    [_maxTextLengthLabel removeFromSuperview];
    _maxTextLengthLabel = [[UILabel alloc] init];
    _maxTextLengthLabel.backgroundColor = [UIColor clearColor];
    _maxTextLengthLabel.userInteractionEnabled = false;
    _maxTextLengthLabel.textAlignment = NSTextAlignmentRight;
    _maxTextLengthLabel.textColor = UIColorFromRGBValue(0xbbbbbb);
    _maxTextLengthLabel.font = [UIFont systemFontOfSize: 16];
    
    UIView *superView = self.superview;
    
    if (superView == nil) {
        _isListenSelfSuperView = true;
        [self addObserver: self forKeyPath: @"superview" options: NSKeyValueObservingOptionNew context: nil];
    }
    else {
        
        _maxTextLengthLabel.frame = CGRectMake(CGRectGetMinX(self.frame) - 3, CGRectGetMaxY(self.frame) - 16, CGRectGetWidth(self.frame), 16);
        [superView addSubview: _maxTextLengthLabel];
        
        if (self.autoresizingMask == (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)) {
            
            _maxTextLengthLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        }
        else {
            
            if ([superView.superview isKindOfClass: [UITableViewCell class]]) {
                _maxTextLengthLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
            }
            else {
                _maxTextLengthLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
            }
        }
    }
    [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(listenTextView:) name:UITextViewTextDidChangeNotification object:nil];
    
    [self updateTextLength];
}

- (void)setFinishBlock:(CRFTextViewFinishBlock)finishBlock {
    _finishBlock = finishBlock;
    self.delegate = self;
}
- (void)dealloc {
    
    if (_isListenSelfSuperView) {
        [self removeObserver: self forKeyPath: @"superview"];
    }
    
    [CRFNotificationUtils removeObserver:self];
     DLog(@"dealloc is %@",NSStringFromClass([self class]));
}

- (void)setText:(NSString *)text {
    [super setText: text];
    _placeholderLabel.hidden = text.length ? true : false;
    if (self.changeBlock) {
        self.changeBlock();
    }
    
    [self updateTextLength];
}

#pragma mark - Private methods

- (void)updateTextLength {
    
    _placeholderLabel.hidden = self.text.length ? true : false;
    if (self.text.length > _maxTextLength) {
        self.text = [self.text substringToIndex:_maxTextLength] ;
        [self showAlert];
    }
    NSInteger length = self.text.length;
    _maxTextLengthLabel.text = [NSString stringWithFormat: @"%@/%@",@(length),@(_maxTextLength)];
    if (self.changeBlock) {
        self.changeBlock();
    }
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString: @"superview"]) {
        
        CGRect converFrame = [self convertRect: self.frame fromView: self.superview];
        _maxTextLengthLabel.frame = CGRectMake(CGRectGetMinX(converFrame) - 3, CGRectGetMaxY(converFrame) - 16, CGRectGetWidth(converFrame), 16);
        [self.superview addSubview: _maxTextLengthLabel];
        
        if (self.autoresizingMask == (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)) {
            
            _maxTextLengthLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        }
        else {
            
            _maxTextLengthLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        }
    }
}

#pragma mark NSNotification methods

- (void)listenTextView:(NSNotification*)notification {
    
    if (notification.object != self) {
        return;
    }
    
    if ([notification.name isEqualToString: UITextViewTextDidBeginEditingNotification]) {
        _placeholderLabel.hidden = self.text.length ? true : false;
        
    }
    else if ([notification.name isEqualToString: UITextViewTextDidEndEditingNotification]) {
        _placeholderLabel.hidden = self.text.length ? true : false;
        
    }
    else if ([notification.name isEqualToString: UITextViewTextDidChangeNotification]) {
        
        [self updateTextLength];
    }
    if (self.changeBlock) {
        self.changeBlock();
    }
}

#pragma mark -
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    if (_finishBlock) {
        _finishBlock(textView.text);
    }
    
    return YES ;
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (self.mm_didEdit) {
        self.mm_didEdit();
    }
}

- (void)showAlert{
    [self resignFirstResponder];
    [CRFUtils showMessage:[NSString stringWithFormat: @"内容在%@字以内",@(_maxTextLength)]];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (range.location>_maxTextLength-1 && _maxTextLength>0) {
        
        [self showAlert];
        return NO ;
    }
    
    return true;
}

@end
