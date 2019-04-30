//
//  CRFBaseCell.m
//  crf_purse
//
//  Created by maomao on 2017/7/20.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBaseCell.h"
@interface CRFBaseCell()
@property  (nonatomic , strong) UIView   *cellLine;
@end
@implementation CRFBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UIView *)cellLine {
    if (_cellLine == nil) {
        _cellLine = [[UIView alloc] init];
    }
    return _cellLine;
}

- (void)crfSetCellLine {
    [self.contentView addSubview:self.cellLine];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    NSString *strClassName = NSStringFromClass([self class]);
    self = [super initWithStyle:style reuseIdentifier:strClassName];
    if (self) {
        //将Custom.xib中的所有对象载入
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:strClassName owner:nil options:nil];
        //第一个对象就是CustomCell了
        if (nib.count>0) {
            self = [nib objectAtIndex:0];
        }
    }
    return self;
}

+ (instancetype)crfReuseIdentifier:(UITableView *)tableView {
    static NSString *reuseIdentifier = @"CRFBaseCellIdentifer";
    CRFBaseCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[self class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    } else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    return cell;
}

+ (instancetype)crfReuseIdentifier:(UITableView *)tableView index:(NSInteger)index {
    static NSString *reuseIdentifier = @"CRFBaseCellIdentifer";
    CRFBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell==nil) {
        NSArray *arrCell=[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        cell = [arrCell objectAtIndex:index];
        if(!cell.tag) {
            cell.tag = index;
        }
        [cell setClipsToBounds:YES];
    } else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    return cell;
}

- (void)crfSetContent:(id)item {
    
}
@end
