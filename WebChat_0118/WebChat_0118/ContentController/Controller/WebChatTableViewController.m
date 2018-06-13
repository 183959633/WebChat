//
//  WebChatTableViewController.m
//  WebChat
//
//  Created by Jack on 2017/12/13.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "WebChatTableViewController.h"
#import <Masonry.h>
#import "CentreView.h"
#import "JackHttp.h"
#import "WebChatModel.h"
#import <PPNetworkHelper.h>
#import "WebChatTextTableViewCell.h"
#import "WebChatImageTableViewCell.h"
#import "WebChatVoiceTableViewCell.h"
#import "WebChatFlickerTableViewCell.h"
#import "WebChatBaseTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import <Speech/Speech.h>

#define kBkColorTableView           ([UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1])
#define mInputBtnbackgroundColor    ([UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1])

//导航栏默认高度
#define kNavheight               (Screen_Height == 812.0f) ? 88:64
//状态栏默认高度
#define kTabheight               (44)
//录音提示框默认大小
#define kCentreViewSize          (160)
//无缝边距
#define kZeroMargin              (0)
@interface WebChatTableViewController ()<UITableViewDelegate,
                                        UITableViewDataSource,
                                        UIScrollViewDelegate,
                                        SFSpeechRecognitionTaskDelegate,
                                        WebChatMessageInputBarDelegate>
