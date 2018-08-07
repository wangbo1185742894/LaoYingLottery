

/********************* 有任何问题欢迎反馈给我 liuweiself@126.com ****************************************/
/***************  https://github.com/waynezxcv/Gallop 持续更新 ***************************/
/******************** 正在不断完善中，谢谢~  Enjoy ******************************************************/


#import "StatusModel.h"

@implementation StatusModel {
    NSArray* headerImgs;
    NSArray* contentS;
    NSArray* names;
    NSArray* imgTotal;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        imgTotal = @[@"/2018/01/14/QYJMLSYCAWTABBBYDVGE.jpg",@"/2018/01/14/UBQCBVAHJRROJJGOHRGE.jpg",@"/2018/01/14/ZSDMOBXWQCWNRXDJPGZB.jpg",@"/2018/01/12/WLCYVGISRYAHEURDUABQ.jpg",@"/2018/01/18/ICAKOWNLVBAKQKDJBKHO.jpg",@"/2018/01/16/YZTZVOFWBVBTKMXSCUOR.jpg",@"/2018/01/16/YSLDUJODKQRMUGHSNCGZ.jpg",@"/2018/01/16/GIWKLHDXFEKPQZJWFOEN.jpg",@"/2018/01/17/JTZJYSIILKXXMGHRICNA.png",@"/2018/01/17/ERMTUSXERYMUPXHYSJSC.jpg",@"/2018/01/16/JQOXVRINFSRXJFKILBXX.jpg",@"/2018/01/17/ELHUEESGRXZFAFETCEEB.jpg",@"/2018/01/17/NRBKOQZNZXCTBJCZUWUN.jpg",@"/2018/01/16/UKSYEHHVVNZZQYJIKAUV.jpg",@"/2018/01/15/BNIHRNKHPHRHZUPCGWCZ.jpg",@"/2018/01/16/HXVFHQGYGXBWSHRIDKWL.jpg",@"/2018/01/15/URAMFUTPHCLEWZRHOFGB.jpg",@"/2018/01/16/UEGORCTGOAEMTFMKBQKG.jpg",@"/2018/01/15/LJSFBNTXKXGLKFRSBCXC.jpg",@"/2018/01/16/VBRJZMQBLWXACCFNQNYY.jpg",@"/2018/01/15/BJNPCZOSYWXBXALFPVPG.gif",@"/2018/01/15/FUICMZMFJFSIMTOWMRNY.jpg",@"/2018/01/08/DUIXRYGERPSYGFIBDLRJ.jpg",@"/2018/01/11/MECFDJGFRFLQPNENSILE.png",@"/2018/01/14/IAZDORBNFEWBERSJSXGU.jpg",@"/2018/01/12/BKIAANYJAXFPVMXRMCTY.jpg",@"/2018/01/12/BJHFEUERJTFRRMNVPHFY.jpg",@"/2018/01/11/IANHEPHDSLHEBRUNKWPL.jpg"];
        
        names = @[@"任你前场吊炸天",@"Ronaldoxx",@"爲你倾浕亻世繁华",@"MESSIZHSSI",@"Ronaldoxx",@"小姐姐爱梅西",@"沧州联队足球俱乐部",@"MR1239",@"破车保级队",@"2002shijiebwi",@"乌撒仙人",@"Daur",@"松浦果南",@"下一个克洛泽",@"我很好心脏还能跳还能笑",@"王小雨傻乎乎",@"切糕啊",@"忍着657",@"绝恋蘭天使",@"我想不出来i",@"我1214",@"2279890798",@"破车保级队",@"朱一凡",@"罗CR7C",@"佐拉向前冲",@"鈿洓",@"DYC100",@"0ldboy",@"超级黑又硬",@"李易卓",@"李易卓",@"th20025",@"不健身成功不换头像",@"迁徙的鸟迷",@"凸起格策",@"卡卡小先生",@"霸偃丶",@"看光光",@"特立的",@"dreamerwu",@"托马斯和他的小火车轰隆轰隆",@"朱一凡",@"footballweekly",@"拜仁神锋2号大屌吉鲁",@"影虎",@"一头疯狂的牛",@"老毅",@"wangbo1234",@"嘿嗯嘿",@"Byeet",@"大木止",@"孤独的小飞侠",@"REALMADRID朗拿度",@"舞动八度空间",@"舞动八度空间",@"山东鲁能泰山最棒",@"旧城那初升的太阳",@"wanghaokobe24",@"360度都死角",@"江苏国信舜天萨米尔",@"年度金屁股奖",@"破车保级队",@"想西尔",@"梅西最牛b",@"123利物浦",@"msx1992",@"迷你豪",@"走的好远你的背影",@"运笔无痕",@"P-D",@"QTcr7",@"听你也说过",@"風流劍_88660",@"永远的阿莱桑德罗德尔皮耶罗",@"Shuak",@"疯狂足球娱乐部小阙",@"xiaomaics",@"恒大天河FC",@"Adam__",@"无法沟通",@"大漠315",@"国足必胜",@"25离",@"德玛尔-德罗赞",@"JaviMartinaz",@"燃烧和沸腾",@"烟花易逝",@"mason恒0萨",@"小罗21",@"破车保级队",@"颗粒丝萝辣耳朵",@"侠义非凡",@"不能贪",@"梅老板就是帅",@"dreamerwu",@"阿炜",@"dadedadedade",@"布布Bridge",@"恒大的铁粉",@"地藏忙",@"巅峰梅西39",@"msx1992",@"大卫比利亚爱力宏",@"灯泡夺冠",@"男儿有恋不轻谈",@"MESSIZHSSI",@"诺坎普之王哈维",@"荒野大嫖客YTX",@"J罗花",@"牛掰的二传手高拉特",@"椰雨",@"C罗哩啰嗦",@"帝亚戈梅西",@"酒精灯规划",@"Delete少年",@"jinminhe",@"sjsn",@"Hero59",@"小星星啦",@"12345mfh",@"外教",@"拜仁名帅海因克斯",@"枪手e最棒",@"一场3球的罗伊斯",@"力斌爸",@"圣洁",@"巴伐利亚的巨人",@"Kawsar630",@"忠鑫",@"刘文健",@"梅西MESI",@"KUTZAD",@"SOS0369",@"Love纳",@"鱡響",@"跟從你的心",@"不忘初心9w",@"小鸡的星空",@"朱一凡",@"Cristiano罗达",@"KUTZAD",@"KUTZAD",@"KUTZAD",@"KUTZAD",@"KUTZAD",@"KUTZAD",@"MB45GYM",@"thl2004",@"KUTZAD",@"KUTZAD",@"KUTZAD",@"KUTZAD",@"KUTZAD",@"广义相对论",@"倪捞子",@"LM10Legend--",@"朱一凡",@"永远的武球王",@"FuckFootball主席",@"枫丹白露123",@"斯坦福桥上的大灰机",@"小爷很拽D",@"虚掩的卡门",@"壮哉我大尤文",@"国米复兴",@"拥抱jb",@"我们是不可战胜的",@"破车保级队",@"芊芊914",@"Y2016",@"一位不愿意透露姓名的路边社记者",@"破车保级队",@"CR錾钰",@"老细加餸",@"guoan-0909",@"莱万穆勒斯基",@"露逸文",@"纯甄真真真",@"内少克圣",@"上帝财神真主貔貅毛爷爷齐赐福",@"yxml",@"小星星啦",@"爱足球8307",@"我是洛杉矶",@"Griezma",@"南部之星FCBAYERN1",@"关山千树",@"胖子伊瓜因",@"沃尔科润",@"曼彻斯特有价必抬",@"趔趄",@"一个低调的拜仁名宿",@"ILIKEYOURTit",@"皇马7号C罗",@"小星星啦",@"朱一凡",@"小星星啦",@"羊肉串大师狐媚",@"想长翅膀的羊",@"乐以李YiFan",@"Aubameyangss",@"广州恒大GZE-1",@"今朝有酒今朝醉丶",@"cx0706",@"画凉了谁_",@"王疤诞",@"小丑八怪",@"君傾北妖",@"学习委员贾秀全",@"我要你来不顾一切",@"拜仁牌王穆勒",@"jinminhe",@"我是波子",@"Noxus白刀",@"qhdxyjw"];
        contentS = @[@"皇家巴萨战舰，世界最强俱乐部！",@"素质的鲜明对比",@"求图",@"我不管皇马球迷最美最帅",@"耐克af1C罗款大概要多少刀啊？",@"J罗的圆月弯刀啊",@"都不想看我皇的比赛了[伤心]",@"转会市场我皇怎么没冬季？？",@"唉，以后挂皇马队徽能不能审核一下",@"皇马比巴萨到底差在了哪？",@"谢谢老铁送来的福利",@"哪位老铁知道这件衣服能在哪买到？",@"自己做的圣地亚哥•伯纳乌",@"来踢球，就现在",@"废了废了 这个赛季真的废了",@"这个撸过来",@"齐达内求求你了，远方下课钟声🔔已经响起了",@"翻微博 发现何猷君Marioho居然是皇马球迷 瞬间➕好感度(✪▽✪)",@"世态炎凉",@"看了好想笑",@"我不喜欢瓦拉内，防守让人担心",@"求c罗穿西装的图片",@"看了半场隔壁的球，说说感受",@"两位在我破贴下吵了三天了 都是性情中人 就不认输",@"踢假球",@"失恋了",@"有没有这样能做壁纸的图片吗？[羞涩]",@"现在信任齐达内的有多少。欢迎大家讨论。",@"今晚直播又去哪里看？",@"莫名的心酸感",@"各位皇马老铁，谁能教我创个ins账号啊，回复必粉！",@"有谁看过十一冠之心的……😄",@"跪求",@"我心目中最完美的阵型还是433边路主攻战术，C罗不适合当一名纯正的中锋，站桩式的中锋必须得搞一...",@"看这素质梅西的名誉都被他的球迷毁了",@"齐达内对塞巴略斯不信任？Mvp肯定有实力啊 什么太年轻都是假的，内马尔刚去巴萨才多大啊，机会都...",@"国足U23和皇马范一个毛病，得势不得分！",@"是梅罗太强？还是顶级球员太少？",@"哈妹啊😞如果哈妹和邋遢不走就好了",@"建队，舰队！贱队！",@"求c罗托腮庆祝的图片",@"流量都喜欢7。。",@"继小法后又一名自掏腰包去巴萨的！",@"皇马为什么这赛季这么差，原因在这。",@"齐祖？",@"表白C罗",@"论皇马这赛季放出去的球员的表现！",@"伊斯科可以像在西班牙国家队一样好！",@"我怀念的",@"上海看球",@"感觉我皇今晚会输或逼平",@"心中最佳十一人。",@"死忠皇马粉必点",@"bbc以后会变成knh么",@"预测一波",@"哪里有国王杯的直播呀！急",@"你猜哪个教练会走？",@"2个老马4碎片换一个亨利5有换的没",@"想哈妹",@"如果能选一个来加盟皇马希望谁？",@"皇马引援，我兄弟在伯纳乌高层上班",@"有木有感觉欧冠皇马会被大巴黎操翻",@"和莱加内斯踢三场国王杯吗？[学习]",@"上面的字可以改吗？求大神改成八四",@"谁有塞瓦略斯壁纸啊，发几张",@"我团有点危险呐！！",@"老铁们，是有多久没有看到总裁的霸气庆祝动作了[伤心][伤心][伤心]",@"送一个洁白的哈达说一声扎西德勒，我很谢谢你。我作为你的球迷很荣幸为你说一声扎西德勒，也谢谢你没...",@"阿什拉夫究竟行不行啊老铁们",@"聊聊引援",@"？！！",@"？",@"关于引援 我有个大胆的想法",@"!",@"怀念去年的阵容 怀念去年的替补",@"求土豪秒",@"暴风雨前的宁静",@"国王杯抽签结果",@"听说冬窗不买人了？",@"齐祖刚续约到2020年",@"求几张BBC合体壁纸",@"有哪些免费的整套队的手机足球游戏?",@"对皇马本赛季至今为止表现的一些看法",@"求罗帅图做头像！",@"帮忙看看笔记本",@"皇马加油！",@"希望能变得更好",@"最近皇马状态差的原因分析",@"平心而论，现在的内马尔真的比梅西强吗，和C罗比呢？",@"迄今为止  现役球员获得过金球奖的就只有梅西c罗了",@"谁帮我作图",@"亚青U223真不能碰...",@"有人讲下当年c罗的事情好吗？",@"自制了一档足球电台节目，欢迎大家来听",@"各位老哥觉得能不能行",@"這次國奧出局的真正原因",@"自己踢的，能拿几分🤔",@"如果没有分区，亚冠怕是4分之1决赛开始",@"今日推荐",@"前两天撞船不是死了不少伊朗人吗,@",@"黑的不行",@"脚的大小和踢足球有关系吗？",@"一直以来都这样，过了还要努力。U23加油",@"建队最早的球队是不是波鸿啊",@"莫雷诺、赫宁、拉里昂达、考绍伊、黄翔、法加尼",@"女神马凡舒上一站到底啦！",@"❤❤皇家马德里",@"国安",@"国安 真假的 不让注册巴坎布",@"啥意思",@"实况18和FIFA18那个更好玩一些",@"谁知道第四官员的羽绒服哪里有卖的吗？",@"本人十字韧带断裂，刚刚手术完几天，好疼!",@"我竟意外知晓了374的去向",@"巴西队世界杯前景如何？",@"昨天晚上很长时间没联系的前任来找我....聊了两句开始\n喊我臭臭 这到底什么意思 狗屎么[看不下去]",@"谁能帮我想想，关于体育，最好是关于足球的好一点的成语，一定得是成语(⊙o⊙)哦。  急用， 谢谢",@"睡觉了。各位晚安",@"格里兹曼",@"讲真，中超强如恒大和上港能在德乙保级不能？",@"你对U23队员5号怎么看",@"马凡舒啊啊啊啊！",@"一站到底马凡舒在",@"来进来看看这个",@"从行政区名猜中国哪里的人民最会秀？？？",@"拜托中国人后面的比赛都不要去现场看了，以这种方式抗议才会让亚足联知道问题的重要性，是中国人恩点...",@"中国球迷大家好，我知道你们此时的心情，很生气，但是你们骂的时候可以吗裁判，可以骂卡塔尔，但是你...",@"有人跟我一起喜欢曼联的吗",@"要人性 要人权 要规律 不要急功近利",@"听说这个***被揍了[祈福][祈福][祈福]",@"我认为作为中国球迷，我们应该集体向国足申诉。",@"足协该重视了吧 这么多年 这样的事情太多了 你不去找他们麻烦他们就会觉得你好欺负",@"杀了吃肉",@"西亚中东为什么乱",@"什么水平",@"根据踢球者杂志，英超球员如何分档？",@"大家踢球时遇到过的最恶心的人是怎样的？",@"提供一个新闻线索 南都消息  华夏富力已完成交易",@"最爱梅西",@"第十轮落后8分，不会真让我猜中了吧",@"甘肃有没有妹子喜欢足球，找女友，有意的加我,@",@"博尔特:3月去多特蒙德试训",@"救急兄弟",@"谁有手机战术板推荐？中文的，谢谢",@"求问",@"什么游戏",@"自制了一档关于足球的电台节目，一球定音，欢迎来听",@"大家有看《前任3》的吗？我准备去看了",@"预言贴",@"一下换11个人?",@"亚冠",@"为什么这哥子封号了？",@"为什么脸书推特YouTube Instagram在中国都上不了",@"如果巴萨不拦着 皇马会买梅西吗",@"迪玛利亚队友最佳阵❔❔❔[感动]",@"终于找到了鉴定强队的正确方式",@"这啥游戏？？",@"个人最喜欢的一套阵容",@"有没有人来发一下剁吊为证被打脸的截图",@"急求血友病止血药氨甲环酸片相关",@"莫名心酸",@"不喜欢他，但是这样的数据真的让人羡慕，嫉妒！恨啊",@"近二十年五大联赛最失落的俱乐部，大家觉得是谁？",@"《前任3》里足球狗的关注点",@"2018假如能实现3个愿望，你会选哪三个？",@"问一个问题",@"关于张玉宁",@"真的搞不懂，陈独秀到底是谁啊？",@"米纳才是黑人中帅的吧",@"有没有大神帮我这个图改下",@"你最喜欢现在的哪个国内解说？",@"没有直播？",@"二年级的孩子，踢号球，最好？？？",@"看前任3 你们猜我看见谁了",@"问个问题",@"EA18年年度TEAM OF THE YEAR蓝卡",@"一个小小的建议",@"终于等到你",@"有在国外网站买过东西的同学嘛？？？address 是写中文还是英文",@"我想问一下大家 出来特维斯名字人们为什么都说迪士尼？",@"除了去足校踢球，上大学踢球有机会踢职业吗？",@"为什么进攻型球员防守数据都好低，有漂亮抢断和铲球的进攻球员也很多啊。。",@"各位觉得目前足坛最有可能的一桩转会是什么？",@"两个中年巴萨和皇马球迷的对话",@"急急急",@"有没有好玩的足球游戏",@"好的坏的总会过去的[棒棒哒]",@"喜欢上一个不该喜欢的人",@"大力神杯！！！",@"國奧前景",@"☁",@"足球梦",@"求问各位大佬",@"如果被队友嫌弃了怎么办",@"韩寒发图，照片里这个人是不是于海？",@"感谢我懂",@"求中国通国外的VPN，谢谢",@"英超新聞",@"为什么喜欢足球？足球的魅力有哪些",@"看来中国u23最后一场必须取胜才能出现了！",@"我发现热巴还百度过越位呢[谄媚]",@"期末考试必胜！",@"你👌",@"哪个年代的足球更精彩",@"又见老友！米卢重回中国任职",@"请问：足协收取巨额引援调节费是为什么？",@"看到这么多瞧不起自己国家运动的，不看球喷中国球迷的真是觉D3悲哀",@"说起当今足坛的b2b中场，你第一个想起谁？",@"我们距离日本足球还有多远？",@"先来一单",@"气愤，居然还有这种观念！",@"今年夏天巴黎圣日耳曼的引援名单惨遭泄密",@"下一个亿元先生会是谁？",@"求指教！B2B什么意思",@"我想看看谁敢不支持客队？[捂嘴][捂嘴][捂嘴]",@"英格兰再拿一次世界杯明年有戏否",@"求样子比较像明星的球员",@"进攻无敌了",@"等巴萨来中国的时候\n要不要一起去看一场永生难忘的球赛。",@"哪个强？",@"谁有那个图，就是主席的话照亮了我那个",@"高三狗求各路大神解答",@"你觉得95后球员谁未来发展上限最高？",@"不知道亚冠资格赛啥时候打啊！有点期待啊！",@"足球与商业",@"广州日报新闻为什么看不到了",@"有些话想说很久了",@"职业比赛替补席不可以带手机吗？",@"有没有世界杯列强巡礼的精华帖",@"乌烟瘴气",@"湖南省青少年足球锦标赛的黑暗",@"感觉这个风格的图有很多，哪位能提供全套或者出处",@"教我任意球",@"大家看比赛会刻意去记球网颜色吗",@"如果杯赛中，你的主队获小组第一会对其他小组第二，而其他小组第二比第一强，你希望你的主队得第一还...",@"U23亞洲杯",@"你觉得谁是足球历史最佳？",@"今年大三挂了三门课咋办啊？",@"齐了",@"请问现役或者已退役的球员有没有穿36号球衣的",@"比我用的费的来报道一下，我看看有木有",@"我大广东的天气真好玩",@"我先 中午觉觉觉觉觉觉觉觉觉。。。。。",@"中国梦",@"其他app球迷究竟处于什么水平?",@"初一数学题",@"高三狗今年高考[感动]那个大学有好的足球专业求大神指点[祈福]",@"手机足球游戏啊浪最好玩，内存小的",@"大家玩微信的头脑王者了吗？",@"成都业余足球圈的朋友",@"有没有人给俱乐部寄过信？？",@"历届世界杯用球你们最喜欢哪一个？\n我先来：\n桑巴荣耀（2014年巴西世界杯）",@"熟悉的味道",@"小伙子们加油！！",@"今天看到笑喷了"];
        
        headerImgs = @[@"/2017/08/09/pYsXxrzqnF.2676.jpg!avatarsmall",@"/2017/12/11/4sgtvQNcKh.0429.jpg!avatarsmall",@"/2017/05/18/lbDaawZHzs_3191812!avatarsmall",@"/2017/11/13/eDw8uLfUYI5KhwF0Bpyb_avatar.jpg!avatarsmall",@"/2017/06/30/QHKacgeX4V_thumb_1498822206244.jpg!avatarsmall",@"/2017/11/05/E0wGwtgp1RgoYLGsKXos_avatar.jpg!avatarsmall",@"/2017/04/19/Oho15mdn7O_thumb_1492536616485.jpg!avatarsmall",@"/2017/06/29/tUc7qgeLGx_avatar.jpg!avatarsmall",@"/2017/12/11/4sgtvQNcKh.0429.jpg!avatarsmall",@"/2017/07/23/Rdnsdq5oos.7672.jpg!avatarsmall",@"/2017/09/22/F0OR3jIDC1.9566.jpg!avatarsmall",@"/2017/05/18/faFTvdXaob_2557742!avatarsmall",@"/2017/12/17/fXBnYiGYfH.2224.jpg!avatarsmall",@"/2017/05/18/9ySkjkozim_3044828!avatarsmall",@"/2018/01/12/704vpLPggw.9566.jpg!avatarsmall",@"/2017/12/23/ZcV35qAMqL.8661.jpg!avatarsmall",@"/2017/06/22/oOmWoM7ikQ_avatar.jpg!avatarsmall",@"/2017/12/20/zALnjT9fsNo8wKTY2zaU_avatar.jpg!avatarsmall",@"/2017/04/10/9BLSLkvj6R_avatar.jpg!avatarsmall",@"/2017/01/15/P7SgSKPKdc_thumb_1484453680313.jpg!avatarsmall",@"/2017/09/03/IdBUGiLYLu.2789.jpg!avatarsmall",@"/2017/12/08/O9uN6SIIVf.4701.jpg!avatarsmall",@"/2017/05/18/R8Ph0JVmmp_2113323!avatarsmall",@"/2017/04/18/gdxbuKNgdQ_avatar.jpg!avatarsmall",@"/2017/01/15/P7SgSKPKdc_thumb_1484453680313.jpg!avatarsmall",@"/2017/05/18/sD3lzfELgr_2958021!avatarsmall",@"/2017/05/18/e8apm6LVAZ_1568524!avatarsmall",@"/2018/01/12/tqxvcJDjlK.7447.jpg!avatarsmall",@"/2017/12/14/3lvgpC2cis.0855.jpg!avatarsmall",@"/2017/05/24/NeBvQk6aOc_avatar.jpg!avatarsmall",@"/2017/08/25/rRSN89gGAq.9753.jpg!avatarsmall",@"/2017/08/02/LZde1070zp.9243.jpg!avatarsmall",@"/2017/11/06/fBlyEQ3mDm.5864.jpg!avatarsmall",@"/2018/01/13/x76gaFiMJx.6647.jpg!avatarsmall",@"/2017/04/16/VD2nYm7Yu2_thumb_1492307237291.jpg!avatarsmall",@"/2017/05/18/b4z4JGnNTW_2835213!avatarsmall",@"/2017/12/23/fZMtKrUeIt.671.jpg!avatarsmall",@"/2017/07/10/gULyelFBnHB2na4p4fpS_avatar.jpg!avatarsmall",@"/2017/05/22/AuUoV5fQDq_thumb_1495413324940.jpg!avatarsmall",@"/2017/12/22/ts844edwJx.8435.jpg!avatarsmall",@"/2017/12/07/xYTi25crCDEajAtqs8C0_avatar.jpg!avatarsmall",@"/2017/05/18/nz7rqvjwh0_2070267!avatarsmall",@"/2017/05/18/YhP2biqJBl_1988467!avatarsmall",@"/2017/05/18/eoh44v8eJB_1986663!avatarsmall",@"/2017/10/08/QBC7PAu61z.0379.jpg!avatarsmall",@"/2017/12/05/sxLzwzhFqZ.8398.jpg!avatarsmall",@"/2018/01/11/uFgguXkF2f.3517.jpg!avatarsmall",@"/2017/05/26/vMQCcfdCT8_thumb_1495811201949.jpg!avatarsmall",@"/2017/01/21/vUGJwprIB9_avatar.jpg!avatarsmall",@"/2017/09/03/gA4JUr65bh.2513.jpg!avatarsmall",@"/2017/08/24/axH3xO2ANm.8484.jpg!avatarsmall",@"/2017/12/23/ZcV35qAMqL.8661.jpg!avatarsmall",@"/2017/11/12/RmFibnz0sR.787.jpg!avatarsmall",@"/2017/05/24/NeBvQk6aOc_avatar.jpg!avatarsmall",@"/2017/12/19/1xVmhTP3Kt.5756.jpg!avatarsmall",@"/2017/05/18/tqgBqjAYYj_1668797!avatarsmall",@"/2017/12/20/sRUt06S4N6.8812.jpg!avatarsmall",@"/2017/05/18/R8Ph0JVmmp_2113323!avatarsmall",@"/2017/08/09/pYsXxrzqnF.2676.jpg!avatarsmall",@"/2017/04/17/0d3Wwug4G4_thumb_1492417890536.jpg!avatarsmall",@"/2017/11/19/MeHwyrQ6Jv.196.jpg!avatarsmall",@"/2017/05/18/Ful199gV1q_2403956!avatarsmall",@"/2017/11/02/7d1xxtIDol.6435.jpg!avatarsmall",@"/2017/12/23/ZcV35qAMqL.8661.jpg!avatarsmall",@"/2017/05/18/Unw569PqR4_1076935!avatarsmall",@"/2018/01/13/C0mCl0lJiB.5799.jpg!avatarsmall",@"/2017/11/17/yM8ALDYFmN.8898.jpg!avatarsmall",@"/2018/01/07/jOIgFsZUvR.8397.jpg!avatarsmall",@"/2017/03/03/XnStQj5TKW_thumb_1488513303527.jpg!avatarsmall",@"/2016/11/24/90QQrw91UH_thumb_1479962028885.jpg!avatarsmall",@"/2017/10/22/8nrieXz9tVPh26whL40E_avatar.jpg!avatarsmall",@"/2017/05/18/uqfhONsRai_1934582!avatarsmall",@"/2017/05/18/qaFDRRVrkW_1564739!avatarsmall",@"/2017/05/18/qaFDRRVrkW_1564739!avatarsmall",@"/2015/11/21/BPEKBbSMaN_avatar.jpg!avatarsmall",@"/2017/12/30/DkWAqNz8De.0555.jpg!avatarsmall",@"/2018/01/12/704vpLPggw.9566.jpg!avatarsmall",@"/2017/05/12/meLWewinsr_thumb_1494556057657.jpg!avatarsmall",@"/2017/08/24/PjWQfkSqth.6336.jpg!avatarsmall",@"/2017/10/09/2IruPzIVmd.7635.jpg!avatarsmall",@"/2017/05/18/6ODRV7R8AD_3174675!avatarsmall",@"/2017/12/28/ucyZYsBmiF.4407.jpg!avatarsmall",@"/2017/09/20/5o3YSlmWxw.2601.jpg!avatarsmall",@"/2017/08/09/VqtPkSQx9N.5193.jpg!avatarsmall",@"/2017/08/28/1LCPnjp0ws.1482.jpg!avatarsmall",@"/2018/01/06/EdHIMeMOPv.4639.jpg!avatarsmall",@"/2017/11/29/f99KL1h8rz.2914.jpg!avatarsmall",@"/2017/12/24/LMHg9RWjSL.4235.jpg!avatarsmall",@"/2017/12/23/V5zhAbr684.2626.jpg!avatarsmall",@"/2015/10/07/LGyAD8zgDq_thumb_1444206339319.jpg!avatarsmall",@"/2017/08/09/MB6JrhSLl8.5287.jpg!avatarsmall",@"/2017/12/23/L28Vqq3Yum.6233.jpg!avatarsmall",@"https://img.dongqiudi.com/data/user/black.png!avatarsmall",@"/2017/12/30/SZp7L2SSVo.2794.jpg!avatarsmall",@"/2017/09/24/fx3j9Xq81W.7229.jpg!avatarsmall",@"/2018/01/13/jZQSDvIRM6.4459.jpg!avatarsmall",@"/2018/01/02/IU0KdaAXkb.7421.jpg!avatarsmall",@"/2017/05/18/xfwjQJO6ZQ_2979657!avatarsmall",@"/2017/08/22/Ul5TFwhDuH.8063.jpg!avatarsmall",@"/2015/11/28/5IUD5A9ual_thumb_1448699949126.jpg!avatarsmall",@"/2017/12/16/n64wGehpe4.6593.jpg!avatarsmall",@"/2018/01/11/YuBH77xqM6.3848.jpg!avatarsmall",@"/2017/10/31/EerKXjJQY6.6642.jpg!avatarsmall",@"/2017/12/23/ZcV35qAMqL.8661.jpg!avatarsmall",@"/2017/05/18/wuOq6UTuFb_336537!avatarsmall",@"/2017/12/28/ucyZYsBmiF.4407.jpg!avatarsmall",@"/2017/09/18/OD8ugUFIrr.5405.jpg!avatarsmall",@"/2017/05/18/wuOq6UTuFb_336537!avatarsmall",@"/2017/10/06/jZedHhdehFsRvBoc1DZY_avatar.jpg!avatarsmall",@"/2016/09/16/QVrZpwIMbm_avatar.jpg!avatarsmall",@"/2018/01/06/ktEYRB9eU1.9135.jpg!avatarsmall",@"/2017/05/18/xkefHs8urr_1513369!avatarsmall",@"/2017/04/16/qtQ1iIXFhX_thumb_1492339747259.jpg!avatarsmall",@"/2017/05/18/QUU2byU3X1_1999574!avatarsmall",@"/2017/12/30/DkWAqNz8De.0555.jpg!avatarsmall",@"/2018/01/05/cMJLheF4Hy.6479.jpg!avatarsmall",@"/2017/05/18/wXZlMDkUKq_1541658!avatarsmall",@"/2017/05/18/9LD8SwMt9I_1821651!avatarsmall",@"/2017/05/18/yGuiyUsvL6_3043996!avatarsmall",@"/2017/12/16/n64wGehpe4.6593.jpg!avatarsmall",@"/2016/02/25/rn7U1SS9Mo_avatar.jpg!avatarsmall",@"/2017/12/23/l6hqNKppvK.2847.jpg!avatarsmall",@"/2017/01/15/P7SgSKPKdc_thumb_1484453680313.jpg!avatarsmall",@"/2017/07/30/569cZTrsrX.1896.jpg!avatarsmall",@"/2017/05/18/kk057gZUZV_1774743!avatarsmall",@"/2017/12/12/ygmmGrTIr0.5292.jpg!avatarsmall",@"/2017/06/03/7XrqJoZrx0_thumb_1496484485932.jpg!avatarsmall",@"/2017/08/28/Q2ulOpyV45.1157.jpg!avatarsmall",@"/2018/01/12/RqgViIybtO.1002.jpg!avatarsmall",@"/2017/05/18/X0b1UtDtpy_1853695!avatarsmall",@"/2016/10/03/rpPxWbSfOT_avatar.jpg!avatarsmall",@"/2017/07/02/Ar4c9ahDjg_thumb_1499003400431.jpg!avatarsmall",@"https://img1.dongqiudi.com/fastdfs1/M00/3B/EF/o4YBAFjM9lqAel9GAAAQrsgeQ3A103.jpg",@"/2016/12/06/5Bk0AZVbjl_thumb_1481014310691.jpg!avatarsmall",@"/2017/05/10/kSQX9dtlT0_avatar.jpg!avatarsmall",@"/2017/05/18/LmkuV8dd3O_1492633!avatarsmall",@"/2016/11/06/gozCBGadMc_avatar.jpg!avatarsmall",@"/2017/07/15/3n8RkYdEen.3146.jpg!avatarsmall",@"https://img.dongqiudi.com/data/user/black.png!avatarsmall",@"/2017/01/21/vUGJwprIB9_avatar.jpg!avatarsmall",@"/2017/05/18/7LQseSBeAq_2577275!avatarsmall",@"/2017/12/24/nHgOcXZE3A.209.jpg!avatarsmall",@"/2017/07/31/Er0QTs0hql.8601.jpg!avatarsmall",@"/2017/12/21/27O8RJKNQq.8126.jpg!avatarsmall",@"/2017/06/04/TpQEQQgVv2_thumb_1496572729881.jpg!avatarsmall",@"/2017/01/12/Xxvm8huS4x_avatar.jpg!avatarsmall",@"/2017/10/29/B3T5loNfJE.4281.jpg!avatarsmall",@"/2017/12/30/SPDe4iyWFj.8832.jpg!avatarsmall",@"/2017/11/13/0rGe9ByRun.5619.jpg!avatarsmall",@"/2017/05/18/1Sj1MNCz2B_1589434!avatarsmall",@"/2017/08/16/m3oZBG8Dbx.568.jpg!avatarsmall",@"/2017/05/18/py7qiWs6Dt_2245141!avatarsmall",@"/2017/08/17/hl5vRIlgvS.2331.jpg!avatarsmall",@"/2017/08/17/hl5vRIlgvS.2331.jpg!avatarsmall",@"/2017/05/25/sIRThDEGPh_thumb_1495692613585.jpg!avatarsmall",@"/2017/04/13/2awuQMZtZp_avatar.jpg!avatarsmall",@"/2017/12/23/ZcV35qAMqL.8661.jpg!avatarsmall",@"/2017/05/18/ycobo0kOdF_2923476!avatarsmall",@"/2018/01/03/YSHsvsGonw.919.jpg!avatarsmall",@"/2017/05/18/6gZg3tDH0o_2843545!avatarsmall",@"/2017/10/13/BoJjz2t97u.5256.jpg!avatarsmall",@"https://img.dongqiudi.com/data/user/black.png!avatarsmall",@"/2017/12/16/KZbZ8LrHDg.1954.jpg!avatarsmall",@"/2017/05/18/TcYzCfhlbb_3375850!avatarsmall",@"/2018/01/07/oNbEDbOwJ4.0187.jpg!avatarsmall",@"/2017/05/11/xgDJTov0O0_1951140!avatarsmall",@"/2016/07/21/3cPRWykE38_avatar.jpg!avatarsmall",@"/2017/12/26/cW2jmnGQ1PwmINzn8u3Z_avatar.jpg!avatarsmall",@"/2018/01/03/kutKoKnqjF.7291.jpg!avatarsmall",@"/2017/05/18/Dkg0cOqoUT_892439!avatarsmall",@"/2016/06/14/WuR4sMQZiz_thumb_1465867772256.jpg!avatarsmall",@"/2017/05/18/l6VOdQo1js_209271!avatarsmall",@"/2017/08/08/OfJL0ec2gj.5244.jpg!avatarsmall",@"https://img.dongqiudi.com/data/user/black.png!avatarsmall",@"/2017/08/17/hl5vRIlgvS.2331.jpg!avatarsmall",@"/2017/06/29/bA1PgMinrczipKCs2srh_avatar.jpg!avatarsmall",@"/2018/01/07/3VxjTYwK9d.367.jpg!avatarsmall",@"/2017/08/17/hl5vRIlgvS.2331.jpg!avatarsmall",@"/2017/05/18/EQEl5u4qkn_1128243!avatarsmall",@"/2017/08/17/hl5vRIlgvS.2331.jpg!avatarsmall",@"/2017/08/17/y9WeflXaO1.4905.jpg!avatarsmall",@"/2017/12/20/CcopMDnvdn.3504.jpg!avatarsmall",@"/2017/05/03/NplSSf4ttz_thumb_1493743408255.jpg!avatarsmall",@"/2017/12/23/wM22YpNGBh.5893.jpg!avatarsmall",@"/2017/07/10/gULyelFBnHB2na4p4fpS_avatar.jpg!avatarsmall",@"/2017/07/14/3ANookqGAh_.0663.jpg!avatarsmall",@"/2018/01/12/704vpLPggw.9566.jpg!avatarsmall",@"/2016/10/27/6ojO0PEP2S_thumb_1477577422745.jpg!avatarsmall",@"/2017/10/30/xHtUOWGWcy.1232.jpg!avatarsmall",@"/2017/08/22/SIRCSJbhxp.1942.jpg!avatarsmall",@"/2017/01/15/P7SgSKPKdc_thumb_1484453680313.jpg!avatarsmall",@"/2018/01/03/7857b0DVbD.6623.jpg!avatarsmall",@"https://img.dongqiudi.com/data/user/black.png!avatarsmall",@"/2017/05/18/K9VSGg3xcw_1478868!avatarsmall",@"/2017/12/25/9IT783cWEi.8913.jpg!avatarsmall",@"/2014/09/05/RN7NMoiJRq_thumb_1409924536350.jpg!avatarsmall",@"/2016/09/14/Fcqy7y0BtQ_avatar.jpg!avatarsmall",@"/2017/12/18/jXdvVk4uSg.9623.jpg!avatarsmall",@"/2018/01/11/zkFksynuMH.1608.jpg!avatarsmall",@"/2018/01/07/jGNHwejhMX.6543.jpg!avatarsmall",@"/2017/05/18/ywrxexyizY_1099363!avatarsmall",@"/2018/01/12/Xq6GCJPwda.4543.jpg!avatarsmall",@"/2017/07/30/569cZTrsrX.1896.jpg!avatarsmall",@"/2016/11/26/BmHceg7VCP_thumb_1480171892968.jpg!avatarsmall",@"/2017/09/13/1XjQNUHkSf.3766.jpg!avatarsmall",@"/2016/06/02/7T4eySVgSz_avatar.jpg!avatarsmall",@"/2014/09/05/RN7NMoiJRq_thumb_1409924536350.jpg!avatarsmall",@"/2016/08/29/KuAYZN7jvG_thumb_1472433409869.jpg!avatarsmall",@"/2017/05/18/H2FMzEhNUw_2841662!avatarsmall",@"/2016/06/17/UuKcrejV2B_thumb_1466159341101.jpg!avatarsmall",@"/2017/12/22/hB0eWvlvYA.9417.jpg!avatarsmall",@"https://img1.dongqiudi.com/fastdfs1/M00/3B/EF/o4YBAFjM9lqAel9GAAAQrsgeQ3A103.jpg",@"/2014/12/11/MTDgje6Anq_thumb_1418305918426.jpg!avatarsmall",@"/2017/09/28/53fM1ivuMn.2264.jpg!avatarsmall",@"/2017/05/10/ZRGhGsZmfK_thumb_1494424450808.jpg!avatarsmall",@"/2017/05/18/2SQU0qqLSk_1656830!avatarsmall",@"/2017/10/28/rmGEAbXpaj.3981.jpg!avatarsmall",@"/2017/05/18/e8apm6LVAZ_1568524!avatarsmall",@"/2017/05/18/e8apm6LVAZ_1568524!avatarsmall",@"/2017/06/15/OZGbSzr9bN_thumb_1497528662220.jpg!avatarsmall"];
    }
    return self;
}

