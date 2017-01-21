

#import "LyMacro.h"





NSString *const app_boudleIdentifier             = @"com.517xueche.apple.teacher";
NSString *const appStore_id                      = @"1107516360";
NSString *const appStore_url                     = @"itms-apps://itunes.apple.com/app/id1107516360";

NSString *const host_url                         = @"https://www.517xc.com";


NSString *const share_url    = @"https://www.517xc.com";
NSString *const shareTitle   = @"我要去学车-教练端";
NSString *const shareContent = @"我要去学车-教练端是一款专为驾校、教练、随车指导员量身打造的一款招生、学车APP，全国教练都在用的招生神器，就差你了，赶快下载吧！！";
NSString *const shareContent_sinaWeibo = @"我要去学车-教练端是一款专为驾校、教练、随车指导员量身打造的一款招生、学车APP，全国教练都在用的招生神器，就差你了，赶快下载吧！https://www.517xc.com";




//支付宝相关
NSString *const alipayPartner                    = @"2088111222703104";
NSString *const alipaySeller                     = @"xueche517@163.com";
NSString *const alipayPrivateKey                 = @"MIICXAIBAAKBgQDhbEYy0eVxbKn6YDsbDoZeGsver2/XT8FUVAsiB6SIJ3dGYxeBuqVCaxsUeQczgt8B01CImePOKqHejmZ91ErTQQ6RuYM3Ef9x1g+YqPVoofQAbp2kuIjvYu8e3uG4eS76kMeQ32wTWXFaz00VHPPuq5uLn0lckr144a/5gECFjQIDAQABAoGAMM/QN4rpwvDDsbqKseYoRFJLGPImJppXg5obOwgqoWziT/R/D5FJ3aLxnzJB0+6fuXZ3dszT3j2vBVEScma4uLPBWjFqTcwAfygz6AgBqtCXZ/g+yOc19ql+QgSWJm562cTP+l39DWf7KjQaJMmuyfcB+ef0WRsPQZAfEnjpdiECQQD4vdMxC/ZDIciIa6EcvXfk/yBdZyLrKqlsh4yUCBbHrfo0RspMGWzgi8uE0lWWFIYpwSz87Xvq7vRkgLQXEaKZAkEA6ABAo41m5vYjYfhQ4aQ3oQuYVHytrLNwx8Fvfy4THXKjLMG7qYEF4hNJazJyiXXBst4fmudprU1g+vH/eLwHFQJAGDcClEfB1Y84Ym9348BeJ6DembksoRAqJjKb8N1Ium+pZ+VsVDQ1cTaqvWdshYvB89amdoj4A0r358DPx18kIQJBAMGOfF83eLOWhRyWhDxMupCk0NkkD+2244/0pWYQ9aeq3dJYa43WdCcSej1yIDboxMrLIMkm6nbIyPF0dvSuwqUCQGMjyAK4wSNrqggxFxX8EYKmyGX6chMaMIkt6x41Yju8LEzzoTXbxveBA5LA0x2/uSDtkiurdMebHIngdbQ7N0A=";


//qq相关
NSString *const qqAppId                          = @"1105636141";//41E6AB2D
NSString *const qqAppKey                        = @"oXRNEhd12YcXeRhO";

//新浪微博相关
NSString *const sinaWeiBoAppKey                  = @"138773431";
NSString *const sinaWeiBoAppSercet               = @"c6d6e716f8d7c07e44af32367c1eb31d";
//NSString *const sinaAuth_url                     = @"http://192.168.67.163/10.19/php/Home/Index/sinaAuth";
//NSString *const cancelSinaAuth_url               = @"http://192.168.67.163/10.19/php/Home/Index/cancelSinaAuth";
NSString *const sinaAuth_url                     = @"http://192.168.67.163/10.19/php/Home/Index/sinaAuth";
NSString *const cancelSinaAuth_url               = @"http://192.168.67.163/10.19/php/Home/Index/cancelSinaAuth";


//微信相关
NSString *const weChatAppId                      = @"wx6ed315ce5d299c95";
NSString *const weChatAppSecret                  = @"8067fd1c4726ca82565c44e0b0fdb64a";

//mob相关
NSString *const shareSDKAppKey                   = @"1766bbd4dba98";
NSString *const shareSDKAppSecret                = @"b23035f8d5b027eb5187f1b4280536dd";


//JPush相关
NSString *const JPushAppKey                     = @"90700c625a86a3feede5f5e4";
NSString *const JPushMasterSecret               = @"29b4376471512f01f15272c3";
NSString *const JPushChannel                    = @"App Store";
NSString *const JPushRegistrationID             = @"JPushRegistrationID";
#if DEBUG
BOOL JPushIsProduction = NO;
#else
BOOL JPushIsProduction = YES;
#endif


