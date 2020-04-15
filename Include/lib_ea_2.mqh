//+------------------------------------------------------------------+
//| C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Include\
//    lib_ea_2.mqh
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
#include <utils.mqh>
//#include <lib_ea_2.mqh>
#include <libfx/libfx_dp_1.mqh>

//extern int NUMOF_TARGET_BARS;

//extern string dpath_Log;

/***************************
   <list of funcs located in external files>
   2019/12/19 12:57:03
   
   dp_Trend_Down_1   libfx_dp_1.mqh

*****************/

/*---------------------
   vars
---------------------*/
bool SWITHCH_DEBUG_lib_ea_2   = true;

string   txt;
bool     res;

/*---------------------

   bool judge_1()
   
   at : 2019/08/26 13:36:27

---------------------*/
//bool judge_1() {
bool judge_1(string typeOf_Pattern_s) {

//_20190826_133747:caller
//_20190826_133801:head
//_20190826_133815:wl

   /*******************
      step : 1
         prep : vars
   *******************/
   bool  valOf_Judge = false;
   
   /*******************
      step : 2
         judge
   *******************/
   if(typeOf_Pattern_s == typeOf_Pattern_DP_TREND_DOWN_1)
     {
         /*******************
            step : 2 : 1
               judge : typeOf_Pattern_DP_TREND_DOWN_1
         *******************/
         /*******************
            step : 2 : 1.1
               log
         *******************/
         //debug
         txt = "(step : 2 : 1.1) judge : typeOf_Pattern_DP_TREND_DOWN_1";

         write_Log(dpath_Log, fname_Log_For_Session
               , __FILE__, __LINE__, txt);

         /*******************
            step : 2 : 1.2
               set : val
         *******************/
         //valOf_Judge = true;
         //_20191219_130232:caller
         valOf_Judge = dp_Trend_Down_1();

         //debug
         txt = "(step : 2 : 1.2) judge : dp_Trend_Down_1 => "
               + (string) valOf_Judge
               + ")"
               ;

         write_Log(dpath_Log, fname_Log_For_Session
               , __FILE__, __LINE__, txt);
         
         
     }//if(typeOf_Pattern_s == typeOf_Pattern_DP_TREND_DOWN_1)
   else
     {
         /*******************
            step : 2 : X
               judge : unknown pattern type
         *******************/
         /*******************
            step : 2 : X.1
               log
         *******************/
         //debug
         txt = "(step : 2 : X.1) judge : unknown pattern type";

         write_Log(dpath_Log, fname_Log_For_Session
               , __FILE__, __LINE__, txt);

         /*******************
            step : 2 : 1.2
               set : val
         *******************/
         valOf_Judge = false;
      
     }//if(typeOf_Pattern_s == typeOf_Pattern_DP_TREND_DOWN_1)  
   
   /*******************
      step : X
         return
   *******************/
   //return true;
   return valOf_Judge;

}// judge_1()