@end
@implementation WebChatTableViewController
{
    BOOL                 isOK;             //是否点击了titleLabel
    
    NSInteger            t_Length;          //录音时长
    NSTimer              *length_timer;     //length_timer定时器
    
    NSString             *filePath;         //录音文件路径
    AVAudioPlayer        *player;           //播放器
    AVAudioRecorder      *recorder;         //录音器
    
    //转人工
    NSString             *t_roomid;        //建立roomid,链接客服
    NSTimer              *roomid_timer;    //roomid定时器
    NSString             *sessionId;       //生成16位随机数
    
    //语音识别
    SFSpeechRecognizer       *speechRecognizer;    //语音请求对象
    SFSpeechRecognitionTask  *recognitionTask;     //当前语音识别进程
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BOOL isNetwork =[PPNetworkHelper isNetwork];
    NSLog(@"是否有网络==%d",isNetwork);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化 UI
    [self setUI];
    
    //初始化语音识别相关
    [self Recognizerinit];
    
    //图片通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabViewNotification:)name:kNotificationImage object:nil];
    //选中动态添加的kVagueListButton通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabViewNotification:)name:kNotificationtitleLabel object:nil];
    
}
#pragma WebChatMessageInputBar-----delagate
-(void)stickerInputBarDidClickSendButton:(WebChatMessageInputBar *)inputView{
    [self sendMessageWithinputText:self.inputBar.mInputTextView.text];
}
//通知传值
-(void)tabViewNotification:(NSNotification *)data{
    
    if (data.userInfo[@"aImage"]) {
        WebChatModel *t_model= data.userInfo[@"aImage"];
        [self.dataArray addObject:t_model];
        [_tableView reloadData];
        [self scrollTableToFoot:YES];
    }
    if (data.userInfo[@"titleLabel"]) {
        isOK  = YES;
        NSString *t_titleLabel = data.userInfo[@"titleLabel"];
        [self sendMessageWithinputText:t_titleLabel];
    }
}
-(void)setUI{
    self.view.backgroundColor =[UIColor whiteColor];
    isOK  = NO;
    
    //导航栏----
    UIView *v  =[[UIView alloc]init];
    [self.view addSubview:v];
    v.backgroundColor =[UIColor whiteColor];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kZeroMargin);
        make.width.mas_equalTo(self.view.mas_width);
        if (IS_IPHONE_X) {
            make.height.mas_equalTo(44);
        }else{
            make.height.mas_equalTo(0);
        }

    }];
    
    UILabel *l =[[UILabel alloc]init];
    [self.view addSubview:l];
    l.text =@"为保证安全,请勿轻易泄露个人信息";
    l.font =[UIFont systemFontOfSize:16.0f];
    l.textAlignment =NSTextAlignmentCenter;
    l.backgroundColor =[UIColor whiteColor];
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v.mas_bottom).offset(kZeroMargin);
        make.width.mas_equalTo(self.view.mas_width);
        if (IS_IPHONE_X) {
            make.height.mas_equalTo(44);
        }else{
            make.height.mas_equalTo(64);
        }
    }];
    
    [self.view addSubview:self.inputBar];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.centreView];
    
    //tabView
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kNavheight);
        make.left.equalTo(self.view.mas_left).offset(kZeroMargin);
        make.width.mas_equalTo(self.view.mas_width);
        make.bottom.equalTo(self.inputBar.mas_top).offset(kZeroMargin);
    }];
    
    //centreView
    _centreView.hidden =YES;
    [_centreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kCentreViewSize, kCentreViewSize));
        make.centerX.equalTo(_tableView.mas_centerX);
        make.centerY.equalTo(_tableView.mas_centerY);
    }];
    
    //inputBar
    [_inputBar mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_X) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-kTabHeight_IPHONE_X);
        }else{
           make.bottom.equalTo(self.view.mas_bottom).offset(kZeroMargin);
        }
        
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(kTabheight);
    }];
}
#pragma 随机生成"16"位字符串
-(NSString *)aStringWith16Number
{
    char data[16];
    NSString *t_String;
    for (int x=0;x<16;data[x++] = (char)('A' + (arc4random_uniform(26))));
    t_String = [[NSString alloc] initWithBytes:data length:16 encoding:NSUTF8StringEncoding];
    
    return t_String;
}
#pragma base64编码
- (NSString *)encode:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    NSString *baseString = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    
    return baseString;
}
#pragma base64解码
- (NSString *)dencode:(NSString *)base64String
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    return string;
}
#pragma NSString--->>>NSAttributedString
-(NSMutableAttributedString *)stringToAttributeString:(NSString *)string
{
    //先把普通的字符串string转化成Attributed类型的字符串
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:string];
    
    //正则表达式 ,例如 "/::)" 这种形式的通配符
    NSString *regular = @"/::\\)|/::~|/::B|/::\\||/:8-\\)|/::<|/::\\$|/::X|/::Z|/::’\\(|/::-\\||/::@|/::P|/::D|/::O|/::\\(|/::\\+|/:–b|/:--b|/::Q|/::T|/:,@P|/:,@-D|/::d|/:,@o|/::g|/:\\|-\\)|/::!|/::L|/::>|/::,@|/:,@f|/::-S|/:\\?|/:,@x|/:,@@|/::8|/:,@!|/:!!!|/:xx|/:bye|/:wipe|/:dig|/:handclap|/:&-\\(|/:B-\\)|/:<@|/:@>|/::-O|/:>-\\||/:P-\\(|/::’\\||/:X-\\)|/::\\*|/:@x|/:8\\*|/:pd|/:<W>|/:beer|/:basketb|/:oo|/:coffee|/:eat|/:pig|/:rose|/:fade|/:showlove|/:heart|/:break|/:cake|/:li";
    
    NSError * error;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:regular options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (!re)
    {
        //正则表达式错误
        NSLog(@"%@",[error localizedDescription]);
    }
    //遍历字符串,获得所有的匹配字符串
    NSArray * array = [re matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    //读取 plist 文件数组
    NSArray *Expression  = [self getExpressionWithPlist];
    
    //如果有多个表情图，必须从后往前替换，因为替换后Range就不准确了
    for (int j =(int) array.count - 1; j >= 0; j--) {
        //NSTextCheckingResult里面包含range
        NSTextCheckingResult * result = array[j];
        
        for (int i = 0; i < Expression.count; i++) {
            //从数组中的字典中取元素
            if ([[string substringWithRange:result.range] isEqualToString:Expression[i][@"text"]])
            {
                NSString * imageName = [NSString stringWithString:Expression[i][@"image"]];
                //初始化属性字符串附件对象
                NSTextAttachment * textAttachment = [[NSTextAttachment alloc]init];
                textAttachment.image = [UIImage imageNamed:imageName];
                textAttachment.bounds = CGRectMake(0, 0, 14, 14);
                NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                //把附件设置到属性字符串上
                [attStr replaceCharactersInRange:result.range withAttributedString:imageStr];
                break;
            }
        }
    }
    return attStr;
}
#pragma NSAttributedString--->>>NSString
-(NSString *)afferentString:(NSAttributedString *)attributedText
{
    NSAttributedString * att = attributedText;
    NSMutableAttributedString * resutlAtt = [[NSMutableAttributedString alloc]initWithAttributedString:attributedText];
    
    //枚举出所有的附件字符串
    [att enumerateAttributesInRange:NSMakeRange(0, att.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        //key-NSAttachment
        //NSTextAttachment value类型
        NSTextAttachment * textAtt = attrs[@"NSAttachment"];//从字典中取得那一个图片
        if (textAtt)
        {
            UIImage * image = textAtt.image;
            NSString * text = [self stringFromImage:image];
            [resutlAtt replaceCharactersInRange:range withString:text];
        }
    }];
    return resutlAtt.string;
}
-(NSString *)stringFromImage:(UIImage *)image
{
    NSArray *Expression  = [self getExpressionWithPlist];
    NSString * imageName;
    NSData * imageD = UIImagePNGRepresentation(image);
    
    for (int i=0; i<Expression.count; i++)
    {
        UIImage *image=[UIImage imageNamed:Expression[i][@"image"]];
        NSData *data=UIImagePNGRepresentation(image);
        if ([imageD isEqualToData:data])
        {
            imageName=Expression[i][@"text"];
        }
    }
    return imageName;
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
#pragma 发送消息(机器人🤖 And 人工交互👩)
-(void)sendMessageWithinputText:(NSString*)text{
    
    //发送前做处理将NSAttributedString  --->>> NSString
    NSAttributedString *t_AttributedString = _inputBar.mInputTextView.attributedText;
    NSString *t_String = [self afferentString:t_AttributedString];
    
    
    //设置请求/响应格式
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    
    //转人工客服
    if (t_roomid) {
        NSLog(@"t_roomid已就绪");
        NSMutableDictionary *parameterDic =[[NSMutableDictionary alloc]init];
        NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
        long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
        NSString *curTime = [NSString stringWithFormat:@"%llu",theTime];
        
        sessionId =[self aStringWith16Number];
        
        [parameterDic setValue:curTime forKey:@"tt"];
        [parameterDic setValue:@"m" forKey:@"t"];
        [parameterDic setValue:@"bank" forKey:@"target"];
        [parameterDic setValue:t_String forKey:@"message"];
        [parameterDic setValue:t_roomid forKey:@"sid"];
        [parameterDic setValue:sessionId forKey:@"sessionId"];
        
        WebChatModel *model        = [[WebChatModel alloc]init];
        model.isSender             = YES;
        model.chatCellType         = WebChatCellType_Text;
        model.AttributedanswerMsg  = t_AttributedString;
        [self.dataArray addObject:model];
        
        [_tableView reloadData];
        [self scrollTableToFoot:YES];
        
        [PPNetworkHelper POST:[NSString stringWithFormat:@"%@%@",IP_URL,MsgTxt_URL] parameters:parameterDic success:^(id responseObject) {
            NSLog(@"客户发送消息responseObject===%@",responseObject);
            
        } failure:^(NSError *error) {
            NSLog(@"客户发送消息error===%@",error);
        }];
    }else{
        //智能机器人🤖
        NSLog(@"t_roomid不存在");
        if ([t_String containsString:@"转"] || [t_String containsString:@"人工"]) {
            
            WebChatModel *isModel        = [[WebChatModel alloc]init];
            isModel.isSender             = YES;
            isModel.chatCellType         = WebChatCellType_Text;
            isModel.AttributedanswerMsg  = t_AttributedString;
            [self.dataArray addObject:isModel];
            
            [_tableView reloadData];
            [self scrollTableToFoot:YES];
            
            NSMutableDictionary *parameterDic =[[NSMutableDictionary alloc]init];
            NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
            long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
            NSString *curTime = [NSString stringWithFormat:@"%llu",theTime];
            
            sessionId =[self aStringWith16Number];
            
            [parameterDic setValue:curTime forKey:@"tt"];
            [parameterDic setValue:@"1" forKey:@"businessNo"];
            [parameterDic setValue:@"1" forKey:@"consumerBussiness"];
            [parameterDic setValue:@"40" forKey:@"channelType"];
            [parameterDic setValue:@"13204117850" forKey:@"custMobile"];
            [parameterDic setValue:sessionId forKey:@"sessionId"];
            
            ///小查本地custName
            [parameterDic setValue:@"custName" forKey:@"custName"];
            
            [PPNetworkHelper POST:[NSString stringWithFormat:@"%@%@",IP_URL,Agent_URL] parameters:parameterDic success:^(id responseObject) {
                
                NSLog(@"转人工responseObject===%@",responseObject);
                if (responseObject[@"roomid"]) {
                    t_roomid  = responseObject[@"roomid"];
                    
                    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
                    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
                    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
                    NSString *curTime = [NSString stringWithFormat:@"%llu",theTime];
                    [dict setValue:curTime forKey:@"tt"];
                    [dict setValue:@"n" forKey:@"t"];
                    [dict setValue:@"bank" forKey:@"target"];
                    [dict setValue:t_roomid forKey:@"sid"];
                    [dict setValue:sessionId forKey:@"sessionId"];
                    
                    [PPNetworkHelper POST:[NSString stringWithFormat:@"%@%@",IP_URL,MsgOpen_URL] parameters:dict success:^(id responseObject) {
                        NSLog(@"开启轮询responseObject===%@",responseObject);
                        [self addTimerAboutPoll];
                    } failure:^(NSError *error) {
                        NSLog(@"开启轮询error===%@",error);
                    }];
                }else{
                    NSLog(@"拉取轮询消息异常");
                }
            } failure:^(NSError *error) {
                NSLog(@"转人工error===%@",error);
            }];
            
        }else{
            NSAttributedString *t_AttributedanswerMsg ;
            
            if (isOK) {
                t_AttributedanswerMsg = [self stringToAttributeString:text];
                
            }else{
                t_AttributedanswerMsg = _inputBar.mInputTextView.attributedText;
            }
            
            WebChatModel *isModel       = [[WebChatModel alloc]init];
            isModel.isSender            = YES;
            isModel.chatCellType        = WebChatCellType_Text;
            isModel.AttributedanswerMsg = t_AttributedanswerMsg;
            [self.dataArray addObject:isModel];
            
            NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
            long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
            NSString *curTime = [NSString stringWithFormat:@"%llu",theTime];
            NSMutableDictionary *parameters =[[NSMutableDictionary alloc]init];
            
            [parameters setValue:[NSNumber numberWithInteger:5] forKey:@"protocolId"];
            [parameters setValue:@"ceshi" forKey:@"robotHashCode"];
            [parameters setValue:@"1" forKey:@"platformConnType"];
            [parameters setValue:@"jack007" forKey:@"userId"];
            [parameters setValue:@"jack008" forKey:@"talkerId"];
            [parameters setValue:@"3.3.0" forKey:@"receiverId"];
            [parameters setValue:@"ac5d5452" forKey:@"appKey"];
            [parameters setValue:curTime forKey:@"sendTime"];
            [parameters setValue:@"text" forKey:@"type"];
            [parameters setValue:[NSNumber numberWithInteger:0] forKey:@"isNeedClearHistory"];
            [parameters setValue:text forKey:@"query"];
            [parameters setValue:[NSNumber numberWithInteger:0] forKey:@"isQuestionQuery"];
            
            [PPNetworkHelper POST:CSRBroker_URL parameters:parameters success:^(id responseObject) {
                
                WebChatModel *model =[[WebChatModel alloc]init];
                NSString           *t_String;
                NSAttributedString *t_AttributedString;
                if([responseObject[@"answerTypeId"]  isEqual:@5]){
                    //responseObject[@"vagueNode"][@"promptVagueMsg"](点击就可以直接搜索)
                    t_String = responseObject[@"vagueNode"][@"endVagueMsg"];
                    t_AttributedString = [self stringToAttributeString:t_String];
                    
                    model.isSender     = NO;
                    model.chatCellType = WebChatCellType_Text;
                    model.AttributedanswerMsg = t_AttributedString;
                    model.vagueList    = responseObject[@"vagueNode"][@"vagueList"];
                }else{
                    t_String = responseObject[@"singleNode"][@"answerMsg"];
                    t_AttributedString = [self stringToAttributeString:t_String];
                    
                    model.isSender     = NO;
                    model.chatCellType = WebChatCellType_Text;
                    model.AttributedanswerMsg = t_AttributedString;
                }
                [self.dataArray addObject:model];
                
                [_tableView reloadData];
                [self scrollTableToFoot:YES];
                isOK =NO;
            } failure:^(NSError *error) {
                NSLog(@"请求失败===%@",error);
            }];
        }
    }
}
#pragma 添加roomid_timer定时器
- (void)addTimerAboutPoll
{
    roomid_timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(aRoomID) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:roomid_timer forMode:NSRunLoopCommonModes];
}
#pragma 移除roomid_timer定时器
- (void)removeTimerAboutPoll
{
    [roomid_timer invalidate];
    roomid_timer = nil;
}
-(void)aRoomID{
    
    NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
    NSString *curTime = [NSString stringWithFormat:@"%llu",theTime];
    
    [dic setValue:curTime forKey:@"tt"];
    [dic setValue:@"g" forKey:@"t"];
    [dic setValue:@"bank" forKey:@"target"];
    [dic setValue:t_roomid forKey:@"sid"];
    [dic setValue:sessionId forKey:@"sessionId"];
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper setResponseSerializer:PPResponseSerializerJSON];
    
    [PPNetworkHelper POST:[NSString stringWithFormat:@"%@%@",IP_URL,MsgPull_URL] parameters:dic success:^(id responseObject) {
        NSLog(@"轮询消息===%@",responseObject[@"result"]);
        if (![responseObject[@"result"]  isEqual:@"NONE"]) {
            NSArray  *array  = responseObject[@"result"];
            NSLog(@"返回的信息array===%@",array);
            //更新轮询消息
            [self updatePollingMessage:array];
        }
        //todo
        //移除定时器
        //[self removeTimerAboutPoll];
        
    } failure:^(NSError *error) {
        NSLog(@"轮询消息responseObject===%@",error);
    }];
}
//#pragma 更新轮询消息
-(void)updatePollingMessage:(NSArray*)data{
    
    for (id result in data) {
        WebChatModel *model   = [[WebChatModel alloc]init];
        NSString              *t_String;
        NSAttributedString    *t_AttributedString;
        if ([result[@"TYPE"]  isEqualToString:@"1010"] ) {
            t_String           = result[@"speakContent"];
            t_AttributedString = [self stringToAttributeString:t_String];
            model.isSender            = NO;
            model.chatCellType        = WebChatCellType_Text;
            model.AttributedanswerMsg = t_AttributedString;
            [self.dataArray addObject:model];
        }else if([result[@"TYPE"]  isEqualToString:@"5010"] ){
            
            if ([result[@"role"]  isEqualToString:@"2"]) {
                t_String                   = result[@"CONTENT"];
                NSString *base64String     = [self dencode:t_String];
                t_AttributedString         = [self stringToAttributeString:base64String];
                model.isSender             = NO;
                model.chatCellType         = WebChatCellType_Text;
                model.AttributedanswerMsg  = t_AttributedString;
                [self.dataArray addObject:model];
            }
        }
    }
    [_tableView reloadData];
    [self scrollTableToFoot:NO];
}
#pragma 懒加载初始化 --->>>
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray =[[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(CentreView *)centreView{
    if (!_centreView) {
        _centreView =[[CentreView alloc]init];
    }
    return _centreView;
}
-(WebChatMessageInputBar *)inputBar
{
    if (!_inputBar) {
        _inputBar = [[WebChatMessageInputBar alloc]init];
        _inputBar.delegate =self;
        //给_mInputBtn添加长按手势
        UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        //属性设置
        //最小长按时间
        longPress.minimumPressDuration = 2;
        [_inputBar.mInputButton addGestureRecognizer:longPress];
    }
    return _inputBar;
}
-(UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView =[[UITableView alloc]init];
        _tableView.delegate             =   self;
        _tableView.dataSource           =   self;
        _tableView.separatorStyle       =   UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode  =   UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.rowHeight            =   UITableViewAutomaticDimension;
        _tableView.backgroundColor      =   kBkColorTableView;
        UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
        tableViewGesture.numberOfTapsRequired = 1;
        tableViewGesture.cancelsTouchesInView = NO;
        [_tableView addGestureRecognizer:tableViewGesture];
        
        [_tableView registerClass:[WebChatTextTableViewCell class] forCellReuseIdentifier:@"1-WebChatCellType_Text"];
        [_tableView registerClass:[WebChatTextTableViewCell class] forCellReuseIdentifier:@"0-WebChatCellType_Text"];
        
        [_tableView registerClass:[WebChatImageTableViewCell class] forCellReuseIdentifier:@"1-WebChatCellType_Image"];
        [_tableView registerClass:[WebChatVoiceTableViewCell class] forCellReuseIdentifier:@"1-WebChatCellType_Audio"];
        
        [_tableView registerClass:[WebChatFlickerTableViewCell class] forCellReuseIdentifier:@"1-WebChatCellType_Flicker"];
    }
    return _tableView;
}
#pragma 开启本地语音识别
- (void)startDistinguish
{
    //创建识别请求
    SFSpeechURLRecognitionRequest *request = [[SFSpeechURLRecognitionRequest alloc] initWithURL:[NSURL fileURLWithPath:filePath]];
    //开启识别任务
    recognitionTask = [speechRecognizer recognitionTaskWithRequest:request delegate:self];
}
#pragma 开始录音
-(void)startRecord{
    t_Length = 0;
    [self addTimerAboutAudio];
    AVAudioSession *session =[AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if (session == nil) {
        NSLog(@"Error creating session: %@",[sessionError description]);
    }else{
        [session setActive:YES error:nil];
    }
    //1.获取沙盒地址
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSDateFormatter * formatter =[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
    NSDate *currentDate = [NSDate date];
    NSString *currentDateString = [formatter stringFromDate:currentDate];
    //命名录音文件
    filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.aac",currentDateString]];
    //2.获取文件路径
    NSURL *recordFileUrl = [NSURL fileURLWithPath:filePath];
    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 22050],AVSampleRateKey,
                                   // 音频格式  AudioFormatID
                                   [NSNumber numberWithInt: kAudioFormatMPEG4AAC],AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   // 音频通道数 1 或 2
                                   [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                                   //录音质量 AVAudioQuality
                                   [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                   nil];
    
    /*初始化录音器 并且读取文件地址 */
    recorder = [[AVAudioRecorder alloc] initWithURL:recordFileUrl settings:recordSetting error:nil];
    if (recorder) {
        /*级计量或放假默认是关闭的*/
        recorder.meteringEnabled = YES;
        /*创建文件,准备记录。会自动记录*/
        [recorder prepareToRecord];
        /*启动或恢复记录文件*/
        [recorder record];
    }else{
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
    }
}
#pragma 停止录音
-(void)stopRecordWithCGPoint:(CGPoint)point{
    [self removeTimerAboutAudio];
    //删除掉录音cell--->>>
    [_dataArray removeLastObject];
    if ([recorder isRecording]) {
        [recorder stop];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    /*判断该路径是否存在*/
    if ([fileManager fileExistsAtPath:filePath]){
        CGFloat kfileSize= [fileManager attributesOfItemAtPath:filePath error:nil].fileSize/1024.0;
        NSLog(@"录音文件大小===%f",kfileSize);
        if (point.y > -35) {
            WebChatModel *model =[[WebChatModel alloc]init];
            model.isSender     = YES;
            model.aAudiotime   = [NSString stringWithFormat:@"%ld",t_Length];
            model.aAudioPath   = filePath;
            model.chatCellType = WebChatCellType_Audio;
            
            [self.dataArray addObject:model];
            
            //调用本地语音识别
            [self startDistinguish];
        }else{
            BOOL res=[fileManager removeItemAtPath:filePath error:nil];
            if (res) {
                NSLog(@"已取消发送,文件删除成功");
            }else{
                NSLog(@"文件是否存在===%@",[fileManager isExecutableFileAtPath:filePath]?@"YES":@"NO");
            }
        }
    }
    //刷新 tabView ,展示 UI, 并滑动至底部
    [_tableView reloadData];
    [self scrollTableToFoot:YES];
}
#pragma 添加length_timer定时器
- (void)addTimerAboutAudio
{
    length_timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(aLength) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:length_timer forMode:NSRunLoopCommonModes];
}
#pragma 移除length_timer定时器
- (void)removeTimerAboutAudio
{
    [length_timer invalidate];
    length_timer = nil;
}
-(void)aLength{
    t_Length ++;
}
#pragma 添加手势,收起键盘
- (void)commentTableViewTouchInSide{
    [_inputBar.mInputTextView resignFirstResponder];
}
#pragma mark langPress 长按手势事件
-(void)longPress:(UILongPressGestureRecognizer *)gesture{
    
    CGPoint  point = [gesture locationInView:_inputBar.mInputButton];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        //显示_centreView
        _centreView.hidden =NO;
        //开始动画
        [_centreView.mShowImageView startAnimating];
        [_inputBar.mInputButton setTitle:@"松开 结束"forState:UIControlStateNormal];
        _inputBar.mInputButton.backgroundColor = mInputBtnbackgroundColor;
        
        //调用开始录音
        [self startRecord];
        
        WebChatModel *model  = [[WebChatModel alloc]init];
        model.isSender       = YES;
        model.chatCellType   = WebChatCellType_Flicker;
        [self.dataArray addObject:model];
        
        [_tableView reloadData];
        [self scrollTableToFoot:YES];
        
    }else if (gesture.state == UIGestureRecognizerStateChanged){
        if (point.y >-35) {
            //开始动画
            [_centreView.mShowImageView startAnimating];
            _centreView.mShowLabel.text=@"手指上滑,取消发送";
        }else{
            _centreView.mShowLabel.text=@"松开手指,取消发送";
            //停止动画
            [_centreView.mShowImageView stopAnimating];
        }
    }else if(gesture.state == UIGestureRecognizerStateEnded){
        
        _centreView.hidden = YES;
        [_inputBar.mInputButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        _inputBar.mInputButton.backgroundColor = [UIColor whiteColor];
        _inputBar.mInputButton.hidden   = YES;
        _inputBar.mInputTextView.hidden = NO;
        
        //停止录音逻辑处理
        [self stopRecordWithCGPoint:point];
    }
    
}
#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WebChatModel *model = _dataArray[indexPath.row];
    
    NSString *t_isSender;
    if (model.isSender) {
        t_isSender = @"1";
    }else{
        t_isSender = @"0";
        
    }
    
    NSString *t_chatCellType = [model getchatCellType:model.chatCellType];
    
    if (model.chatCellType == WebChatCellType_Text) {
        WebChatTextTableViewCell *cellText ;
        cellText =[[WebChatTextTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%@-WebChatCellType_Text",t_isSender]];
        cellText.model =model;
        return cellText;
    }
    WebChatBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIDWithSenderAndType(t_isSender,t_chatCellType) forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}
- (void)configureCell:(WebChatBaseTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [cell->mBubbleImageView startAnimating];
    WebChatModel *model = _dataArray[indexPath.row];
    cell.model = model;
}
#pragma 滚动至 tabView 最底部
- (void)scrollTableToFoot:(BOOL)animated
{
    //有多少组
    NSInteger s = [_tableView numberOfSections];
    //无数据时不执行 不然会crash
    if (s<1) return;
    //最后一组有多少行
    NSInteger r = [_tableView numberOfRowsInSection:s-1];
    if (r<1) return;
    //取最后一行数据
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    //滚动到最后一行
    [_tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}
#pragma 初始化语音识别相关
-(void)Recognizerinit{
    //细节处理 todo
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        switch (status) {
            case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                NSLog(@"结果未知,用户尚未进行选择");
                break;
            case SFSpeechRecognizerAuthorizationStatusDenied:
                NSLog(@"用户拒绝授权语音识别");
                break;
            case SFSpeechRecognizerAuthorizationStatusRestricted:
                NSLog(@"设备不支持语音识别功能");
                break;
            case SFSpeechRecognizerAuthorizationStatusAuthorized:
                NSLog(@"用户已经授权语音识别");
                break;
            default:
                break;
        }
    }];
    //创建SFSpeechRecognizer识别实例
    //中文识别
    speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    //根据手机设置的语言识别
    [SFSpeechRecognizer supportedLocales];
}
#pragma mark- SFSpeechRecognitionTaskDelegate
- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishRecognition:(SFSpeechRecognitionResult *)recognitionResult {
    _inputBar.mInputTextView.text = recognitionResult.bestTranscription.formattedString;
}
- (void)dealloc{
    //销毁语音识别进程
    [recognitionTask cancel];
    recognitionTask = nil;
    //销毁通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