//加密
NSString *const aes128key                        = @"j25dys8zvf7y8ltl";
NSString *const aes128iv                         = @"tw0t7u1apwqhe57u";
NSString *const aes256key                        = @"j25dys8zvf7y8ltl";
NSString *const aes256iv                         = @"tw0t7u1apwqhe57u";


NSString *const userTypeKey_tc                      = @"userTypeKey_tc";
NSString *const userId517Key_tc                     = @"userId517Key__tc";
NSString *const userAccount517Key_tc                = @"userAccount517Key__tc";
NSString *const userPassword517Key_tc               = @"userPassword517Key__tc";
NSString *const userName517Key_tc                   = @"userName517Key__tc";
NSString *const userVerifyKey_tc                    = @"UserVerifyKey_tc";
//NSString *const userAutoLoginFlagKey = @"";
//#define userAutoLoginFlagKey                            [[NSString alloc] initWithFormat:@"userAutoLoginFlagKey%@__tc", [[NSUserDefaults standardUserDefaults] objectForKey:userId517Key_tc]]



NSInteger const codeTimeOut = 10;
NSInteger const codeMaintaining = 11;





NSString *const model_admin                      = @"Admin";
NSString *const model_upload                     = @"Upload";

NSString *const category_index                   = @"Index";
NSString *const category_search                  = @"Search";
NSString *const category_upload                  = @"Upload";
NSString *const category_driving                 = @"Driving";
NSString *const category_coach                   = @"Coach";
NSString *const category_school                  = @"School";
NSString *const category_wallet                  = @"Wallet";
NSString *const category_theory                  = @"Theory";
NSString *const category_activity                = @"Banner";
NSString *const category_userdynamic             = @"Userdynamic";
NSString *const category_dynamic                 = @"Dynamic";
NSString *const category_banner                  = @"Banner";

NSString *const category_small                   = @"small";
NSString *const category_big                     = @"big";


NSString *const teacherCoachKey                  = @"jl";
NSString *const teacherSchoolKey                 = @"jx";
NSString *const teacherGuiderKey                 = @"zdy";

//------------------------
NSString *const getListStartKey                  = @"start";
NSString *const getListTypeKey                   = @"type";


NSString *const keyKey                          = @"key";
NSString *const valueKey                        = @"value";


NSString *const nearTeacherModeKey               = @"typed";
NSString *const nearTeacherAddressKey            = @"objectname";

NSString *const latitudeKey                      = @"latitude";
NSString *const longitudeKey                     = @"longitude";

//培训价格详情


NSString *const priceDetailIdKey                 = @"id";
NSString *const priceDetailWeekdayKey            = @"weekdays";
NSString *const priceDetailTimeBucketKey         = @"timebucket";
NSString *const priceDetailPriceKey              = @"price";


NSString *const aboutKey                         = @"about";
NSString *const aboutMeKey                       = @"aboutme";

NSString *const aboutMePraiseKey                 = @"praise";
NSString *const aboutMeTransmitKey               = @"forward";
NSString *const aboutMeEvaluateKey               = @"evaforstatus";
NSString *const aboutMeReplyKey                  = @"return";


NSString *const aboutMeObjectAmIdKey             = @"dynamicid";


NSString *const modeKey                          = @"mode";




NSString *const sessionIdKey                     = @"session_id";

NSString *const pathKey                          = @"path";
NSString *const pngKey                           = @"png";
NSString *const jpgKey                          = @"jpg";

NSString *const userIdKey                        = @"userid";
NSString *const accountKey                       = @"account";
NSString *const phoneKey                         = @"phone";
NSString *const passowrdKey                      = @"pass";
NSString *const newPasswordKey                   = @"newpass";
NSString *const clientModeKey                    = @"type";
NSString *const deviceModeKey                    = @"device";
NSString *const versionKey                       = @"version";
NSString *const verifyKey                        = @"verify";

NSString *const balanceKey                       = @"yue";
NSString *const wuCoinKey                        = @"bi";
NSString *const couponCountKey                   = @"couponcount";

NSString *const codeKey                          = @"code";
NSString *const lastestKey                       = @"latest";
NSString *const newestKey                        = @"max";
NSString *const resultKey                        = @"result";
NSString *const download_urlKey                  = @"downloadurl";
NSString *const nickNameKey                      = @"nickname";
NSString *const trueNameKey                      = @"truename";
NSString *const fullNameKey                     = @"fullname";
NSString *const objectNameKey                    = @"objectname";

NSString *const avatarNameKey                    = @"img";


NSString *const authKey                          = @"auth";
NSString *const trueAuthKey                     = @"trueauth";
NSString *const phoneNumberKey                   = @"phonenumber";
NSString *const messageKey                       = @"message";


NSString *const idKey                            = @"id";
NSString *const sexKey                           = @"sex";
NSString *const birthdayKey                      = @"birthday";

NSString *const driveBirthdayKey                = @"driverage";
NSString *const teachBirthdayKey                = @"teachedage";
NSString *const addressKey                       = @"address";

