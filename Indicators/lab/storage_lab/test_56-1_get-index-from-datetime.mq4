//--------------------------------------------------------------------
//    test_56-1_get-index-from-datetime.mq4
//    2016/12/29 23:50:35
// 
// <Usage>
// - 
// 
//
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

bool Fact_Up = true;                  // Fact of report that price..
bool Fact_Dn = true;                  //..is above or below MA

bool  f_UJ  = false;    // USDJPY
bool  f_EJ  = false;    // EURJPY
bool  f_AJ  = false;    // AUDJPY


int HOURS_PER_DAY=24;

int HIT_INDICES[];   // indices of matched bars

                     // counter
int NUMOF_HIT_INDICES=0;

int FILE_HANDLE;

//+------------------------------------------------------------------+
//| infra vars                                                                 |
//+------------------------------------------------------------------+
//string   SUBFOLDER="Research\\46_3";      // subfolder name

int      NUMOF_BARS_PER_HOUR　=1;        // default: 1 bar per hour

int      NUMOF_TARGET_BARS=0;

string   FNAME;

string   FNAME_THIS = "test_56-1_get-index-from-datetime.mq4";

string   STRING_TIME;

datetime T;

//+------------------------------------------------------------------+
//| input vars                                                                 |
//+------------------------------------------------------------------+
input string   SYMBOL_STR="USDJPY";
//input string   SYMBOL_STR = "EURUSD";

input int      NUMOF_DAYS=30;
//input int      NUMOF_DAYS = 3;

// default: PERIOD_H1
input int      TIME_FRAME=60;

// BB period
input int      BB_PERIOD = 25;

//input string   SUBFOLDER = "46_3";      // subfolder name
input string   SUBFOLDER = "56_1";      // subfolder name

input int      RSI_PERIOD     = 20;

input int      RSI_THRESHOLD  = 75;

input string   SPAN_START     = "2016.12.29 08:00";

//--------------------------------------------------------------------
int init() {

   //+------------------------------------------------------------------+
   //| setup
   //+------------------------------------------------------------------+
   setup();   

   //ref return value -> https://www.mql5.com/en/forum/55560   
   return 0;
  
}



int start() // Special function start()
  {
  
//test
   if(f_UJ == false || f_EJ == false || f_AJ == false) // 
     {

         //+------------------------------------------------------------------+
         //| setup
         //+------------------------------------------------------------------+
         //setup();
         Alert("[",__LINE__,"] starting...");
   
   
         //+------------------------------------------------------------------+
         //| operations                                                                 |
         //+------------------------------------------------------------------+
         //string target_datetime = "2016.12.29 08:00";
         string target_datetime = SPAN_START;
         
         int target_period = 60;
         
         int result = test_get_index(target_datetime, target_period);
         
         Alert("target = ",target_datetime," / index = ",result,"");
         
         //+------------------------------------------------------------------+
         //| terminating the loop                                                                 |
         //+------------------------------------------------------------------+
         f_UJ = true;
         f_EJ = true;
         f_AJ = true;

     }


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
      Alert("[",__LINE__,"] starting" + " " + FNAME_THIS);

//+------------------------------------------------------------------+
//| set: symbol
//+------------------------------------------------------------------+

//ChartSetSymbolPeriod(0, SYMBOL_STR, 0);  // set symbol
   //ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_H1);  // set symbol

   //Alert("[",__LINE__,"] symbol set to => ",SYMBOL_STR,"");
   

//+------------------------------------------------------------------+
//| set: time frame
//+------------------------------------------------------------------+
   switch(TIME_FRAME)
     {
      case  60:      // 1 hour

         NUMOF_TARGET_BARS=NUMOF_DAYS*24;
         
         ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_H1);  // set symbol

         break;

      case  240: // 4 hours

         NUMOF_TARGET_BARS = NUMOF_DAYS * 6;
         
         ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_H4);  // set symbol

         break;

      case  480: // 8 hours

         NUMOF_TARGET_BARS = NUMOF_DAYS*3;
         
         ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_H8);  // set symbol

         break;

      case  1440: // 1 day

         NUMOF_TARGET_BARS = NUMOF_DAYS;
         
         ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_D1);  // set symbol

         break;

      case  10080: // 1 week

         //ref https://www.mql5.com/en/forum/151559
         //NUMOF_TARGET_BARS = (int) NUMOF_DAYS / 7;
         NUMOF_TARGET_BARS = NUMOF_DAYS;
         
         ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_W1);  // set symbol

         break;

      case  1: // 1 minute: "NUMOF_DAYS" value is now interpreted as
         //             "NUMOF_HOURS"

         NUMOF_TARGET_BARS=NUMOF_DAYS*60;
         
         ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_M1);  // set symbol

         break;

      default:

         NUMOF_TARGET_BARS=NUMOF_DAYS*24;
         
         ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_H1);  // set symbol

         break;
     }

   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   Alert("[",__LINE__,"] symbol = ",SYMBOL_STR,""
   
            + " / RSI threshold = ",RSI_THRESHOLD,""
            + " / PERIOD = ",Period(),""         
            
         );