/*---------------------

   int take_Position__Buy()
   
   at : 2019/08/27 13:14:21

https://docs.mql4.com/trading/ordersend

int  OrderSend(
   string   symbol,              // symbol      1
   int      cmd,                 // operation   2

   double   volume,              // volume      3
   double   price,               // price       4

   int      slippage,            // slippage    5
   double   stoploss,            // stop loss   6
   double   takeprofit,          // take profit 7

   string   comment=NULL,        // comment     8

   int      magic=0,             // magic number   9

   datetime expiration=0,        // pending order expiration   10
   color    arrow_color=clrNONE  // color                      11

   );
   
---------------------*/
//func
//int take_Position__Buy() {
int take_Position__Buy(double _minstoplevel, double _mintakelevel) {

//_20190827_131828:caller
//_20190827_131835:head
//_20190827_131838:wl

   /*******************
      step : 1
         prep : vars
   *******************/
   //ref https://docs.mql4.com/trading/ordersend
   double price=Ask;
   
   //double minstoplevel=MarketInfo(Symbol(),MODE_STOPLEVEL);
   double minstoplevel     = _minstoplevel;
   //double minstoplevel     = 4.0;
   //double mintakelevel     = 8.0;
   double mintakelevel     = _mintakelevel;
   //double mintakelevel     = 8.0;
   
   double stoploss=NormalizeDouble(Bid - minstoplevel, Digits);
   //double stoploss=NormalizeDouble(Bid-minstoplevel*Point,Digits);
   
   //double takeprofit=NormalizeDouble(Bid+minstoplevel*Point,Digits);
   //double takeprofit    = NormalizeDouble(Bid + mintakelevel * Point, Digits);
   //double takeprofit    = NormalizeDouble(Bid + (Ask - Bid) + mintakelevel * Point, Digits);
   double takeprofit    = NormalizeDouble(Bid + mintakelevel, Digits);
   
   //debug
   if(SWITHCH_DEBUG_lib_ea_2 == true)
     {

         txt = "(step : 1) vars";
         txt += "\n";
         
         
         txt += "price\t" + (string) price;
         txt += "\n";
                       
         txt += "Ask\t" + (string) NormalizeDouble(Ask, Digits);
         txt += "\n";
                       
         txt += "Bid\t" + (string) NormalizeDouble(Bid, Digits);
         txt += "\n";
                       
         txt += "(Ask - Bid)\t" + (string) NormalizeDouble((Ask - Bid), Digits);
         //NormalizeDouble(Bid + (Ask - Bid) + mintakelevel * Point, Digits)
         txt += "\n";
                       
         txt += "Point\t" + (string) NormalizeDouble(Point, Digits);
         txt += "\n";
                       
         txt += "Digits\t" + (string) Digits;
         txt += "\n";
         
                  //price	117.358
                  //Point	0.001
                  //Digits	3         

         txt += "minstoplevel\t" + (string) NormalizeDouble(minstoplevel, Digits);
         txt += "\n";
           
         txt += "mintakelevel\t" + (string) NormalizeDouble(mintakelevel, Digits);
         txt += "\n";
           
         txt += "stoploss\t" + (string) NormalizeDouble(stoploss, Digits);
         txt += "\n";
           
         txt += "takeprofit\t" + (string) NormalizeDouble(takeprofit, Digits);
         txt += "\n";
         
         write_Log(
            dpath_Log
            , fname_Log_For_Session
            
            , __FILE__, __LINE__
            
            , txt);
      
     }   
   
   
   /*******************
      step : 2
         buy
   *******************/
   int ticket=OrderSend(
                  Symbol()
                  ,OP_BUY
                  
                  ,1
                  ,price
                  ,3          // slippage             5
                  
                  ,stoploss
                  ,takeprofit
                  
                  ,"My order"
                  ,16384
                  
                  ,0          // pending order expiration   10
                  ,clrGreen
                  );

   if(ticket<0)
     {
      Print("OrderSend failed with error #",GetLastError());

      txt = "OrderSend failed with error #" + (string) GetLastError();
      txt += "\n";
      
      write_Log(
         dpath_Log
         , fname_Log_For_Session
         
         , __FILE__, __LINE__
         
         , txt);
      
     }
   else {
         
         Print("OrderSend placed successfully");
         
         txt = "OrderSend placed successfully : " + (string) ticket;
         txt += "\n";
         
         write_Log(
            dpath_Log
            , fname_Log_For_Session
            
            , __FILE__, __LINE__
            
            , txt);
         
         //_20200414_160033:next
         //_20190829_110834:tmp
         // log : data
         // ticket num, ask, bid, minstoplevel, mintakelevel, stoploss, takeprofit
         txt = "\t"
               + (string) ticket
               + "\t"
               + (string) NormalizeDouble(Ask, Digits)
               + "\t"
               + (string) NormalizeDouble(Bid, Digits)
               + "\t"
               
               + (string) NormalizeDouble(minstoplevel, Digits)
               + "\t"
               
               + (string) NormalizeDouble(mintakelevel, Digits)
               + "\t"

               + (string) NormalizeDouble(stoploss, Digits)
               + "\t"

               + (string) NormalizeDouble(takeprofit, Digits)
                              + "\t"

               ;
               
         write_Log(
            dpath_Log
            , fname_Log_DAT_For_Session
            
            , __FILE__, __LINE__
            
            , txt);            
         
   //---
     }
     
   /*******************
      step : X
         return
   *******************/
   int ret = ticket;
   //int ret = -1;
   
   return ret;
   

}//take_Position__Buy() //func