NSString *const avatarKey                        = @"img";
NSString *const signatureKey                     = @"signature";
NSString *const gradeKey                         = @"grade";
NSString *const driveLicenseKey                  = @"jtype";



NSString *const studyCostKey                     = @"cost";


NSString *const newsKey                          = @"news";


//驾校列表

NSString *const locationKey                      = @"location";
NSString *const landMarkKey                      = @"landmark";
NSString *const landNameKey                     = @"landname";
NSString *const landMarkRecordKey               = @"sid";
NSString *const landKey                         = @"land";
NSString *const landMarkIdKey                   = @"landid";

//驾校详情
NSString *const nameKey                          = @"name";
NSString *const scoreKey                         = @"score";
NSString *const priceKey                         = @"price";
NSString *const minPriceKey                      = @"minprice";
NSString *const teachAllCountKey                 = @"allcount";
NSString *const teachedPassedCountKey            = @"passedcount";
NSString *const teachableCountKey                = @"teachablecount";
NSString *const evalutionCountKey                = @"evalutioncount";
NSString *const praiseCountKey                   = @"praisecount";
NSString *const teachedAgeKey                    = @"teachedage";
NSString *const drivedAgeKey                     = @"driverage";
NSString *const introductionKey                  = @"introduction";
NSString *const trainBaseKey                     = @"train";
NSString *const lastStudentKey                   = @"student";
NSString *const signTimeKey                      = @"signtime";
NSString *const teachAllPeriodKey                = @"counttime";

NSString *const trainBaseIdKey                   = @"trainid";


NSString *const bannerUrlKey                     = @"img";
NSString *const picCountKey                      = @"piccount";
NSString *const imageKey                        = @"img";
NSString *const imageUrlKey                      = @"imgurl";
NSString *const imageNameKey                    = @"imgname";
NSString *const objectIdKey                      = @"objectid";

NSString *const objectingIdKey                   = @"objecthingid";

NSString *const objectMasterIdKey                = @"objecthingid";



NSString *const pickRangeKey                     = @"pickrange";
NSString *const hotFlagKey                       = @"hotflag";
NSString *const recomendFlagKey                  = @"recommendflag";
NSString *const certificateFlagKey               = @"certificateflag";
NSString *const pickFlagKey                      = @"pickflag";
NSString *const timeFlagKey                      = @"timeflag";

NSString *const attentionFlagKey                 = @"conflag";

NSString *const trainAddressKey                  = @"trainaddress";

NSString *const depositKey                       = @"prepay517deposit";

//培训课程
NSString *const trainClassIdKey                  = @"tcid";
NSString *const trainClassCountKey               = @"classcount";
NSString *const trainClassKey                    = @"class";
NSString *const carNameKey                       = @"carname";
NSString *const trainClassModeKey                = @"mode";;
NSString *const trainClassLiceseTypeKey          = @"jtype";
NSString *const officialPriceKey                 = @"officialprice";
NSString *const whole517PriceKey                 = @"whole517price";
NSString *const prepay517priceKey                = @"prepay517price";
//NSString *const depositKey                      = @"deposit";
NSString *const trainClassTimeKey                = @"classtime";
NSString *const includeKey                       = @"include";
NSString *const waitDayKey                      = @"linetime";
NSString *const objectSecondKey                  = @"objectTwo";
NSString *const objectThirdKey                   = @"objectThree";
NSString *const objectSecondCountKey            = @"objectsecondcount";
NSString *const objectThirdCountKey             = @"objectthirdcount";
NSString *const trainModeKey                    = @"traintype";
NSString *const pickModeKey                     = @"picktype";


NSString *const classKey                        = @"class";
NSString *const classIdKey                       = @"classid";
NSString *const classNameKey                     = @"classname";

NSString *const timeKey                          = @"time";
NSString *const lastTimeKey                     = @"lasttime";
NSString *const numKey                           = @"num";




NSString *const evaluationKey                     = @"message";
NSString *const masterNickNameKey                = @"nickname";
NSString *const contentKey                       = @"content";
NSString *const masterKey                       = @"master";
NSString *const masterIdKey                      = @"masterid";
NSString *const bossKey                         = @"boss";
NSString *const masterNameKey                    = @"mastername";

NSString *const consultIdKey                    = @"cid";
NSString *const evaluationIdKey                 = @"tid";
NSString *const consultCountKey                  = @"consultcount";
NSString *const evaluatingKey                   = @"evaluating";
NSString *const consultKey                       = @"consult";
NSString *const replyKey                        = @"reply";
NSString *const replyCountKey                    = @"replycount";

// message center
NSString *const conMsgCountKey                  = @"consult";
NSString *const evaMsgCountKey                  = @"evaluate";
NSString *const conRepMsgCountKey               = @"replyconsult";
NSString *const evaRepMsgCountKey               = @"replyevaluate";