//+------------------------------------------------------------------+
//| Array
//+------------------------------------------------------------------+
   ArrayResize(HIT_INDICES,NUMOF_TARGET_BARS);

  }//setup

//+------------------------------------------------------------------+
//| write_file
//    @return
//       -1    can't open file
//+------------------------------------------------------------------+
int write_file()
  {
//yy

//+------------------------------------------------------------------+
//| set: file name
//+------------------------------------------------------------------+
//datetime t = TimeLocal();
   T=TimeLocal();

//STRING_TIME = conv_DateTime_2_SerialTimeLabel((int)t);

   FNAME = "test_56-1"

         + "." + SYMBOL_STR
         + "." + (string) NUMOF_DAYS+"-days"
         
         //+ "." + conv_DateTime_2_SerialTimeLabel((int)t) 
         +"."
         + conv_DateTime_2_SerialTimeLabel((int)T)
         //+ "." + STRING_TIME
         +".csv";

//+------------------------------------------------------------------+
//| file: open
//+------------------------------------------------------------------+
   int result=_file_open();

   if(result==-1)
     {

      return -1;

     }

//+------------------------------------------------------------------+
//| file: write: metadata
//+------------------------------------------------------------------+
   _file_write__metadata();

//+------------------------------------------------------------------+
//| file: write: header
//+------------------------------------------------------------------+
   _file_write__header();

//+------------------------------------------------------------------+
//| file: write: data
//+------------------------------------------------------------------+
   _file_write__data();

//+------------------------------------------------------------------+
//| file: write: footer
//+------------------------------------------------------------------+
   _file_write__footer();

//+------------------------------------------------------------------+
//| file: close
//+------------------------------------------------------------------+
   _file_close();

// return
   return 1;

  }//write_file()
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int _file_write__data()
  {

   double   a,b;
   
   double   next_bar_size;
   
   double   signal;
   double   macd;
   double   rsi;
   
   double   m1, s1;

   for(int i=0; i < NUMOF_HIT_INDICES; i++)
     {

      a = Close[HIT_INDICES[i]];
      b = Open[HIT_INDICES[i]];
      
      next_bar_size = Close[HIT_INDICES[i] - 1] - Open[HIT_INDICES[i] - 1];
      
      signal   = iMACD(NULL
                        , TIME_FRAME,  12
                        // slow EMA period   signal line period
                        , 26,   9
                        // applied price  line index     shift
                        , PRICE_CLOSE,   MODE_SIGNAL,   HIT_INDICES[i]);
      
      macd     =  iMACD(NULL
                        , TIME_FRAME,  12
                        // slow EMA period   signal line period
                        , 26,   9
                        // applied price  line index     shift
                        , PRICE_CLOSE,   MODE_MAIN,   HIT_INDICES[i]);                 
      
      rsi = iRSI(NULL, TIME_FRAME, RSI_PERIOD, PRICE_CLOSE, HIT_INDICES[i]);

      s1   = iMACD(NULL
                        , TIME_FRAME,  12
                        // slow EMA period   signal line period
                        , 26,   9
                        // applied price  line index     shift
                        , PRICE_CLOSE,   MODE_SIGNAL,   HIT_INDICES[i] + 1);
      
      m1     =  iMACD(NULL
                        , TIME_FRAME,  12
                        // slow EMA period   signal line period
                        , 26,   9
                        // applied price  line index     shift
                        , PRICE_CLOSE,   MODE_MAIN,   HIT_INDICES[i] + 1);                 


//               "no.","index","time","close","open"               
//               , "RSI"
//               , "next bar size"
//               , "signal", "MACD", "MACD - signal"

      FileWrite(FILE_HANDLE,

                (i+1),

                HIT_INDICES[i],

                TimeToStr(iTime(Symbol(),Period(),HIT_INDICES[i])),

                a, b
                
                , rsi
                
                , next_bar_size

                // "signal", "MACD", "MACD - signal"
                , signal, macd, (macd - signal)
                
                //"m1", "s1", "m0", "s0", "m1-m0", "s1-s0"
                , m1, s1, macd, signal, (m1 - macd), (s1 - signal)
                
                );

     }//for(i = 0; i < NUMOF_HIT_INDICES; i++)

// metadata
//   FileWrite(FILE_HANDLE,

//      "total = " + NUMOF_HIT_INDICES

//   );

// return
   return 1;

  }//_file_write__data()
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int _file_write__footer() 
  {

   FileWrite(FILE_HANDLE,

             "done"

             );    // header

//debug
   Alert("[",__LINE__,"] footer => written");

// return
   return 1;


  }//_file_write__footer()
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int _file_write__header() 
  {

   FileWrite(FILE_HANDLE,

               "no.","index","time","close","open"
               
               , "RSI"
               
               , "next bar size"

               , "signal", "MACD", "MACD - signal"
               
               , "m1", "s1", "m0", "s0", "m1-m0", "s1-s0"
               
             );    // header

//debug
   Alert("[",__LINE__,"] header => written");

// return
   return 1;

  }//_file_write__header()
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int _file_write__metadata() 
  {

//+------------------------------------------------------------------+
//| prep: strings
//+------------------------------------------------------------------+
   string title="Detect: RSI equal or over 75; and RSI"
                ;

//+------------------------------------------------------------------+
//| File: write: metadata
//+------------------------------------------------------------------+
   FileWrite(FILE_HANDLE,
             //"file created = " + TimeToStr(t, TIME_DATE|TIME_SECONDS), 
             "file created = "+TimeToStr(T,TIME_DATE|TIME_SECONDS),
             "symbol = "+SYMBOL_STR,
             //PERIOD_CURRENT
             //ref https://www.mql5.com/en/forum/133159
             "time frame = "+(string)Period()

             );

   FileWrite(FILE_HANDLE,
             title

             );

   FileWrite(FILE_HANDLE,

             "NUMOF_TARGET_BARS = "+(string)NUMOF_TARGET_BARS

             );

   FileWrite(FILE_HANDLE,

             "start = "+TimeToStr(iTime(Symbol(),Period(),(NUMOF_TARGET_BARS-1))),

             "end = "+TimeToStr(iTime(Symbol(),Period(),0)),

             "days = "+(string) NUMOF_DAYS

             ,"total = "+(string) NUMOF_HIT_INDICES

             );

//+------------------------------------------------------------------+
//| return
//+------------------------------------------------------------------+
   return 1;

  }//_file_write__metadata()
