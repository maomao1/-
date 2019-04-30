//
//  CRFDetailCell.m
//  crf_purse
//
//  Created by maomao on 2017/7/27.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFDetailTableViewCell.h"
#import "CRFMessageModel.h"
#import "CRFActivity.h"
@interface CRFDetailTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
@implementation CRFDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}
- (void)crfSetContent:(id)item{
    if ([item isKindOfClass:[CRFMessageModel class]]) {
        CRFMessageModel *model  = item;
        self.titleLabel.text    = model.subject;
        self.contentLabel.attributedText  =[self setLabelAttribute:model.content];
        self.timeLabel.text = [CRFTimeUtil formatLongTime:model.pushTime.longLongValue pattern:@"yyyy-MM-dd HH:mm"];
    }else if ([item isKindOfClass:[CRFActivity class]]){
        CRFActivity *model  = item;
        self.titleLabel.text    = model.title;
        self.contentLabel.attributedText  =[self setLabelAttribute:model.content];
        self.timeLabel.text     = [CRFTimeUtil formatLongTime:model.publicTime.longLongValue pattern:@"yyyy-MM-dd HH:mm"];
    }
}
- (NSMutableAttributedString*)setLabelAttribute:(NSString*)textStr{
    if (textStr.length) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textStr];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textStr length])];
        return attributedString;
    }
    return nil;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