NSString *const userTypeKey                      = @"type";
NSString *const userTypeCoachKey                  = @"jl";
NSString *const userTypeSchoolKey                 = @"jx";
NSString *const userTypeGuiderKey                 = @"zdy";
NSString *const userTypeStudentKey               = @"xy";

NSString *const coachModeKey                    = @"jltype";    



//培训课程
NSString *const trainBaseNameKey                 = @"trname";
NSString *const coachCountKey                    = @"coachcount";


//搜索
//搜索
NSString *const searchProvinceKey                = @"province";
NSString *const searchCityKey                    = @"city";
NSString *const searchDistrictKey                = @"county";
NSString *const searchAddressKey                 = @"address";
NSString *const searchModeKey                    = @"mode";


NSString *const schoolNameKey               = @"schoolname";
NSString *const schoolIdKey                 = @"schoolid";



//驾考学堂
NSString *const myschoolNameKey             = @"myschool";
NSString *const myCoachNameKey                   = @"mycoach";
NSString *const myGuiderNameKey                  = @"myguider";
NSString *const myschoolIdKey               = @"myschoolid";
NSString *const myCoachIdKey                     = @"mycoachid";
NSString *const myGuiderIdKey                    = @"myguiderid";

NSString *const myReservationNumKey              = @"myreservation";
NSString *const myStudyPregressKey               = @"myspeed";

NSString *const myDriveSchoolNotificationCount   = @"myscnum";
NSString *const myCoachNotificationCount         = @"myconum";
NSString *const myGuiderNotificationCount        = @"mygunum";
NSString *const myReservationNotificationCount   = @"myrenum";
NSString *const myStudyProgressNotificationCount = @"myspnum";

//我的驾校
NSString *const myDriveSchoolInfoKey             = @"school";
NSString *const myDriveSchoolTrainClassKey       = @"class";
NSString *const myDriveSchoolCoachKey            = @"coach";
NSString *const myDriveSchoolTrainClassNameKey   = @"name";

//NSString *const schoolIdKey                      = @"schoolid";
NSString *const coachIdKey                       = @"coachid";

NSString *const indexKey                         = @"index";



//我的教练
NSString *const priceSecondKey                   = @"pricetwo";
NSString *const priceThirdKey                    = @"pricethree";

NSString *const disableTimeKey                   = @"disable";
NSString *const reservationInfoKey               = @"reser";

NSString *const weekdaysKey                      = @"weekdays";
NSString *const timebucketKey                   = @"timebucket";
NSString *const statussKey                      = @"statuss";



//订单
NSString *const orderKey                        = @"list";
NSString *const orderIdKey                       = @"listid";
NSString *const orderTimeKey                     = @"listtime";
NSString *const consigneeKey                     = @"masname";
NSString *const remarkKey                        = @"remark";
NSString *const orderModeKey                     = @"mode";
NSString *const studentCountKey                  = @"stucount";
NSString *const applyModeKey                     = @"applymode";
NSString *const orderPriceKey                    = @"prices";
NSString *const paidNumKey                       = @"total_fee";
NSString *const couponModeKey                    = @"couponmode";
NSString *const orderStateKey                    = @"state";
NSString *const orderNameKey                     = @"listname";
NSString *const orderDetailKey                   = @"description";
NSString *const recipientKey                    = @"coach";
NSString *const recipientNameKey                = @"coachname";
NSString *const startDateKey                    = @"starttime";
NSString *const endDateKey                      = @"endtime";


NSString *const durationKey                      = @"duration";
NSString *const stampKey                         = @"stamp";

NSString *const masNameKey                       = @"masname";
NSString *const evaluationLevelKey               = @"evaluate";

NSString *const flagKey                          = @"flag";



NSString *const feedbackUserIdKey                = @"feedid";


NSString *const dateKey                          = @"date";



//报名咨询
NSString *const guiderIdKey                      = @"guiderid";
NSString *const stuNameKey                       = @"stuname";
NSString *const stuPhoneKey                      = @"stuphone";


//章节练习
NSString *const chapterIdKey                     = @"chapterid";
NSString *const chapterNameKey                   = @"classname";
NSString *const chapterNumKey                    = @"num";
NSString *const chapterProgressKey               = @"speed";
NSString *const questionIdKey                    = @"tid";
NSString *const questionIndexsKey                = @"indexs";
NSString *const addressIdKey                     = @"addressid";

NSString *const questionContentKey               = @"question";
NSString *const questionAnswerKey                = @"answer";
NSString *const questionTypeKey                  = @"classid";
NSString *const questionAnalysisKey              = @"analysis";
NSString *const questionImageUrlKey              = @"imgurl";
NSString *const questionDegreeKey                = @"degree";
NSString *const questionAllTimesKey              = @"times";
NSString *const questionWrongTimesKey            = @"righttimes";
NSString *const questionIndexKey                 = @"index";
NSString *const questionAllCountKey              = @"allcount";

