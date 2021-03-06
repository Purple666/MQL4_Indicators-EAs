//--------------------------------------------------------------------
//    loc   :  C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Indicators\lab\24_15
//    file  :  t_24_15_1.mq4
//    time  :  2017/11/10 11:34:19
//    generated files : C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Files\Research
// 
// <Usage>
// - 
// <steps>
//    1. update
//          *1) comment block: file name, created-at string
//          *2) "SUBFOLDER" value
//          *2-2) "FNAME" value
//          *3) "string title" value
//          4) _file_write__header() --> column names
//          5) _file_write__data() --> edit variables

//--------------------------------------------------------------------
//+------------------------------------------------------------------+
//| Includes                                                                 |
//+------------------------------------------------------------------+
#include <utils.mqh>

//+------------------------------------------------------------------+
//| vars                                                                 |
//+------------------------------------------------------------------+
extern int Period_MA=21;            // Calculated MA period

int HOURS_PER_DAY=24;

int HIT_INDICES[];   // indices of matched bars

                     // counter
int NUMOF_HIT_INDICES=0;

int FILE_HANDLE;

//+------------------------------------------------------------------+
//| infra vars                                                                 |
//+------------------------------------------------------------------+
int      NUMOF_BARS_PER_HOUR　=1;        // default: 1 bar per hour

int      NUMOF_TARGET_BARS=0;

string   FNAME;

string   session_ID = "24_15_1";

string   FNAME_THIS = "t_" + session_ID + ".(1).mq4";

string   STRING_TIME;

datetime T;

//string DATA[][6];

int      NUMOF_DATA;

// current PERIOD
string   CURRENT_PERIOD = "";   // "D1", "H1", etc.

string   TIME_LABEL = "";

string MAIN_LABEL = "file-io";

//+------------------------------------------------------------------+
//| input vars                                                                 |
//+------------------------------------------------------------------+
input string   SYMBOL_STR="USDJPY";
//input string   SYMBOL_STR = "EURUSD";

//input int      NUMOF_DAYS  = 365; // 1 year
//input int      NUMOF_DAYS  = 60;    // 2 months
input int      NUMOF_DAYS  = 180;    // 6 months

// default: PERIOD_H1
//input int      TIME_FRAME=60;
input int      TIME_FRAME  = 1440;  // 1 day

// BB period (Bollinger Band)
input int      BB_PERIOD = 25;

input string   SUBFOLDER   = "24_15_1";      // subfolder name ---> same as sessin_ID

input int      RSI_PERIOD     = 20;

input int      RSI_THRESHOLD  = 75;

input string   SPAN_START     = "2016.04.01 00:00";

input string   SPAN_END     = "2016.10.31 23:00";

input string   TIME_LABEL_Target_H5 = "2017.11.07 15:55";

input bool     WRITE_DATA_TO_FILE = true;

//--------------------------------------------------------------------
int init() {

   //+------------------------------------------------------------------+
   //| setup
   //+------------------------------------------------------------------+
   setup();   

   //debug
   Alert("[", __FILE__, ":",__LINE__,"] NUMOF_TARGET_BARS => ", NUMOF_TARGET_BARS);
   
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] init() done");

   //ref return value -> https://www.mql5.com/en/forum/55560   
   return 0;
  
}//int init()

int start() // Special function start()
  {
  
         //+------------------------------------------------------------------+
         //| setup
         //+------------------------------------------------------------------+
         //setup();
         //Alert("[",__LINE__,"] starting...");
   
   
         //+------------------------------------------------------------------+
         //| operations                                                                 |
         //+------------------------------------------------------------------+
         //exec();
         //+------------------------------------------------------------------+
         //| terminating the loop                                                                 |
         //+------------------------------------------------------------------+

//--------------------------------------------------------------------
   return 0;                            // Exit start()

  }//int start()
//--------------------------------------------------------------------