//+------------------------------------------------------------------+
//| _file_open()
//    @return
//       1  file opened
//       0  can't open file
//+------------------------------------------------------------------+
int _file_open() 
  {

   //FILE_HANDLE=FileOpen(SUBFOLDER+"\\"+FNAME,FILE_WRITE|FILE_CSV);
   FILE_HANDLE=FileOpen("Research\\" + SUBFOLDER + "\\"+FNAME,FILE_WRITE|FILE_CSV);

//if(FILE_HANDLE!=INVALID_HANDLE) {
   if(FILE_HANDLE==INVALID_HANDLE) 
     {

      Alert("[",__LINE__,"] can't open file: ",FNAME,"");

      // return
      return -1;

     }//if(FILE_HANDLE == INVALID_HANDLE)

//+------------------------------------------------------------------+
//| File: seek
//+------------------------------------------------------------------+
//ref https://www.mql5.com/en/forum/3239
   FileSeek(FILE_HANDLE,0,SEEK_END);

// return
   return 1;

  }//_file_open()
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void _file_close() 
  {

   FileClose(FILE_HANDLE);

   Alert("[",__LINE__,"] file => closed");

  }//_file_close()
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void detect_MACD_plus_RSI() 
  {
//xx
   Alert("[",__LINE__,"] detect_MACD_plus_RSI()");

// vars
   double   rsi;

   double m0, s0;
   double m1, s1;

   int b0_offset  = 0;
   int b1_offset  = 1;

   //for(int i = (NUMOF_TARGET_BARS - 1); i>=0; i--)
   for(int i = (NUMOF_TARGET_BARS - 1 - 1); i>=0; i--)
     {

         //+------------------------------------------------------------------+
         //| get: data
         //+------------------------------------------------------------------+
         rsi = iRSI(NULL, TIME_FRAME, RSI_PERIOD, PRICE_CLOSE, i);

         // bar 0               // slow EMA period   signal line period
         s0   = iMACD(NULL, TIME_FRAME,  12, 26,   9
                           // applied price  line index     shift
                           , PRICE_CLOSE,   MODE_SIGNAL,   i + b0_offset);

                                 // slow EMA period   signal line period      
         m0     =  iMACD(NULL, TIME_FRAME,  12, 26,   9
                           // applied price  line index     shift
                           , PRICE_CLOSE,   MODE_MAIN,   i + b0_offset);                 
         
         // bar 1               // slow EMA period   signal line period
         s1   = iMACD(NULL, TIME_FRAME,  12, 26,   9
                           // applied price  line index     shift
                           , PRICE_CLOSE,   MODE_SIGNAL,   i + b1_offset);
                           
                                 // slow EMA period   signal line period      
         m1     =  iMACD(NULL, TIME_FRAME,  12, 26,   9
                           // applied price  line index     shift
                           , PRICE_CLOSE,   MODE_MAIN,   i + b1_offset);  
      
         //+------------------------------------------------------------------+
         //| judge                                                                 |
         //+------------------------------------------------------------------+
         //if(rsi >= 75) 
         if(rsi >= RSI_THRESHOLD
               && (m0 < s0 && m1 > s1)) 
           {
           
               HIT_INDICES[NUMOF_HIT_INDICES] = i;
               
               NUMOF_HIT_INDICES += 1;
               
               continue;
            
           }//if(rsi >= 75)
         else
           {
            
               continue;
               
           }

     }//for(int i = (NUMOF_TARGET_BARS - 1 - 2); i >= 2; i--)

//+------------------------------------------------------------------+
//| report
//+------------------------------------------------------------------+
   Alert("[",__LINE__,"] NUMOF_TARGET_BARS => ",NUMOF_TARGET_BARS,""

         +" / "
         +"NUMOF_HIT_INDICES => ",NUMOF_HIT_INDICES,""

         +"(",NormalizeDouble(NUMOF_HIT_INDICES*1.0/NUMOF_TARGET_BARS,4),")"

         );

  }//detect_MACD_plus_RSI()

