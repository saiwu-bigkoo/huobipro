class TrendBean{
  /***
   * 字段名称	数据类型	描述
      id	long	NA
      amount	float	以基础币种计量的交易量（以滚动24小时计）
      count	integer	交易次数（以滚动24小时计）
      open	float	本阶段开盘价（以滚动24小时计）
      close	float	本阶段最新价（以滚动24小时计）
      low	float	本阶段最低价（以滚动24小时计）
      high	float	本阶段最高价（以滚动24小时计）
      vol	float	以报价币种计量的交易量（以滚动24小时计）
      bid	object	当前的最高买价 [price, size]
      ask	object	当前的最低卖价 [price, size]
      pt	发行时间
   */
  final String ch;
  final int pt;
  final num amount;
  final num close;
  final num count;
  final num high;
  final num id;
  final num low;
  final num open;
  final num rmb;
  final num increase;
  final List<num> ask;

  TrendBean.fromMap(Map<String, dynamic> map)
      : assert(map['ch'] != null),
        ch = map['ch'],
        amount = map['amount'],
        close = map['close'],
        count = map['count'],
        high = map['high'],
        id = map['id'],
        low = map['low'],
        open = map['open'],
        pt = map['pt'],
        rmb = map['rmb'],
        increase = map['increase'],
        ask = map['ask'].cast<num>()
  ;


}