//+------------------------------------------------------------------+
//|                                                          abc.mq4 |
//|  Copyright (c) 2010 Area Creators Co., Ltd. All rights reserved. |
//|                                          http://www.mars-fx.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2010 Area Creators Co., Ltd. All rights reserved."
#property link      "http://www.mars-fx.com/"

//+------------------------------------------------------------------+
//| ヘッダーファイル読込                                             |
//+------------------------------------------------------------------+
#include <stderror.mqh>
#include <stdlib.mqh>
#include <WinUser32.mqh>

//+------------------------------------------------------------------+
//| 定数宣言部                                                       |
//+------------------------------------------------------------------+
#define URL "http://www.mars-fx.com/"      //URL
#define ERR_TITLE1 "パラメーターエラー"    //エラータイトル(その1)
#define MAIL_TITLE "MarsFX MailAlert"      //メールタイトル
#define R_SUCCESS         0                //戻り値(成功)
#define R_ERROR          -1                //戻り値(エラー)
#define R_ALERT          -2                //戻り値(警告1)
#define R_WARNING        -3                //戻り値(警告2)
#define BUY_SIGNAL        1                //エントリーシグナル(ロング)
#define SELL_SIGNAL       2                //エントリーシグナル(ショート)
#define BUY_EXIT_SIGNAL   1                //決済シグナル(ロング)
#define SELL_EXIT_SIGNAL  2                //決済シグナル(ショート)
#define ORDER_TYPE_ALL    1                //オーダーセレクトタイプ(全て)
#define ORDER_TYPE_BUY    2                //オーダーセレクトタイプ(ロング)
#define ORDER_TYPE_SELL   3                //オーダーセレクトタイプ(ショート)
#define LAST_ORDER        4                //オーダーセレクトタイプ(直近)
#define LAST_HIS          1                //オーダー履歴(直近)
#define LAST_BUT_ONE_HIS  2                //オーダー履歴(一つ前)

//+------------------------------------------------------------------+
//| 外部パラメーター宣言                                             |
//+------------------------------------------------------------------+
extern int MagicNumber       = 12345678;      //マジックナンバー
extern double Lots           = 0.1;                   //ロット数
extern int Slippage          = 3;                 //スリッページ
extern double TakeProfitPips = 0;         //利食いPips
extern double StopLossPips   = 0;           //損切りPips
extern int OpenOrderMax      = 1;           //最大保有ポジション数
extern double CloseLotsMax   = 0;           //同時決済ポジション数
extern int AutoLotsType      = 0;    //自動ロット算出タイプ(0:なし、1:%指定、2:マーチンゲール、3:逆マーチンゲール)


//エントリー条件2(ショート) Start------------------------------------------------------------------------------------------------------------------------------
//BB
extern int Entry002_BB_Period       = 20;         //期間
extern int Entry002_BB_Deviation    = 2;       //偏差
extern int Entry002_BB_Mode         = 1;            //ライン
extern int Entry002_BB_TimeFrame    = 0;      //時間軸
extern int Entry002_BB_AppliedPrice = 0;   //価格
//エントリー条件2(ショート) End--------------------------------------------------------------------------------------------------------------------------------


//決済条件2(ロング決済) Start------------------------------------------------------------------------------------------------------------------------------
//MA
extern int Exit002_MA_Period       = 14;          //期間
extern int Exit002_MA_Method       = 0;           //算出方式
extern int Exit002_MA_TimeFrame    = 0;       //時間軸
extern int Exit002_MA_AppliedPrice = 0;    //価格
//決済条件2(ロング決済) End--------------------------------------------------------------------------------------------------------------------------------