int detect_Pattern() {

   int result;
   
   //+------------------------------------------------------------------+
   //| detect: USDJPY                                                                 |
   //+------------------------------------------------------------------+
   if(f_UJ != true)
     {

         result = _detect_Pattern("USDJPY");
         
         if(result == 1)
           {
               
               return result;
               
           }   

     }//if(f_UJ != true)
     
   //+------------------------------------------------------------------+
   //| detect: EURJPY                                                                 |
   //+------------------------------------------------------------------+
   if(f_EJ != true)
     {

         result = _detect_Pattern("EURJPY");
         
         if(result == 2)
           {
               
               return result;
               
           }   

     }//if(f_UJ != true)
     
   //+------------------------------------------------------------------+
   //| detect: AUDJPY                                                                 |
   //+------------------------------------------------------------------+
   if(f_AJ != true)
     {

         result = _detect_Pattern("AUDJPY");
         
         if(result == 3)
           {
               
               return result;
               
           }   

     }//if(f_UJ != true)

   //+------------------------------------------------------------------+
   //| default                                                                 |
   //+------------------------------------------------------------------+
   return 0;


}//detect_Pattern()

//+------------------------------------------------------------------+
//| @return
//    1)if detected
   //    1  U*J                                                                 |
   //    2  E*J                                                                 |
   //    3  A*J                                                                 |