//ref about "tick" --> https://www.mql5.com/en/forum/109552
void setup() 
  {
  
   //+------------------------------------------------------------------+
   //| opening message
   //+------------------------------------------------------------------+
   //Alert("starting TR-5.mq4");
   Alert("[", __FILE__, ":",__LINE__,"] starting" + " " + FNAME_THIS);


   //+------------------------------------------------------------------+
   //| set: time frame
   //+------------------------------------------------------------------+
   int res;
   
   switch(TIME_FRAME)
/*
   #ref https://www.mql5.com/en/forum/140787
   PERIOD_M1   1
   PERIOD_M5   5
   PERIOD_M15  15
   PERIOD_M30  30 
   PERIOD_H1   60
   PERIOD_H4   240
   PERIOD_D1   1440
   PERIOD_W1   10080
   PERIOD_MN1  43200
   */
     {
      case  5:      // 5 minutes

         NUMOF_TARGET_BARS = NUMOF_DAYS;
         
         //ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_H1);  // set symbol
         res = set_Symbol(SYMBOL_STR, PERIOD_M5);
         
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] symbol set => ", SYMBOL_STR);
         
         // period name
         CURRENT_PERIOD = "M5";

         break;

      case  60:      // 1 hour

         NUMOF_TARGET_BARS=NUMOF_DAYS*24;
         
         //ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_H1);  // set symbol
         res = set_Symbol(SYMBOL_STR, PERIOD_H1);
         
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] symbol set => ", SYMBOL_STR);
         
         // period name
         CURRENT_PERIOD = "H1";

         break;

      case  240: // 4 hours

         NUMOF_TARGET_BARS = NUMOF_DAYS * 6;
         
         //ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_H4);  // set symbol
         res = set_Symbol(SYMBOL_STR, PERIOD_H4);
         
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] symbol set => ", SYMBOL_STR);

         // period name
         CURRENT_PERIOD = "H4";

         break;

      case  480: // 8 hours

         NUMOF_TARGET_BARS = NUMOF_DAYS*3;
         
         //ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_H8);  // set symbol
         res = set_Symbol(SYMBOL_STR, PERIOD_H8);
         
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] symbol set => ", SYMBOL_STR);
         
         // period name
         CURRENT_PERIOD = "H8";

         break;

      case  1440: // 1 day

         NUMOF_TARGET_BARS = NUMOF_DAYS;
         
         //ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_D1);  // set symbol
         res = set_Symbol(SYMBOL_STR, PERIOD_D1);
         
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] symbol set => ", SYMBOL_STR);


         // period name
         CURRENT_PERIOD = "D1";

         break;

      case  10080: // 1 week

         //ref https://www.mql5.com/en/forum/151559
         //NUMOF_TARGET_BARS = (int) NUMOF_DAYS / 7;
         NUMOF_TARGET_BARS = NUMOF_DAYS;
         
         //ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_W1);  // set symbol
         res = set_Symbol(SYMBOL_STR, PERIOD_W1);
         
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] symbol set => ", SYMBOL_STR);

         // period name
         CURRENT_PERIOD = "W1";

         break;

      case  1: // 1 minute: "NUMOF_DAYS" value is now interpreted as
         //             "NUMOF_HOURS"

         NUMOF_TARGET_BARS=NUMOF_DAYS*60;
         
         //ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_M1);  // set symbol
         res = set_Symbol(SYMBOL_STR, PERIOD_M1);
         
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] symbol set => ", SYMBOL_STR);
         

         // period name
         CURRENT_PERIOD = "M1";

         break;

      default:

         NUMOF_TARGET_BARS=NUMOF_DAYS*24;
         
         //ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_H1);  // set symbol
         res = set_Symbol(SYMBOL_STR, PERIOD_H1);
         
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] symbol set => ", SYMBOL_STR);

         // period name
         CURRENT_PERIOD = "H1";

         break;
     }

   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   Alert("[", __FILE__, ":",__LINE__,"] symbol = ",SYMBOL_STR,""
   
            + " / RSI threshold = ",RSI_THRESHOLD,""
            + " / PERIOD = ",Period(),""         
            
         );

//+------------------------------------------------------------------+
//| Array
//+------------------------------------------------------------------+
   ArrayResize(HIT_INDICES,NUMOF_TARGET_BARS);

   //+------------------------------------------------------------------+
   //| operations                                                                 |
   //+------------------------------------------------------------------+
   exec();


}//setup

void test_Conv_Index_2_TimeString(int index) {

   
   int __TIME_FRAME = TIME_FRAME;
   
   string __Symbol = Symbol();

   conv_Index_2_TimeString(index, __TIME_FRAME, __Symbol);
   
/*
   int _TIME_FRAME = TIME_FRAME;
   
   string label = TimeToStr(iTime(Symbol(), _TIME_FRAME, index));

   //debug
   Alert("[", __FILE__, ":",__LINE__,"] index => ", index, " / ", "label => ", label);
*/   

}//void test_Conv_Index_2_TimeString(index)

void test_Conv_TimeString_2_Index
(string time_string, string symbol, int time_frame, int limit) {
   
   conv_TimeString_2_Index(time_string, symbol, time_frame, limit);

}//conv_TimeString_2_Index(string time_string, string symbol, int time_frame, int limit)

int exec() {

   //+------------------------------------------------------------------+
   //| vars
   //+------------------------------------------------------------------+

   //+------------------------------------------------------------------+
   //| setup
   //+------------------------------------------------------------------+
   //+---------------------------------+
   //| setup   : file
   //+---------------------------------+
   T = TimeLocal();
   
   TIME_LABEL = conv_DateTime_2_SerialTimeLabel((int)T);
   
   //string main_Label = "file-io";
   string main_Label = MAIN_LABEL;
   
   FNAME = _get_FNAME(
               SUBFOLDER, main_Label, SYMBOL_STR, 
               CURRENT_PERIOD, NUMOF_DAYS, 
               NUMOF_TARGET_BARS, TIME_LABEL);

    //debug
    Alert("[", __FILE__, ":",__LINE__,"] FNAME => ", FNAME);
   
   //+------------------------------------------------------------------+
   //| get : array of basic bar data
   //+------------------------------------------------------------------+
//   int index = 10; 
//   test_Conv_Index_2_TimeString(index);

   // test
   string time_string = TIME_LABEL_Target_H5;
   //string time_string = "2017.11.07 15:55";

   string symbol = Symbol();
   
   int time_frame = TIME_FRAME;
   
   int limit = 20;

   test_Conv_TimeString_2_Index(time_string, symbol, time_frame, limit);

   // test
   int time_string_type = 3;
   //int time_string_type = 1;
   
   get_TimeLabel_Current(time_string_type);
   
   return   0;

}//exec()