//- (id)initWithMessage:(MJVendorsMessage*)msg {
//    self = [super init];
//    if (self) {
//        self.type = @"image";
//        self.avatar = [NSURL URLWithString:[msg getHeadImgUrl]];
//        self.content = [msg getContent];
//        self.detail = @"";
//        self.imgs = [msg getImages];
//        self.name = [msg getBg_show_name];
//        self.statusID = @(10);
//        self.isLike = [msg getIs_like];
//        self.thumbnail = @[];
//        NSTimeInterval time = arc4random() % 3600;
//        self.date = [[NSDate date] dateByAddingTimeInterval:-time];
//
//
//        NSMutableArray* liskArr = [NSMutableArray array];
//        for (MJVendorsIsLikeObjc* like in [msg getLike_list]) {
//            [liskArr addObject:[like getName]];
//        }
//        self.likeList = liskArr;
//
//        NSMutableArray* commentArr = [NSMutableArray array];
//        for (MJVendorsComment* comment in [msg getComment_list]) {
//            NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:3];
//
//            [dic setObject:[comment getFrom] forKey:@"from"];
//            [dic setObject:@"" forKey:@"to"];
//            [dic setObject:[comment getContent] forKey:@"content"];
//            [commentArr addObject:dic];
//        }
//
//        self.commentList = commentArr;
//    }
//    return self;
//}