//    2) not detected => 0   
//+------------------------------------------------------------------+
int _detect_Pattern(string pair) {

   //+------------------------------------------------------------------+
   //| get: data                                                                 |
   //+------------------------------------------------------------------+
   double m0, s0;
   double m1, s1;
   double   rsi;
   
   int b0_offset  = 0;
   int b1_offset  = 1;
   
   // bar 0               // slow EMA period   signal line period
   s0   = iMACD(pair, TIME_FRAME,  12, 26,   9
                     // applied price  line index     shift
                     , PRICE_CLOSE,   MODE_SIGNAL,   b0_offset);
                     
                           // slow EMA period   signal line period      
   m0     =  iMACD(pair, TIME_FRAME,  12, 26,   9
                     // applied price  line index     shift
                     , PRICE_CLOSE,   MODE_MAIN,   b0_offset);                 
   
   // bar 1               // slow EMA period   signal line period
   s1   = iMACD(pair, TIME_FRAME,  12, 26,   9
                     // applied price  line index     shift
                     , PRICE_CLOSE,   MODE_SIGNAL,   b1_offset);
                     
                           // slow EMA period   signal line period      
   m1     =  iMACD(pair, TIME_FRAME,  12, 26,   9
                     // applied price  line index     shift
                     , PRICE_CLOSE,   MODE_MAIN,   b1_offset);  
                  
   rsi   = iRSI(pair,TIME_FRAME,RSI_PERIOD,PRICE_CLOSE, b0_offset);
   
   
   //+------------------------------------------------------------------+
   //| judge                                                                 |
   //+------------------------------------------------------------------+

   if(m0 < s0 && m1 > s1
      && (rsi > RSI_THRESHOLD))
   //if(rsi > RSI_THRESHOLD)
   //if(m0 < 0)
     {
                       
         // return
         int ret;
         
         if(pair == "USDJPY")
           {
               ret = 1;
           }
         else if(pair == "EURJPY")
           {
               ret = 2;
           }
         else if(pair == "AUDJPY")
           {
               ret = 3;
           }
         else
           {
            
               ret = 0;
            
           }

         Alert("[",__LINE__,"] pair = ",pair," / rsi = ",rsi,"");

         return ret;

     }//if(m0 < s0 && m1 > s1)

   //+------------------------------------------------------------------+
   //| return: default                                                                 |
   //+------------------------------------------------------------------+
   return   0;

}//_detect_Pattern("USDJPY")

/****************************

   @param target_datetime     => "2016.12.20 08:00"   (H1)
   @param period              => 60 --> H1
   
   @return
      -1    => no match
      >=0   => hit index
*****************************/
int test_get_index(string target_datetime, int period) {

   int index = -1;

   string d;
   
   //debug
   int count = 0;
   
   int count_max = 20;
   
   Alert("[",__LINE__,"] NUMOF_TARGET_BARS = ",NUMOF_TARGET_BARS,"");
   
   for(int i = 0; i < NUMOF_TARGET_BARS; i ++) {

      d = TimeToStr(iTime(Symbol(),Period(), i));
      
      //debug
      Alert("[",__LINE__,"] i = ",i," / d = ",d,"");
      
      // judge
      if(d == target_datetime)
        {
            Alert("[",__LINE__,"] match => d = '",d,"' "
                  + "/ target_datetime = '",target_datetime,"'"
                  + " / "
                  + "index = ",i,""
                  
                  );
                  
            // break the for loop
            index = i;
            
            break;
            
        }
      else
        {
            Alert("[",__LINE__,"] not match");
        }
   
      // debug
//            if(count > count_max)
//            {
//              break;
//        }
      
  //    count += 1;
   
   }//for(int i = 0; i < NUMOF_TARGET_BARS; i ++)

/*
   switch(period)
     {
      case  60:      //=> H1
         
         for(int i = 0; i < NUMOF_TARGET_BARS; i ++) {
         
            d = TimeToStr(iTime(Symbol(),Period(), i));
            
            //debug
            Alert("[",__LINE__,"] i = ",i," / d = ",d,"");
            
            // judge
            if(d == target_datetime)
              {
                  Alert("[",__LINE__,"] match => d = '",d,"' "
                        + "/ target_datetime = '",target_datetime,"'"
                        + " / "
                        + "index = ",i,""
                        
                        );
                        
                  // break the for loop
                  index = i;
                  
                  break;
                  
              }
            else
              {
                  Alert("[",__LINE__,"] not match");
              }
         
            // debug
//            if(count > count_max)
  //            {
    //              break;
      //        }
            
        //    count += 1;
         
         }//for(int i = 0; i < NUMOF_TARGET_BARS; i ++)
        
        break;
        
      default:
        break;
        
     }
*/
   return index;
   
}//test_get_index(string target_datetime)