NSString *const questionNextMode                 = @"nextmode";
NSString *const questionCurrentIdKey             = @"start";
NSString *const questionRightOrWrongKey          = @"flag";
NSString *const currentQuestionIdKey             = @"start";

NSString *const myAnwserKey                      = @"myanswer";


NSString *const subjectModeKey                   = @"subjects";
NSString *const chapterAddressKey                = @"address";

NSString *const timeConsumeKey                   = @"usetime";
NSString *const examDateKey                      = @"stime";


NSString *const subjectIdKey                     = @"subjectid";
NSString *const chapterIdKey_collecte            = @"ChapterId";

NSString *const rightDeleteFlag                  = @"del";


//驾考圈

NSString *const newsIdKey                      = @"newsid";
NSString *const newsMasterIdKey                = @"masterid";
NSString *const newsTimeKey                    = @"time";
NSString *const newsContentKey                 = @"content";
NSString *const newsPicCountKey                = @"piccount";;
NSString *const newsPraiseCountKey             = @"praisecount";
NSString *const newsEvalutionCountKey          = @"evalutioncount";
NSString *const newsTransmitCountKey           = @"transmitcount";
NSString *const newsExtrasKey                  = @"extras";
NSString *const newsPraiseFlagKey              = @"flag";

//NSString *const objectingIdKey                = @"objecthingid";

NSString *const praiseInfoKey                    = @"praise";
NSString *const transmitInfoKey                  = @"tran";
NSString *const startKey                         = @"start";





NSString *const censusKey                       = @"address";
NSString *const pickAddressKey                  = @"pickupaddress";
NSString *const trainClassNameKey               = @"trainclass";
NSString *const payInfoKey                      = @"paytype";
NSString *const noteKey                         = @"note";


NSString *const orderCountKey                   = @"listcount";
NSString *const curStudentCountKey              = @"nowstu";
NSString *const curOrderCountKey                = @"monthlist";




NSString *const districtNameKey                 = @"countyname";
NSString *const districtIdKey                   = @"countyid";


//认证
NSString *const coachLicenseIdKey               = @"serialId";
NSString *const driveLicenseIdKey               = @"driverId";
NSString *const identityIdKey                   = @"numberId";
NSString *const businessLicenseIdKey            = @"yyzzId";
//NSString *const fullNameKey                     = @"fullname";





NSString *const AliPayCallback_url               = @"http://192.168.67.163/10.19/php/Home/Driving/alipayCallBack";
NSString *const realmName_517                    = @"https://www.517xc.com";
//NSString *const realmName_517 = @"www.517xc.com";


#pragma mark -all
//获取当前最低支持的应用版本号
NSString *const lowestAppVersion_url             = @"http://192.168.67.163/10.19/php/Home/Index/version";
//登录网址
NSString *const login_url                        = @"http://192.168.67.163/10.19/php/Home/Index/check";
//注册网址
NSString *const register_url                     = @"http://192.168.67.163/10.19/php/Home/Index/adduser";
//退出接口
NSString *const logout_url                       = @"http://192.168.67.163/10.19/php/Home/Index/logout";
//个人信息
NSString *const userInfo_url                     = @"http://192.168.67.163/10.19/php/Home/index/coachUinfo";
//修改个人信息
NSString *const modifyUserInfo_url               = @"http://192.168.67.163/10.19/php/Home/Index/updateuinfo";
//获取用户名称
NSString *const getUserName_url                  = @"http://192.168.67.163/10.19/php/Home/Index/getUserName";

//发送验证码
NSString *const getAuthCode_url                  = @"http://192.168.67.163/10.19/php/Home/Index/sends";
//验证验证码
NSString *const checkAuchCode_url                = @"http://192.168.67.163/10.19/php/Home/Index/verification";
//修改密码
NSString *const modifyPassword_url               = @"http://192.168.67.163/10.19/php/Home/Index/passupdate";
//重设密码
NSString *const resetPassword_url                = @"http://192.168.67.163/10.19/php/Home/Index/passreset";
//添加关注
NSString *const attente_url                 = @"http://192.168.67.163/10.19/php/Home/Index/addmycon";
//取消关注
NSString *const removeAttention_url              = @"http://192.168.67.163/10.19/php/Home/Index/removemycon";
//获取我的关注
NSString *const getMyAttention_url               = @"http://192.168.67.163/10.19/php/Home/Index/myconcern";
//意见反馈
NSString *const feedback_url                     = @"http://192.168.67.163/10.19/php/Home/Index/feedback";
//扫一扫用户验证
NSString *const issetUserId_url                  = @"http://192.168.67.163/10.19/php/Home/Index/userisset";



