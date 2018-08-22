//+------------------------------------------------------------------+
//|                                                          abc.mq4 |
//|  Copyright (c) 2010 Area Creators Co., Ltd. All rights reserved. |
//|                                          http://www.mars-fx.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2010 Area Creators Co., Ltd. All rights reserved."
#property link      "http://www.mars-fx.com/"

//+------------------------------------------------------------------+
//|                                              |
//+------------------------------------------------------------------+
#include <stderror.mqh>
#include <stdlib.mqh>
#include <WinUser32.mqh>

//+------------------------------------------------------------------+
//|  : original                                             |
//+------------------------------------------------------------------+
#include <utils.mqh>

//+------------------------------------------------------------------+
//|                                                        |
//+------------------------------------------------------------------+
#define URL "http://www.mars-fx.com/"      //URL
#define ERR_TITLE1 ""    //(1)
#define MAIL_TITLE "MarsFX MailAlert"      //
#define R_SUCCESS         0                //()
#define R_ERROR          -1                //()
#define R_ALERT          -2                //(1)
#define R_WARNING        -3                //(2)
#define BUY_SIGNAL        1                //()
#define SELL_SIGNAL       2                //()
#define BUY_EXIT_SIGNAL   1                //()
#define SELL_EXIT_SIGNAL  2                //()
#define ORDER_TYPE_ALL    1                //()
#define ORDER_TYPE_BUY    2                //()
#define ORDER_TYPE_SELL   3                //()
#define LAST_ORDER        4                //()
#define LAST_HIS          1                //()
#define LAST_BUT_ONE_HIS  2                //()

//+------------------------------------------------------------------+
//|                                              |
//+------------------------------------------------------------------+
extern int MagicNumber       = 12345678;      //
extern double Lots           = 0.1;                   //
extern int Slippage          = 3;                 //
extern double TakeProfitPips = 0;         //Pips
extern double StopLossPips   = 0;           //Pips
extern int OpenOrderMax      = 1;           //
extern double CloseLotsMax   = 0;           //
extern int AutoLotsType      = 0;    //(0:1:2:3:)


//2() Start------------------------------------------------------------------------------------------------------------------------------
//BB
extern int Entry002_BB_Period       = 20;         //
extern int Entry002_BB_Deviation    = 2;       //
extern int Entry002_BB_Mode         = 1;            //
extern int Entry002_BB_TimeFrame    = 0;      //
extern int Entry002_BB_AppliedPrice = 0;   //
//2() End--------------------------------------------------------------------------------------------------------------------------------


//2() Start------------------------------------------------------------------------------------------------------------------------------
//MA
extern int Exit002_MA_Period       = 14;          //
extern int Exit002_MA_Method       = 0;           //
extern int Exit002_MA_TimeFrame    = 0;       //
extern int Exit002_MA_AppliedPrice = 0;    //
//2() End--------------------------------------------------------------------------------------------------------------------------------

//vars from : fxeabuilder.mq4 Start------------------------------------------------------------------------------------------------------------------------------
double RealPoint;
//string Currency = "USDJPY";
string Currency = "EURJPY";
int ShortTicket;
//vars from : fxeabuilder.mq4 End--------------------------------------------------------------------------------------------------------------------------------

//vars from : fxeabuilder.mq4 Start------------------------------------------------------------------------------------------------------------------------------
//string dpath_Log = "C:\\Users\\iwabuchiken\\AppData\\Roaming\\MetaQuotes\\Terminal\\34B08C83A5AAE27A4079DE708E60511E\\MQL4\\Logs";
string dpath_Log = "Logs";
//C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Logs
string fname_Log = "dev.log";
//vars from : fxeabuilder.mq4 End--------------------------------------------------------------------------------------------------------------------------------