/*---------------------

   int take_Position__Sell()
   
   at : 2019/08/27 13:14:21

https://docs.mql4.com/trading/ordersend

int  OrderSend(
   string   symbol,              // symbol      1
   int      cmd,                 // operation   2

   double   volume,              // volume      3
   double   price,               // price       4

   int      slippage,            // slippage    5
   double   stoploss,            // stop loss   6
   double   takeprofit,          // take profit 7

   string   comment=NULL,        // comment     8

   int      magic=0,             // magic number   9

   datetime expiration=0,        // pending order expiration   10
   color    arrow_color=clrNONE  // color                      11

   );
   
---------------------*/
//func
//int take_Position__Sell() {
int take_Position__Sell(double _minstoplevel, double _mintakelevel) {

//_20190827_131828:caller
//_20190827_131835:head
//_20190827_131838:wl

   /*******************
      step : 1
         prep : vars
   *******************/
   //ref https://docs.mql4.com/trading/ordersend
   //double price=Ask;
   //double price= Bid; 
   double price_Order = Bid; // selling price (the fx operator sells to you at this price)
                     // (https://www.uedaharlowfx.jp/dictionary/アスク（ask）.html, http://fx-hitobashira.com/fx人柱さんのfx奮闘記/分かりやすい！fx用語解説/アスク（ask）とは？.html)
                     // Bid ==> buying price (the fx operator buys from you at this price)
                     // Ask > Bid
   //double minstoplevel=MarketInfo(Symbol(),MODE_STOPLEVEL);
   double minstoplevel     = _minstoplevel;
   //double minstoplevel     = 4.0;
   //double mintakelevel     = 8.0;
   double mintakelevel     = _mintakelevel;
   //double mintakelevel     = 8.0;
   
   //double stoploss = NormalizeDouble( Bid - minstoplevel * Point, Digits);
   double stoploss = NormalizeDouble( Ask + minstoplevel * Point, Digits);
   
   //double takeprofit=NormalizeDouble(Bid+minstoplevel*Point,Digits);
   //double takeprofit    = NormalizeDouble(Bid + mintakelevel * Point, Digits);
   //double takeprofit    = NormalizeDouble(Bid + (Ask - Bid) + mintakelevel * Point, Digits);
   //double takeprofit    = NormalizeDouble(Bid + mintakelevel * Point, Digits);
   double takeprofit    = NormalizeDouble(Ask - mintakelevel * Point, Digits);
   
   //debug
   if(SWITHCH_DEBUG_lib_ea_2 == true)
     {

         txt = "(step : 1) vars";
         txt += "\n";
         
         
         //txt += "price\t" + (string) price;
         txt += "price\t" + (string) price_Order;
         txt += "\n";
                       
         txt += "Ask\t" + (string) NormalizeDouble(Ask, Digits);
         txt += "\n";
                       
         txt += "Bid\t" + (string) NormalizeDouble(Bid, Digits);
         txt += "\n";
                       
         txt += "(Ask - Bid)\t" + (string) NormalizeDouble((Ask - Bid), Digits);
         //NormalizeDouble(Bid + (Ask - Bid) + mintakelevel * Point, Digits)
         txt += "\n";
                       
         txt += "Point\t" + (string) NormalizeDouble(Point, Digits);
         txt += "\n";
                       
         txt += "Digits\t" + (string) Digits;
         txt += "\n";
         
                  //price	117.358
                  //Point	0.001
                  //Digits	3         

         txt += "minstoplevel\t" + (string) NormalizeDouble(minstoplevel, Digits);
         txt += "\n";
           
         txt += "mintakelevel\t" + (string) NormalizeDouble(mintakelevel, Digits);
         txt += "\n";
           
         txt += "stoploss\t" + (string) NormalizeDouble(stoploss, Digits);
         txt += "\n";
           
         txt += "takeprofit\t" + (string) NormalizeDouble(takeprofit, Digits);
         txt += "\n";
         
         write_Log(
            dpath_Log
            , fname_Log_For_Session
            
            , __FILE__, __LINE__
            
            , txt);
      
     }   
   
   
   /*******************
      step : 2
         buy
   *******************/
   //_20191217_124004:tmp
/*
   string   symbol,              // symbol      1
   int      cmd,                 // operation   2

   double   volume,              // volume      3
   double   price,               // price       4

   int      slippage,            // slippage    5
   double   stoploss,            // stop loss   6
   double   takeprofit,          // take profit 7

   string   comment=NULL,        // comment     8

   int      magic=0,             // magic number   9

   datetime expiration=0,        // pending order expiration   10
   color    arrow_color=clrNONE  // color                      11   
*/
   int ticket=OrderSend(
                  Symbol()
                  //,OP_BUY
                  , OP_SELL
                  , 1
                  //,price
                  , price_Order
                  , 3          // slippage             5
                  
                  , stoploss
                  , takeprofit
                  
                  , "My order"
                  , 16384
                  
                  , 0          // pending order expiration   10
                  ,clrGreen
                  );

   if(ticket<0)
     {
      Print("OrderSend failed with error #",GetLastError());

      txt = "OrderSend failed with error #" + (string) GetLastError();
      txt += "\n";
      
      write_Log(
         dpath_Log
         , fname_Log_For_Session
         
         , __FILE__, __LINE__
         
         , txt);
      
     }
   else {
         
         Print("OrderSend placed successfully");
         
         txt = "OrderSend placed successfully : " + (string) ticket;
         txt += "\n";
         
         write_Log(
            dpath_Log
            , fname_Log_For_Session
            
            , __FILE__, __LINE__
            
            , txt);
         
         
         //_20190829_110834:tmp
         // log : data
         // ticket num, ask, bid, minstoplevel, mintakelevel, stoploss, takeprofit
         txt = "\t"
               + (string) ticket
               + "\t"
               + (string) NormalizeDouble(Ask, Digits)
               + "\t"
               + (string) NormalizeDouble(Bid, Digits)
               + "\t"
               
               + (string) NormalizeDouble(minstoplevel, Digits)
               + "\t"
               
               + (string) NormalizeDouble(mintakelevel, Digits)
               + "\t"

               + (string) NormalizeDouble(stoploss, Digits)
               + "\t"

               + (string) NormalizeDouble(takeprofit, Digits)
                              + "\t"

               ;
               
         write_Log(
            dpath_Log
            , fname_Log_DAT_For_Session
            
            , __FILE__, __LINE__
            
            , txt);            
         
   //---
     }
     
   /*******************
      step : X
         return
   *******************/
   int ret = ticket;
   //int ret = -1;
   
   return ret;
   

}//take_Position__Sell() //func

