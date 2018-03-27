//
//  WebChatMessageEmojiView.m
//  WebChat
//
//  Created by Jack on 2017/12/13.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "WebChatMessageEmojiView.h"
#import "WebChatMessageEmojiCollectionCell.h"
#import "WebChatCustomHorizontalLayout.h"
#import <Masonry.h>

#define kHeightFaceView              (170)
//表情个数
#define kFaceNum                      (69)
//发送按钮默认高度
#define kHeightBtn                    (30)
//表情重用ID
#define kExpressionID                 (@"Expression")

#define kBkColorSendBtn               ([UIColor colorWithRed:0.090 green:0.490 blue:0.976 alpha:1])
#define kUnSelectedColorPageControl   ([UIColor colorWithRed:0.604 green:0.608 blue:0.616 alpha:1])
#define kSelectedColorPageControl     ([UIColor colorWithRed:0.380 green:0.416 blue:0.463 alpha:1])
@interface WebChatMessageEmojiView ()<UICollectionViewDataSource,UICollectionViewDelegate,UIInputViewAudioFeedback>
{
    UICollectionView  *mCollectionView;
    UIPageControl     *mPageControl;
}
//CollectionView数据源
@property(nonatomic,retain)NSArray *DataSource;

@end
@implementation WebChatMessageEmojiView
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setUI];
    }
    return self;
}

-(NSArray *)DataSource
{
    if (!_DataSource) {
        NSMutableArray *mutable = [NSMutableArray arrayWithCapacity:84];
        for (int i=0; i<84; i++)
        {
            if(i == 20 || i == 41 || i == 62 || i == 83)
            {
                [mutable addObject:@{@"aImage":@"aio_face_delete"}];
            }else{
                [mutable addObject:@{@"aImage":[NSString stringWithFormat:@"%d",i]}];
            }
        }
        _DataSource = mutable;
    }
    return _DataSource;
}
#pragma 初始化UI界面
-(void)setUI{
    
    self.backgroundColor = [UIColor clearColor];
    
    WebChatCustomHorizontalLayout * layout =[[WebChatCustomHorizontalLayout alloc]initWithitemCountPerRow:7 AndrowCount:3];
    [layout setItemSize:CGSizeMake([UIScreen mainScreen].bounds.size.width/7-10, (kHeightFaceView - kHeightBtn)/3-20)];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(6,6,6, 6);
    
    mCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [self addSubview:mCollectionView];
    mCollectionView.pagingEnabled = YES;
    mCollectionView.showsHorizontalScrollIndicator = NO;
    mCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    mCollectionView.backgroundColor = [UIColor  clearColor];
    mCollectionView.dataSource = self;
    mCollectionView.delegate   = self;
    [mCollectionView registerClass:[WebChatMessageEmojiCollectionCell class] forCellWithReuseIdentifier:kExpressionID];
    
    [mCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
    }];
    
    //发送按钮
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:sendBtn];
    sendBtn.layer.cornerRadius=10;
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendExpression) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    sendBtn.translatesAutoresizingMaskIntoConstraints = NO;
    sendBtn.backgroundColor = kBkColorSendBtn;
    
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
        make.top.equalTo(mCollectionView.mas_bottom).offset(20);
        make.bottom.equalTo(self.mas_bottom).offset(-6);
        make.right.equalTo(self.mas_right).offset(-6);
        
    }];
    
    //PageControl
    mPageControl = [[UIPageControl alloc]init];
    [self addSubview:mPageControl];
    mPageControl.numberOfPages = kFaceNum/(3*7) +1;
    mPageControl.userInteractionEnabled = NO;
    mPageControl.backgroundColor = [UIColor clearColor];
    mPageControl.currentPage  = 0;
    mPageControl.currentPageIndicatorTintColor = kSelectedColorPageControl;
    mPageControl.pageIndicatorTintColor  = kUnSelectedColorPageControl;
    
    [mPageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mCollectionView.mas_bottom).offset(-4);
        make.centerX.equalTo(self);
    }];
}
#pragma sendBtn点击事件
-(void)sendExpression{
    if (self.delegate && [self.delegate respondsToSelector:@selector(stickerKeyboardDidClickSendButton:)]) {
        [self.delegate stickerKeyboardDidClickSendButton:self];
    }

}
#pragma 读取Expression文件
-(NSArray *)getExpressionWithPlist
{
    NSBundle *bundle = [NSBundle mainBundle];
    
    NSString  *path = [bundle pathForResource:@"Expression" ofType:@"plist"];
    
    NSArray   *RootExpression = [[NSArray alloc]initWithContentsOfFile:path];
    
    NSArray   *Expression;
    for (NSDictionary *dic in RootExpression) {
        if ([dic[@"cover_pic"] isEqualToString:@"qq"]) {
            Expression =dic[@"emoticons"];
        }
    }
    return Expression;
}

#pragma mark - UICollectionView Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.DataSource.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WebChatMessageEmojiCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kExpressionID forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
- (void)configureCell:(WebChatMessageEmojiCollectionCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.model = _DataSource[indexPath.row];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选中了:%ld",(long)indexPath.row);
    [[UIDevice currentDevice] playInputClick];
    if (indexPath.row  == 20 || indexPath.row == 41 || indexPath.row == 62 || indexPath.row == 83) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(stickerKeyboardDidClickDeleteButton:)]) {
            [self.delegate stickerKeyboardDidClickDeleteButton:self];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(stickerKeyboard:didClickEmoji:)]) {
            [self.delegate stickerKeyboard:self didClickEmoji:[NSString stringWithFormat:@"%ld",indexPath.row]];
        }
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    mPageControl.currentPage = (scrollView.contentOffset.x)/scrollView.bounds.size.width;
}
-(BOOL)enableInputClicksWhenVisible{
    return YES;
}
@end