//+------------------------------------------------------------------+
//|                                                |
//+------------------------------------------------------------------+
string PGName = "abc";     //
int RETRY_TIMEOUT    = 60;               //()
int RETRY_INTERVAL   = 15000;            //
int PLDigits         = 2;                //
double wk_point      = 0;                //35Point
double order[1][12];                    //   
double order_his[1][12];                //
double exception[1][2];                 //
int OrderCount       = 0;                //
bool MailFlag        = false;            //(true:false:)
bool AlertFlag       = false;            //(true:false:)

/*
//+------------------------------------------------------------------+
//| prototypes                                                     |
//+------------------------------------------------------------------+
void _inspections(void);
*/
//+------------------------------------------------------------------+
//|                                                          |
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
  
  // inspections
  _inspections();
  
  // real points
  //RealPoint = RealPipPoint(Symbol());
  RealPoint = RealPipPoint();
  
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] RealPoint => ", RealPoint);
  
   
   return(0);
}

//+------------------------------------------------------------------+
//|                                                          |
//+------------------------------------------------------------------+
int deinit()
{
   //
   ObjectDelete("PGName");
   
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] deinit... ", PGName);
   Alert("[", __FILE__, ":",__LINE__,"] WindowOnDropped() => '", WindowOnDropped(), "'");
   
   return(0);
}

//+------------------------------------------------------------------+
//|                                                        |
//+------------------------------------------------------------------+
int start()
{

   //
   bool result_flag       = false;                            //
   int result_code        = R_ERROR;                          //

   int err_code           = 0;                                //
   string err_title       = "[] ";      //
   string err_title02     = "[] ";                  //02

   int order_count        = R_ERROR;                          //
   int order_his_count    = 0;                                //

   //(PGName)
   if(ObjectFind("PGName") == WindowOnDropped())
   //if(ObjectFind("PGName")=WindowOnDropped())
   {
      result_flag = ObjectCreate("PGName",OBJ_LABEL,WindowOnDropped(),0,0);
      if(result_flag == false)          
      {
         err_code = GetLastError();
         Print(err_title,err_code, " ", ErrorDescription(err_code));
      }
      else
        {
/*
            //debug
            Alert("[", __FILE__, ":",__LINE__,"] ObjectCreate() => true"
            
            );         
*/
        }
   }
   else
     {
/*
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] ObjectFind = WindowOnDropped()"
         
            , " (ObjectFind() = ", ObjectFind("PGName")
            , " / WindowOnDropped() = ", WindowOnDropped()
         
         );
*/      
     }
   ObjectSet("PGName",OBJPROP_CORNER,3);              //
   ObjectSet("PGName",OBJPROP_XDISTANCE,3);           //
   ObjectSet("PGName",OBJPROP_YDISTANCE,5);           //
   ObjectSetText("PGName",PGName,8,"Arial",Gray);     //

   // order init

/*
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] "
   
      , "order[0][0] => '", order[0][0], "'"
   
   );
*/
   ArrayInitialize(order,3);
   //ArrayInitialize(order,0);
/*
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] "
   
      , "now, order[0][0] => '", order[0][0], "'"
   
   );
  */ 
   // order check
   //order_count = OrderCheck(order,MagicNumber,ORDER_TYPE_ALL);
/*   
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] order_count => ", order_count);
*/
   return(0);
}