#pragma mark -All
#pragma mark -message
//msg center
NSString *const msgCenter_url                   = @"http://192.168.67.163/10.19/php/Home/Coach/newmessage";
// eva msg
NSString *const evaMsg_url                      = @"http://192.168.67.163/10.19/php/Home/Coach/evalreplyList";
// reply eva
NSString *const replyEva_url                    = @"http://192.168.67.163/10.19/php/Home/Coach/replyevaluate";
// eva detail
NSString *const evaDetail_url                   = @"http://192.168.67.163/10.19/php/Home/Coach/evaluatdetail";
//consult msg
NSString *const conMsg_url                      = @"http://192.168.67.163/10.19/php/Home/Coach/conreplyList";
//reply
NSString *const replyCon_url                    = @"http://192.168.67.163/10.19/php/Home/Coach/createreply";
//consult detail
NSString *const consultDetail_url               = @"http://192.168.67.163/10.19/php/Home/Coach/consultdetail";


#pragma mark -teacher
//上传认征资料
NSString *const uploadCertification_url         = @"https://www.517xc.com/Admin/Coach/upcertificate1";
//获取所选城市所有基地
NSString *const getAllTrainBase_url             = @"http://192.168.67.163/10.19/php/Home/Driving/returnAlltrain";



#pragma mark -teacher
#pragma mark -学员
//获取学员
NSString *const getStudent_url                  = @"http://192.168.67.163/10.19/php/Home/Coach/returnallstu";
//添加学员
NSString *const addStudent_url                  = @"http://192.168.67.163/10.19/php/Home/Coach/addStudent";
//修改学员信息
NSString *const modifyStudent_url               = @"http://192.168.67.163/10.19/php/Home/Coach/updateStu";
//删除学员
NSString *const deleteStudent_url               = @"http://192.168.67.163/10.19/php/Home/Coach/delStu";


#pragma mark -teacher
#pragma mark -发布
//添加培训课程
NSString *const addTrainClass_url               = @"http://192.168.67.163/10.19/php/Home/Coach/addClass";
//删除培训订程
NSString *const deleteTrainClass_url            = @"http://192.168.67.163/10.19/php/Home/Coach/delClass";
//修改计时培训
NSString *const updateTimeTeachFlag_url         = @"http://192.168.67.163/10.19/php/Home/Coach/uploadTimeflag";
//添加简介（修改简介）
NSString *const updateSynopsis_url              = @"http://192.168.67.163/10.19/php/Home/Coach/uploadProfile";
//添加教学环境（修改，删除）
//添加教学环境
NSString *const updateTeachEnvironmnet_url      = @"http://192.168.67.163/10.19/php/Home/Coach/coachupload";
//删除教学环境
NSString *const deleteTeachEnvironment_url      = @"http://192.168.67.163/10.19/php/Home/Coach/delCoachimg";
//获取培训课程
NSString *const getTrainClass_url               = @"http://192.168.67.163/10.19/php/Home/Coach/returnClass";
//获取简介
NSString *const getSynopsis_url                 = @"http://192.168.67.163/10.19/php/Home/Coach/getAbstract";
//获取教学图片
NSString *const getTeachEnvironment_url         = @"http://192.168.67.163/10.19/php/Home/Coach/getCoachimg";
//获取发布信息
NSString *const getPublishInfo_url              = @"http://192.168.67.163/10.19/php/Home/Coach/getCoachs";
//修改学车成本
//NSString *const updateCost_url                  = @"http://192.168.67.163/10.19/php/Home/Coach/updateCost";
//修改接送范围
NSString *const updatePickRange_url             = @"http://192.168.67.163/10.19/php/Home/Coach/updatePickrange";



#pragma mark -teacher

#pragma mark -teachManage
//获取基地
NSString *const getTrainBase_url                = @"http://192.168.67.163/10.19/php/Home/TeaManage1/returnTrain";

//教学管理主界面
NSString *const teachManage_url                 = @"http://192.168.67.163/10.19/php/Home/TeaManage1/teaManage";
//教练管理
NSString *const coachManage_url                 = @"http://192.168.67.163/10.19/php/Home/TeaManage1/returnMycoach";
//添加教练
NSString *const addCoach_url                    = @"http://192.168.67.163/10.19/php/Home/TeaManage1/addCoach";
//教练详情
NSString *const coachDetail_url                 = @"http://192.168.67.163/10.19/php/Home/TeaManage1/returnCoachinfo";
//修改老师当前驾照
NSString *const modifyTeacherLicense_url        = @"http://192.168.67.163/10.19/php/Home/TeaManage1/updateJtype";
//订时预约
NSString *const timeTeachManage_url             = @"http://192.168.67.163/10.19/php/Home/Driving/reservationInfo";
//根据驾照类型获取价格详情
NSString *const priceDetailByLicense_url        = @"http://192.168.67.163/10.19/php/Home/Driving/queryPriceInfo";
//添加价格详情
NSString *const addPriceDetail_url              = @"http://192.168.67.163/10.19/php/Home/Driving/addPriceInfo";
//修改价格详情
NSString *const modifyPriceDetail_url           = @"http://192.168.67.163/10.19/php/Home/Driving/updatePriceInfo";
//删除价格详情
NSString *const deletePriceDetail_url           = @"http://192.168.67.163/10.19/php/Home/Driving/delPriceInfo";