- (id)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        
        
        
        self.type = dict[@"type"];
        self.avatar = [NSURL URLWithString:dict[@"avatar"]];
        self.content = dict[@"content"];
        self.detail = dict[@"detail"];
        self.date = [NSDate dateWithTimeIntervalSince1970:[dict[@"date"] floatValue]];
        self.imgs = dict[@"imgs"];
        self.name = dict[@"name"];
        self.statusID = dict[@"statusID"];
        self.commentList = dict[@"commentList"];
        self.likeList = dict[@"likeList"];
        self.isLike = [dict[@"isLike"] boolValue];
        self.thumbnail = dict[@"thumbnail"];
    }
    return self;
}


- (id)copyWithZone:(NSZone *)zone {
    StatusModel* one = [[StatusModel alloc] init];
    one.type = [self.type copy];
    one.avatar = [self.avatar copy];
    one.content = [self.content copy];
    one.detail = [self.detail copy];
    one.date = [self.date copy];
    one.imgs = [self.imgs copy];
    one.name = [self.name copy];
    one.statusID = [self.statusID copy];
    one.commentList = [self.commentList copy];
    one.likeList = [self.likeList copy];
    one.isLike = self.isLike;
    one.thumbnail = self.thumbnail;
    return one;
}

- (void)createModel {
    self.type = @"image";
    NSInteger headCount = headerImgs.count;
    NSString* url = [NSString stringWithFormat:@"https://img.dongqiudi.com/uploads/avatar%@",headerImgs[arc4random() % (headCount)]];
    self.avatar = [NSURL URLWithString:url];
    self.content = contentS[arc4random() % (contentS.count)];
    self.detail = @"22222";
    NSTimeInterval time = arc4random() % 3600;
    self.date = [[NSDate date] dateByAddingTimeInterval:-time];
    
    NSInteger jjss = arc4random() % 9;
    NSInteger cccc = jjss - 7;
    NSInteger imgCount = MAX(cccc, 0);
    NSMutableArray* tmp = [NSMutableArray array];
    for (NSInteger j = 0 ; j < imgCount; j++) {
        NSString* imgUrl = [NSString stringWithFormat:@"https://img.dongqiudi.com/uploads/attachments%@",imgTotal[arc4random() % imgTotal.count]];
        [tmp addObject:imgUrl];
    }
    self.imgs = tmp;
    self.name = names[arc4random() % names.count];
    self.statusID = @(10);
    

    
    NSInteger m1 = arc4random() % 4;
    NSInteger m2 = m1 - 2;
    NSInteger commentCount = MAX(m2, 0);
//    NSInteger commentCount = arc4random() % 2;
    NSMutableArray* commentArr = [NSMutableArray array];
    for (int i = 0; i < commentCount; i++) {
        NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:3];
        [dic setObject:names[arc4random() % names.count] forKey:@"from"];
        [dic setObject:self.name forKey:@"to"];
        [dic setObject:contentS[arc4random() % (contentS.count)] forKey:@"content"];
        [commentArr addObject:dic];
    }
    
    
    self.commentList = commentArr;

    
    NSInteger likeCount = arc4random() % 3;
    NSMutableArray* likeArr = [NSMutableArray array];
    for (int c = 0; c < likeCount; c++) {
        [likeArr addObject:names[arc4random() % names.count]];
    }
    
    self.likeList = likeArr;
    self.isLike = NO;
    self.thumbnail = @[];
    
    
    
}

@end