//+------------------------------------------------------------------+
//| グローバル変数宣言                                               |
//+------------------------------------------------------------------+
string PGName = "abc";     //プログラム名
int RETRY_TIMEOUT    = 60;               //送信待ち時間(秒)
int RETRY_INTERVAL   = 15000;            //リトライインターバル
int PLDigits         = 2;                //損益少数点
double wk_point      = 0;                //3桁、5桁対応Point
double order[1][12];                    //オーダー格納用   
double order_his[1][12];                //オーダー履歴格納用
double exception[1][2];                 //例外オーダー格納用
int OrderCount       = 0;                //オーダー総数
bool MailFlag        = false;            //メールお知らせ機能(true:有効、false:無効)
bool AlertFlag       = false;            //アラートお知らせ機能(true:有効、false:無効)

//+------------------------------------------------------------------+
//| 初期処理                                                         |
//+------------------------------------------------------------------+
int init()
{

   //debug
   Alert("[", __FILE__, ":",__LINE__,"] init... ", PGName);
/*
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] Digits => '", Digits, "'");
   Alert("[", __FILE__, ":",__LINE__,"] OBJ_LABEL => '", OBJ_LABEL, "'");
   Alert("[", __FILE__, ":",__LINE__,"] WindowOnDropped() => '", WindowOnDropped(), "'");
   Alert("[", __FILE__, ":",__LINE__,"] ObjectFind(\"PGName\") => '", ObjectFind("PGName"), "'");
  */ 
   
   return(0);
}

//+------------------------------------------------------------------+
//| 終了処理                                                         |
//+------------------------------------------------------------------+
int deinit()
{
   //オブジェクトの削除
   ObjectDelete("PGName");
   
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] deinit... ", PGName);
   Alert("[", __FILE__, ":",__LINE__,"] WindowOnDropped() => '", WindowOnDropped(), "'");
   
   return(0);
}

//+------------------------------------------------------------------+
//| メイン処理                                                       |
//+------------------------------------------------------------------+
int start()
{

   //変数宣言
   bool result_flag       = false;                            //処理結果格納用
   int result_code        = R_ERROR;                          //処理結果格納用

   int err_code           = 0;                                //エラーコード取得用
   string err_title       = "[オブジェクト生成エラー] ";      //エラーメッセージタイトル
   string err_title02     = "[例外エラー] ";                  //エラーメッセージタイトル02

   int order_count        = R_ERROR;                          //ポジション検索結果
   int order_his_count    = 0;                                //履歴ポジション数

   //ラベルオブジェクト生成(PGName)
   if(ObjectFind("PGName")!=WindowOnDropped())
   {
      result_flag = ObjectCreate("PGName",OBJ_LABEL,WindowOnDropped(),0,0);
      if(result_flag == false)          
      {
         err_code = GetLastError();
         Print(err_title,err_code, " ", ErrorDescription(err_code));
      }
      else
        {
            //debug
            Alert("[", __FILE__, ":",__LINE__,"] ObjectCreate() => true"
            
            );         
        }
   }
   else
     {
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] ObjectFind != WindowOnDropped()"
         
            , " (ObjectFind() = ", ObjectFind("PGName")
            , " / WindowOnDropped() = ", WindowOnDropped()
         
         );
      
     }
   ObjectSet("PGName",OBJPROP_CORNER,3);              //アンカー設定
   ObjectSet("PGName",OBJPROP_XDISTANCE,3);           //横位置設定
   ObjectSet("PGName",OBJPROP_YDISTANCE,5);           //縦位置設定
   ObjectSetText("PGName",PGName,8,"Arial",Gray);     //テキスト設定

   // order init

   //debug
   Alert("[", __FILE__, ":",__LINE__,"] "
   
      , "order[0][0] => '", order[0][0], "'"
   
   );

   ArrayInitialize(order,3);
   //ArrayInitialize(order,0);
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] "
   
      , "now, order[0][0] => '", order[0][0], "'"
   
   );
   
   // order check
   //order_count = OrderCheck(order,MagicNumber,ORDER_TYPE_ALL);
   
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] order_count => ", order_count);

   return(0);
}

//+------------------------------------------------------------------+