//修改教练基地
NSString *const modifyCoachTrainBase_url        = @"http://192.168.67.163/10.19/php/Home/TeaManage1/updateCoachTrain";
//删除教练
NSString *const deleteCoach_url                 = @"http://192.168.67.163/10.19/php/Home/TeaManage1/updateMaster";
//基地管理
NSString *const trainBaseManage_url             = @"http://192.168.67.163/10.19/php/Home/TeaManage1/trainManage";
//添加基地
NSString *const addTrainBase_url                = @"http://192.168.67.163/10.19/php/Home/TeaManage1/addTrain";
//删除基地
NSString *const deleteTrainBase_url             = @"http://192.168.67.163/10.19/php/Home/TeaManage1/delTrain";
//操作基地
NSString *const operateTrainBase_url            = @"http://192.168.67.163/10.19/php/Home/TeaManage1/operTrain";
//基地详情
NSString *const trainBaseDetail_url             = @"https://www.517xc.com/Admin/TeaManage1/returnTrainCoach";
//操作基地
NSString *const operateTrainBase_url            = @"https://www.517xc.com/Admin/TeaManage1/operTrain";
//地标管理
NSString *const landMarkManage_url              = @"http://192.168.67.163/10.19/php/Home/TeaManage1/landManage";
//获取某个区的所有地标
NSString *const getDistrictLandMark_url         = @"http://192.168.67.163/10.19/php/Home/TeaManage1/returnLand";
//添加地标
NSString *const addLandMark_url                 = @"http://192.168.67.163/10.19/php/Home/TeaManage1/addLand";
//删除地标
NSString *const deleteLandMark_url              = @"http://192.168.67.163/10.19/php/Home/TeaManage1/delLand";
//操作地标
NSString *const operateLandMark_url             = @"http://192.168.67.163/10.19/php/Home/TeaManage1/operLand";




#pragma mark -student
#pragma mark -teacherAbout
//搜索驾校
NSString *const searchSchool_url                 = @"http://192.168.67.163/10.19/php/Home/Search/search";
//搜索教练
NSString *const searchCoach_url                  = @"http://192.168.67.163/10.19/php/Home/Search/searchCoach";
//搜索指导员
NSString *const searchGuider_url                 = @"http://192.168.67.163/10.19/php/Home/Search/searchGuider";


//获取驾校列表
NSString *const getTeacherList_url               = @"http://192.168.67.163/10.19/php/Home/Coach/getpublicList";
//详情
NSString *const getTeacherDetail_url             = @"http://192.168.67.163/10.19/php/Home/Coach/getTeacherDetail";
//获取附近驾校
NSString *const getNearTeacher_url               = @"http://192.168.67.163/10.19/php/Home/Coach/getCoachadd";
//获取所有评论
NSString *const evaList_url                     = @"https://www.517xc.com/Admin/Coach/allList";
//评价详情
NSString *const evaDetail_url                   = @"https://www.517xc.com/Admin/Coach/evaluatdetail";
//发表提问
NSString *const ask_url                         = @"https://www.517xc.com/Admin/Coach/createconsult";
//获取所有提问
NSString *const conList_url                     = @"https://www.517xc.com/Admin/Coach/allconList";
//提问详情
NSString *const consultDetail_url               = @"https://www.517xc.com/Admin/Coach/consultdetail";




#pragma mark -All
#pragma mark -message
//msg center
NSString *const msgCenter_url                   = @"https://www.517xc.com/Admin/Coach/newmessage";
// eva msg
NSString *const evaMsg_url                      = @"https://www.517xc.com/Admin/Coach/evalreplyList";
// reply eva
NSString *const replyEva_url                    = @"https://www.517xc.com/Admin/Coach/replyevaluate";
// eva detail
//NSString *const evaDetail_url                   = @"https://www.517xc.com/Admin/Coach/evaluatdetail";
//consult msg
NSString *const conMsg_url                      = @"https://www.517xc.com/Admin/Coach/conreplyList";
//reply
NSString *const replyCon_url                    = @"https://www.517xc.com/Admin/Coach/createreply";
//consult detail
//NSString *const consultDetail_url               = @"https://www.517xc.com/Admin/Coach/consultdetail";


//我的钱包
//NSString *const myWallet_url = @"https://www.517xc.com/Index/Admin/Wallet/getMyWallet";


