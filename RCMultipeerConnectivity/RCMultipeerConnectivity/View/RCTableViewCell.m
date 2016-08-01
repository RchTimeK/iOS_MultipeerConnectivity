//
//  RCTableViewCell.m
//  RCMultipeerConnectivity
//
//  Created by RongCheng on 16/7/29.
//  Copyright © 2016年 RongCheng. All rights reserved.
//

#import "RCTableViewCell.h"
@interface RCTableViewCell  ()

{
    UIImageView *_iconImg;
    UILabel *_label;
    UIImageView *_BgView;
}
@end
@implementation RCTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _iconImg = [[UIImageView alloc] init];
        _iconImg.layer.masksToBounds=YES;
        _iconImg.layer.cornerRadius=25;
        _BgView = [[UIImageView alloc] init];
        _label = [[UILabel alloc] init];
        _label.frame = CGRectZero;
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:16];
        _label.numberOfLines = 0;
        _label.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_iconImg];
        [self.contentView addSubview:_BgView];
        [self.contentView addSubview:_label];
        [self setNeedsLayout];
        
    }
    return self;
}
- (void)setModel:(RCModel *)model{
    
    _model = model;
    _label.text = model.content;
    _iconImg.image = [UIImage imageNamed:model.icon];
    
    if ([model.icon isEqualToString:@"icon1.jpg"]) {
        _iconImg.frame = CGRectMake(WIDTH-20-50+10, 15, 50, 50);
        _BgView.image = [UIImage imageNamed:@"chatto_bg_normal"];
        _BgView.image = [_BgView.image stretchableImageWithLeftCapWidth:31 topCapHeight:31];
        _BgView.frame = CGRectMake(WIDTH-40-10*2-model.width-35, 10+10, model.width+35, model.height+25);
        _label.frame = CGRectMake(WIDTH-40-10*2-model.width-20, 10*2+10, model.width, model.height);
        [_label sizeToFit];
    }else if([model.icon isEqualToString:@"icon2.jpg"]){
        _iconImg.frame = CGRectMake(10, 15, 50, 50);
        _BgView.frame = CGRectMake(70, 20, model.width+40, model.height+35);
        _BgView.image = [UIImage imageNamed:@"chatfrom_bg_normal"];
        _BgView.image = [_BgView.image stretchableImageWithLeftCapWidth:30 topCapHeight:30];
        _BgView.frame = CGRectMake(40+10*2, 10+10, model.width+35, model.height+25);
        _label.frame = CGRectMake(40+10*2+20, 10*2+10, model.width,model.height);
        [_label sizeToFit];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