/*---------------------

   is_Order_Fully_Pending
   
   at : 2019/12/18 16:32:08
   
   @return
      -1    order not pending
   
---------------------*/
//func
bool is_Order_Fully_Pending(int _maxOf_NumOf_Pending_Orders) {
//_20200413_214410:head
//_20200413_214415:caller

   /*******************
      step : 0
         prep : vars
   *******************/
   bool valOf_Ret;
   
   /*******************
      step : 1
         count : orders
   *******************/
   int cntOf_Orders = OrdersTotal();

   /*******************
      step : j1
         num of orders --> more than the target num ?
   *******************/
   if(cntOf_Orders > _maxOf_NumOf_Pending_Orders)
     {
         /*******************
            step : j1 : Y
               num of orders --> more than the target num
         *******************/
         /*******************
            step : j1 : Y : 1
               log
         *******************/
         /*******************
            step : j1 : Y : 2
               set : return val
         *******************/
         // return
         valOf_Ret = true;
         
     }
   else//if(cntOf_Orders > 0)   
     {
         /*******************
            step : j1 : N
               num of orders --> LESS than the target num ?
         *******************/
         /*******************
            step : j1 : N : 1
               log
         *******************/
         /*******************
            step : j1 : N : 2
               set : return val
         *******************/
         // return
         valOf_Ret = false;
            
     }//if(cntOf_Orders > 0)


   /*******************
      step : X
         return
   *******************/
   return(valOf_Ret);

}//bool is_Order_Fully_Pending(int _maxOf_NumOf_Pending_Orders) {


