#property strict
#property indicator_chart_window // カスタムインジケータをチャートウインドウに表示する

// インジケータプロパティ設定
#property  indicator_buffers    3               // カスタムインジケータのバッファ数
#property  indicator_color1     clrRed         // インジケータ1の色
#property  indicator_type1      DRAW_LINE     // インジケータ1の描画タイプ
#property  indicator_color2     clrAqua         // インジケータ2の色
#property  indicator_type2      DRAW_LINE     // インジケータ2の描画タイプ
#property  indicator_color3     clrAqua         // インジケータ3の色
#property  indicator_type3      DRAW_LINE     // インジケータ3の描画タイプ

// インジケータ表示用動的配列
double     _IndBuffer1[];                          // インジケータ1表示用動的配列
double     _IndBuffer2[];                          // インジケータ2表示用動的配列
double     _IndBuffer3[];                          // インジケータ3表示用動的配列





//+------------------------------------------------------------------+
//| OnInit(初期化)イベント
//+------------------------------------------------------------------+
int OnInit()
{
   SetIndexBuffer( 0, _IndBuffer1 );     // インジケータ1表示用動的配列をインジケータ1にバインドする
   SetIndexBuffer( 1, _IndBuffer2 );     // インジケータ2表示用動的配列をインジケータ2にバインドする
   SetIndexBuffer( 2, _IndBuffer3 );     // インジケータ3表示用動的配列をインジケータ3にバインドする

   return( INIT_SUCCEEDED );      // 戻り値：初期化成功
}

//+------------------------------------------------------------------+
//| OnCalculate(tick受信)イベント
//| カスタムインジケータ専用のイベント関数
//+------------------------------------------------------------------+
int OnCalculate(const int     rates_total,      // 入力された時系列のバー数
                const int       prev_calculated,  // 計算済み(前回呼び出し時)のバー数
                const datetime &time[],          // 時間
                const double   &open[],          // 始値
                const double   &high[],          // 高値
                const double   &low[],           // 安値
                const double   &close[],         // 終値
                const long     &tick_volume[],   // Tick出来高
                const long     &volume[],        // Real出来高
                const int      &spread[])        // スプレッド
{
    int end_index = Bars - prev_calculated;  // バー数取得(未計算分)
    int period = 20;
    
    for( int icount = 0 ; icount < end_index ; icount++ ) {

        // テクニカルインジケータ算出
        double result0 = iMA(
                                  NULL,                       // 通貨ペア
                                  0,                          // 時間軸
                                  period - 1,                 // 平均期間
                                  1,                          // バンドシフト
                                  0,                         //種類
                                  PRICE_CLOSE,               // 適用価格
                                  icount                      // シフト
                                 );

        

       double result = iStdDev(
                                   NULL,         // 通貨ペア
                                   0,             // 時間軸
                                   period - 1,            // MAの平均期間
                                   1,             // MAシフト
                                   MODE_SMA,    // MAの平均化メソッド
                                   PRICE_CLOSE, // 適用価格
                                   icount // シフト
                                  ); 
                                  
       double result1 = result0;
       double result2 = result1 + result*3*MathSqrt(period/(period - 1 - 9));
       double result3 = result1 - result*3*MathSqrt(period/(period - 1 - 9));
       _IndBuffer1[icount] = result1;   // インジケータ1に算出結果を設定
       _IndBuffer2[icount] = result2;   // インジケータ2に算出結果を設定
       _IndBuffer3[icount] = result3;   // インジケータ3に算出結果を設定
       
       
    }

   return( rates_total ); // 戻り値設定：次回OnCalculate関数が呼ばれた時のprev_calculatedの値に渡される
}