//+------------------------------------------------------------------+
//| _inspections__ShowSpread_Multiple_Currencies()                                                         |
//+------------------------------------------------------------------+
void _inspections__ShowSpread_Multiple_Currencies() {
   
   // log
   // log text
   string txt = "_inspections__ShowSpread_Multiple_Currencies ============";
   
   // debug
   write_Log(
   dpath_Log
   , fname_Log
   , __FILE__
   , __LINE__
   , txt);
   //, name);

   
   string currency_Names[] = {
   
      "USDJPY"
      , "EURJPY"
      , "AUDJPY"
      , "EURUSD"
   
   };
   
   int lenOf_Currency_Names = sizeof(currency_Names) / sizeof(currency_Names[0]);
   
   // iteration
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] lenOf_Currency_Names => ", lenOf_Currency_Names);

   for(int i=0; i < lenOf_Currency_Names; i++)
     {
         string name = currency_Names[i];
         
         double Calc_MODE_SPREAD = MarketInfo(name, MODE_SPREAD);
          
          //debug
          Alert("[", __FILE__, ":",__LINE__,"] Calc_MODE_SPREAD => ", Calc_MODE_SPREAD
   
            , " ("
            , "Currency = ", name
            , ")"
          );
          
          // log text
          //txt = name + " => " + (string)Calc_MODE_SPREAD;
          txt = name + " => " + DoubleToStr(Calc_MODE_SPREAD, 1);
          
          // debug
          write_Log(
            dpath_Log
            , fname_Log
            , __FILE__
            , __LINE__
            , txt);
            //, name);
          
          //debug
          Alert("[", __FILE__, ":",__LINE__,"] write_Log => done");
          
     }
/*
   double Calc_MODE_SPREAD = MarketInfo(Currency, MODE_SPREAD);
   
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] Calc_MODE_SPREAD => ", Calc_MODE_SPREAD
   
      , " ("
      , "Currency = ", Currency
      , ")"
*/

}//void _inspections__ShowSpread_Multiple_Currencies()

//+------------------------------------------------------------------+
//| _inspections()                                                         |
//+------------------------------------------------------------------+
void _inspections() {
   
   //+------------------------------------------------------------------+
   //| MarketInfo()                                                         |
   //+------------------------------------------------------------------+
   //+-----------------------------+
   //| MODE_DIGITS                |
   //+-----------------------------+
   //string Currency = "USDJPY";
   
   double CalcDigits = MarketInfo(Currency, MODE_DIGITS);
   
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] Currency => ", Currency
   
      , " / "
      , "MODE_DIGITS => ", MODE_DIGITS
      , " / "
      , "MarketInfo => ", CalcDigits
   );

   //+-----------------------------+
   //| MODE_SPREAD                |
   //+-----------------------------+
   _inspections__ShowSpread_Multiple_Currencies();
/*
   double Calc_MODE_SPREAD = MarketInfo(Currency, MODE_SPREAD);
   
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] Calc_MODE_SPREAD => ", Calc_MODE_SPREAD
   
      , " ("
      , "Currency = ", Currency
      , ")"
   
   );
*/


   //+------------------------------------------------------------------+
   //| The predefined Variables                                                         |
   //    https://docs.mql4.com/predefined
   //+------------------------------------------------------------------+
   int numOf_Close = sizeof(Close) / sizeof(Close[0]);
   
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] numOf_Close => ", numOf_Close
   
   
   );

   //debug
   Alert("[", __FILE__, ":",__LINE__,"] Bars => ", Bars
   
   
   );
   
   //+------------------------------------------------------------------+
   //| functions                                                         |
   //+------------------------------------------------------------------+
   bool result = OrderSelect(ShortTicket,SELECT_BY_TICKET);
   
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] OrderSelect => ", result
   
         , " / "
         , "SELECT_BY_TICKET => ", SELECT_BY_TICKET
         , " / "
         , "ShortTicket => ", ShortTicket
   
   );
   
   
   
   
}//_inspections()

// Pip Point Function
//double RealPipPoint(string Currency)
double RealPipPoint()
	{
		double CalcDigits = MarketInfo(Currency,MODE_DIGITS);
		
		double CalcPoint = -1.0;
		
		//if(CalcDigits == 2 || CalcDigits == 3) double CalcPoint = 0.01;
		if(CalcDigits == 2 || CalcDigits == 3) CalcPoint = 0.01;
		
		else if(CalcDigits == 4 || CalcDigits == 5) CalcPoint = 0.0001;
		
		return(CalcPoint);
		
	}



//+------------------------------------------------------------------+