/*---------------------

   int is_Order_Pending()
   
   at : 2019/12/18 16:32:08
   
   @return
      -1    order not pending
   
---------------------*/
//func
int is_Order_Pending() {
//_20191218_163345:head
//_20191218_163351:caller

   /*******************
      step : 0
         prep : vars
   *******************/
   int valOf_No_Pending = -1;
   
   /*******************
      step : 1
         count : orders
   *******************/
   int cntOf_Orders = OrdersTotal();

   /*******************
      step : j1
         orders --> pending ?
   *******************/
   if(cntOf_Orders > 0)
     {
         /*******************
            step : j1 : Y
               orders --> pending
         *******************/
         /*******************
            step : j1 : Y : 1
               log
         *******************/
         /*******************
            step : j1 : Y : 2
               return
         *******************/
         // return
         return(cntOf_Orders);
      
     }
   else//if(cntOf_Orders > 0)   
     {
         /*******************
            step : j1 : N
               orders --> pending
         *******************/
         /*******************
            step : j1 : N : 1
               log
         *******************/
         /*******************
            step : j1 : N : 2
               return
         *******************/
         // return
         return(valOf_No_Pending);
   
     }//if(cntOf_Orders > 0)
   
}//int is_Order_Pending() {

/*---------------------
   int get_BB_Loc_Num(int index)
   
   at : 2020/04/15 10:32:33
   
   @return
      int num_BB_Area   ==> location number in BB
   
---------------------*/
//func
int get_BB_Loc_Num(int index) {
//_20200415_103130:head
//_20200415_103134:caller

   /*******************
      step : 1
         price : close
   *******************/
   /*******************
      step : 1.1
         obtain
   *******************/
   double price_Close = Close[index];
   double price_Open  = Open[index];
   
   // log
   string txt_Lib_ea_2 = "[" + __FILE__ + ":" + (string) __LINE__ + "] get_BB_Loc_Num"   
                + "\n"
                + "price_Close\t" + (string) price_Close
                + "\n"
                + "price_Open\t" + (string) price_Open
                + "\n"
                 ;
   
   
   /*******************
      step : 2
         BB prices
   *******************/
   float BB_Prices[5];
   float BB_Price;
   
   int idxOf_BB_Prices = 0;
   
   string   BB_Labels[5] = {"2S", "1S", "main", "M1S", "M2S"};
   
   /*******************
      step : 2.1
         BB : 2S
   *******************/   
   //int index = 0;
   int deviation = 2; int   period_BB = 20;
   int bb_Mode = MODE_UPPER; int price_Applied = PRICE_CLOSE;
   
   //float BB_2S = (float) iBands(Symbol(), Period(), period_BB
   //ref C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Experts\labs\44_5.1\ea-1_up-up-buy.mq4
   BB_Price = (float) iBands(Symbol(), Period(), period_BB
               , deviation    //deviation ref https:docs.mql4.com/constants/indicatorconstants/lines
               , 0, price_Applied, bb_Mode    //mode
               , index);   
   
   // append
   BB_Prices[idxOf_BB_Prices]   = BB_Price;
          
   /*******************
      step : 2.1
         BB : 1S
   *******************/   
   //index = 0;
   deviation = 1;
   period_BB = 20;
   bb_Mode = MODE_UPPER;
   price_Applied = PRICE_CLOSE;

   BB_Price = (float) iBands(Symbol(), Period(), period_BB
               , deviation    //deviation ref https:docs.mql4.com/constants/indicatorconstants/lines
               , 0, price_Applied, bb_Mode    //mode
               , index);   
   
   // append
   idxOf_BB_Prices += 1;
   
   BB_Prices[idxOf_BB_Prices]   = BB_Price;
   
/*   float BB_1S = (float) iBands(
               Symbol(), Period()
               , period_BB
               , deviation    //deviation ref https:docs.mql4.com/constants/indicatorconstants/lines
               , 0
               , price_Applied
               , bb_Mode    //mode
               , index);   
*/ 

   /*******************
      step : 2.3
         BB : main
   *******************/   
   //index = 0;
   deviation = 1;
   period_BB = 20;
   bb_Mode = MODE_MAIN;
   price_Applied = PRICE_CLOSE;

   BB_Price = (float) iBands(Symbol(), Period(), period_BB
               , deviation    //deviation ref https:docs.mql4.com/constants/indicatorconstants/lines
               , 0, price_Applied, bb_Mode    //mode
               , index);   
   
   // append
   idxOf_BB_Prices += 1;
   
   BB_Prices[idxOf_BB_Prices]   = BB_Price;   
   //BB_Prices[2]   = BB_Price;

   /*******************
      step : 2.4
         BB : M1S
   *******************/   
   //index = 0;
   deviation = 1;
   period_BB = 20;
   bb_Mode = MODE_LOWER;
   price_Applied = PRICE_CLOSE;

   BB_Price = (float) iBands(Symbol(), Period(), period_BB
               , deviation    //deviation ref https:docs.mql4.com/constants/indicatorconstants/lines
               , 0, price_Applied, bb_Mode    //mode
               , index);   
   
   // append
   idxOf_BB_Prices += 1;
   
   BB_Prices[idxOf_BB_Prices]   = BB_Price;   
   //BB_Prices[2]   = BB_Price;

   /*******************
      step : 2.5
         BB : M2S
   *******************/   
   //index = 0;
   deviation = 2;
   period_BB = 20;
   bb_Mode = MODE_LOWER;
   price_Applied = PRICE_CLOSE;

   BB_Price = (float) iBands(Symbol(), Period(), period_BB
               , deviation    //deviation ref https:docs.mql4.com/constants/indicatorconstants/lines
               , 0, price_Applied, bb_Mode    //mode
               , index);   
   
   // append
   idxOf_BB_Prices += 1;
   
   BB_Prices[idxOf_BB_Prices]   = BB_Price;   
   // report
   //string txt_Lib_ea_2 = "";
   
   /*******************
      step : 3
         show : BB prices
   *******************/   
   for(int i=0; i< 5; i++)
     {
         txt_Lib_ea_2 += "BB_Prices[" + (string) i + "]"
                     + "\t"
                     + (string) BB_Prices[i]
                     
                     + "\t"   // label
                     + BB_Labels[i]
                     
                     + "\t"   // time
                     + (string) Time[index]  //ref https://www.mql5.com/en/forum/139216
                     + "\n"   // return
                     ;
     }

   // separator line
   txt_Lib_ea_2 += "\n";

   /*******************
      step : 4
         compare
   *******************/   
   int   num_BB_Area;
   
   if(price_Close >= BB_Prices[0])//   >= BB 2S
     {
         num_BB_Area = 1;
     }
   else if(price_Close >= BB_Prices[1])//   >= BB 1S
    {
         num_BB_Area = 2;
    }
   else if(price_Close >= BB_Prices[2])//   >= BB main
    {
         num_BB_Area = 3;
    }
   else if(price_Close > BB_Prices[3])//   > BB M1S
    {
         num_BB_Area = 4;
    }
   else if(price_Close > BB_Prices[4])//   > BB M2S
    {
         num_BB_Area = 5;
    }
   else if(price_Close <= BB_Prices[4])//   <= BB M2S
    {
         num_BB_Area = 6;
    }
   else
    {
         num_BB_Area = -1;
    }
    
    // log
    txt_Lib_ea_2 += "num_BB_Area"
               + "\t"
               + (string) num_BB_Area
               + "\n"
               ;
    
   /*******************
      step : X
         return
   *******************/
   //debug
   //string txt_Lib_ea_2 = "[" + __FILE__ + ":" + (string) __LINE__ + "] get_BB_Loc_Num"
/*   txt_Lib_ea_2 += "[" + __FILE__ + ":" + (string) __LINE__ + "] get_BB_Loc_Num"
                + "\n"
                + "price_Close\t" + (string) price_Close
                + "\n"
                + "price_Open\t" + (string) price_Open
                + "\n"
                
                + "BB_2S\t" + (string) BB_2S
                + "\n"
                + "BB_1S\t" + (string) BB_1S
                + "\n"
                ;
*/
   
   //debug
   Print(txt_Lib_ea_2);
   
   write_Log(dpath_Log , fname_Log_For_Session
         , __FILE__ , __LINE__ , txt_Lib_ea_2);
   
   /*******************
      step : X.1
         set : val
   *******************/
   // return
   //int valOf_Ret = -1;  // test
   int valOf_Ret = num_BB_Area;

   /*******************
      step : X.2
         return
   *******************/
   // : int num_BB_Area
   return valOf_Ret;

}//int is_Order_Pending() {

/*
2019/09/09 13:47:44
func-list.(lib_ea_2.mqh).20190909_134744.txt
==========================================
<funcs>

1	int  OrderSend(
2	bool judge_1() {
3	int take_Position__Buy() {

==========================================
==========================================
<vars>

1	bool SWITHCH_DEBUG_lib_ea_2   = true;

==========================================
==========================================
<externs, inputs>


==========================================
*/
