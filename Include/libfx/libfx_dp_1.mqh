//+------------------------------------------------------------------+
//| C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Include\libfx\
//    libfx_dp_1.mqh
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

//extern string dpath_Log;

//+------------------------------------------------------------------+
//|                                              |
//+------------------------------------------------------------------+


/*---------------------
   vars
---------------------*/


/*---------------------

   bool judge_1()
   
   at : 2019/12/19 12:53:46

---------------------*/
bool dp_Trend_Down_1() {
//_20191219_130232:caller
//_20191219_130237:head
//_20191219_130242:wl

   /*******************
      step : 1
         prep : vars
   *******************/

   /*******************
      step : 2
         detect
   *******************/
   //_20191219_130738:next
   /*******************
      step : 2 : 1
         get : prev 4 bars
   *******************/
   // price : close
   //ref https://docs.mql4.com/predefined/close
   //double   close_M0 = Close[0];
   double   close_M1 = Close[1];
   double   close_M2 = Close[2];
   double   close_M3 = Close[3];
   double   close_M4 = Close[4];
   
   // price : open
   double   open_M1 = Open[1];
   double   open_M2 = Open[2];
   double   open_M3 = Open[3];
   double   open_M4 = Open[4];
   
   // price : diff
   //double   diff_M0 = close_M0 - open_M0;
   double   diff_M1 = close_M1 - open_M1;
   double   diff_M2 = close_M2 - open_M2;
   double   diff_M3 = close_M3 - open_M3;
   double   diff_M4 = close_M4 - open_M4;

   // price : lower
   //double   lower_M0 = 0.0;
   double   lower_M1 = 0.0;
   double   lower_M2 = 0.0;
   double   lower_M3 = 0.0;
   double   lower_M4 = 0.0;
   
   // price : lower ==> set
   //if(diff_M0 < 0) lower_M0 = close_M0; // down bar
   //else lower_M0 = open_M0;   // up bar
   
   if(diff_M1 < 0) lower_M1 = close_M1; // down bar
   else lower_M1 = open_M1;   // up bar

   if(diff_M2 < 0) lower_M2 = close_M2; // down bar
   else lower_M2 = open_M2;   // up bar

   if(diff_M3 < 0) lower_M3 = close_M3; // down bar
   else lower_M3 = open_M3;   // up bar

   if(diff_M4 < 0) lower_M4 = close_M4; // down bar
   else lower_M4 = open_M4;   // up bar

   //debug
   txt = "(step : 2 : 1) get : prev 4 bars";
   txt += "\n";
   
//   txt += "lower_M0 = "
//         + (string) NormalizeDouble(lower_M0, 3)
//         + " / "
     txt += "lower_M1 = "
         + (string) NormalizeDouble(lower_M1, 3)
         + " / "
         + "lower_M2 = "
         + (string) NormalizeDouble(lower_M2, 3)
         + " / "
         + "lower_M3 = "
         + (string) NormalizeDouble(lower_M3, 3)
         + " / "
         + "lower_M4 = "
         + (string) NormalizeDouble(lower_M4, 3)
         ;
   txt += "\n";   

   write_Log(dpath_Log, fname_Log_For_Session
         , __FILE__, __LINE__, txt);

   /*******************
      step : 2 : 2
         judge
   *******************/
   //_20191223_173007:next

   /*******************
      step : X
         return
   *******************/
   return true;

}//bool dp_Trend_Down_1() {

/*---------------------
   bool dp_2__All_True()
   
   at : 2020/04/10 16:00:50
---------------------*/
bool dp_2__All_True() {

   /*******************
      step : 0
         vars
   *******************/

   /*******************
      step : X
         return
   *******************/
   return true;


}//bool dp_2__All_True() {