#pragma mark -student
#pragma mark -driveExam
//驾考学堂
NSString *const driveExam_url                    = @"http://192.168.67.163/10.19/php/Home/Driving/dirsch";
//添加
NSString *const addMyTeacher_url                 = @"http://192.168.67.163/10.19/php/Home/Driving/addMyTeacher";
//更换
NSString *const replaceTeacher_url               = @"http://192.168.67.163/10.19/php/Home/Driving/updateTeacher";
//指导员
NSString *const selfCitys_url                    = @"http://192.168.67.163/10.19/php/Home/Driving/selfCity";
//添加时获取所有
NSString *const getTeacher_url                   = @"http://192.168.67.163/10.19/php/Home/Driving/returnAllTeacher";
//我的驾校
NSString *const myDriveShcool_url                = @"http://192.168.67.163/10.19/php/Home/Driving/mydrisch";
//根据驾校基地科目获取教练
NSString *const getTrainCoach_url                = @"http://192.168.67.163/10.19/php/Home/Driving/getMoreCoach";
//我的驾校更多教练
NSString *const getMoreCoach_url                 = @"http://192.168.67.163/10.19/php/Home/Driving/reserCoach";
//我的驾校预约教练
NSString *const reservateCoach_url               = @"http://192.168.67.163/10.19/php/Home/Driving/getCoachInfo";
//我的教练
NSString *const myChoach_url                     = @"http://192.168.67.163/10.19/php/Home/Driving/getCoachInfo";
//创建预约
NSString *const reservate_url                    = @"http://192.168.67.163/10.19/php/Home/Driving/addmyreser";
//我的指导员
NSString *const myGuider_url                     = @"http://192.168.67.163/10.19/php/Home/Driving/getGuiderinfo";

//报名咨询
NSString *const guiderApply_url                  = @"http://192.168.67.163/10.19/php/Home/Driving/guiderList";


#pragma mark -all
#pragma mark -order
//创建订单
NSString *const createOrder_url                  = @"http://192.168.67.163/10.19/php/Home/Driving/mylist";
//订单中心//学员端用
//NSString *const orderCenter_url                  = @"http://192.168.67.163/10.19/php/Home/Driving/listcenter";
//取消订单
NSString *const cancelOrder_url                  = @"http://192.168.67.163/10.19/php/Home/Driving/cancellist";
//删除订单
NSString *const deleteOrder_url                  = @"http://192.168.67.163/10.19/php/Home/Driving/dellist";
//评价订单
NSString *const evaluateOrder_url                = @"http://192.168.67.163/10.19/php/Home/Driving/evaluatlist";
//确认订单
NSString *const confirmOrder_url                 = @"http://192.168.67.163/10.19/php/Home/Driving/confirmlist";
//获取订单支付状态
NSString *const confirmPayState_url              = @"http://192.168.67.163/10.19/php/Home/Driving/returnOrderState";

//订单中心
//订单中心//教练端
NSString *const orderCenter_url                 = @"http://192.168.67.163/10.19/php/Home/Driving/coachListcenter";
//分配订单
NSString *const orderDispatch_url               = @"http://192.168.67.163/10.19/php/Home/Driving/allocateList";
//当前可用教练-分配订单用
NSString *const usefulCoach_url                 = @"https://www.517xc.com/Admin/Driving/reusefulCoach1";



#pragma mark -all
#pragma mark -community
//驾考圈
//发表动态
NSString *const sendNews_url                     = @"http://192.168.67.163/10.19/php/Home/Dynamic/sendDynamic";
//获取我的动态
NSString *const getMyNews_url                    = @"http://192.168.67.163/10.19/php/Home/Dynamic/getMyDynamic";
//获取所有动态
NSString *const getAllNews_url                   = @"http://192.168.67.163/10.19/php/Home/Dynamic/getAllDynamic";
//点赞
NSString *const praise_url                       = @"http://192.168.67.163/10.19/php/Home/Dynamic/thumb";
//取消赞
NSString *const depraise_url                     = @"http://192.168.67.163/10.19/php/Home/Dynamic/cancelthumb";
//评论（动态）
NSString *const statusEvalute_url                = @"http://192.168.67.163/10.19/php/Home/Dynamic/evaluate";
//转发（动态）
NSString *const statusTransmit_url               = @"http://192.168.67.163/10.19/php/Home/Dynamic/forwDynamic";
//动态详情
NSString *const statusDetail_url                 = @"http://192.168.67.163/10.19/php/Home/Dynamic/getNewsDetail";
//更多评价
NSString *const statusMoreEvalution_url          = @"http://192.168.67.163/10.19/php/Home/Dynamic/moreEvaluation";
//与我相关
NSString *const aboutMe_url                      = @"http://192.168.67.163/10.19/php/Home/Dynamic/aboutMe";
//回复
NSString *const communityReply_url               = @"http://192.168.67.163/10.19/php/Home/Dynamic/returnEvaluate";
//删除动态
NSString *const deleteNews_url                   = @"http://192.168.67.163/10.19/php/Home/Dynamic/delDynamic";
//用户详情
NSString *const userDetail_url                   = @"http://192.168.67.163/10.19/php/Home/Dynamic/userDetails";







