# 公共 API 端点-币币交易


### 术语解释

* `base asset` 指的是symbol的`quantity`（即数量）。

* `quote asset` 指的是symbol的`price`（即价格）。

### ENUM 定义

**Symbol 状态:**

* TRADING - 交易中
* HALT - 终止
* BREAK - 断开

**Symbol 类型:**

* SPOT - 现货

**资产类型:**

* CASH - 现金
* MARGIN - 保证金

**订单状态:**

* NEW - 新订单，暂无成交
* PARTIALLY_FILLED - 部分成交
* FILLED - 完全成交
* CANCELED - 已取消
* PENDING_CANCEL - 等待取消
* REJECTED - 被拒绝

**订单类型:**

* LIMIT - 限价单
* MARKET - 市价单
* LIMIT_MAKER - maker限价单

**订单方向:**

* BUY - 买单
* SELL - 卖单

**订单时效类型:**

* GTC
* IOC
* FOK

**k线/烛线图区间:**

  m -> 分钟; h -> 小时; d -> 天; w -> 周; M -> 月

* 1m
* 3m
* 5m
* 15m
* 30m
* 1h
* 2h
* 4h
* 6h
* 8h
* 12h
* 1d
* 3d
* 1w
* 1M

**频率限制类型 (rateLimitType)**

* REQUESTS_WEIGHT
* ORDERS

**频率限制区间**

* SECOND

* MINUTE

* DAY

比如：

  ```
  {
        "rateLimitType": "ORDERS",
        "inteval": "SECOND",
        "limit": 20
      }
  ```

这表示每秒的下单频率限制为20。

------

# 公共

## 安全类型: [None]()

**公共**下方的端点不需要API-Key或者签名就能自由访问



#### 测试连接

```shell
GET /openapi/v1/ping
```

测试REST API的连接。

**Weight:** 0

**Parameters:** NONE

**Response:**

```javascript
{}
```

#### 服务器时间

```shell
GET /openapi/v1/time
```

测试连接并获取当前服务器的时间。

**Weight:** 0

**Parameters:** NONE

**Response:**

```javascript
{
  "serverTime": 1538323200000
}
```

#### Broker信息

```shell
GET /openapi/v1/brokerInfo
```

当前broker交易规则和symbol信息

**Weight:** 0

**Parameters:**

> | 名称 | 类型   | 是否强制 | 描述                                                         |
> | ---- | ------ | -------- | ------------------------------------------------------------ |
> | type | string | NO       | 交易类型，支持的类型现为`token`（币币）。如果没有发送此参数，所有交易类型的symbol信息都会被返回。 |

**Response:**

> | 名称         | 类型   | 例子            | 描述                                          |
> | ------------ | ------ | --------------- | --------------------------------------------- |
> | `timezone`   | string | `UTC`           | 服务器所在时区                                |
> | `serverTime` | long   | `1554887652929` | 当前服务器时间（Unix Timestamp格式，ms毫秒级) |
>
> 在 `symbols`对应的信息组里，所有当前正在交易的币对信息将会被返回：
>
> | 名称                  | 类型   | 例子            | 描述               |
> | --------------------- | ------ | --------------- | ------------------ |
> | `symbol`              | string | `BTC0308CS3900` | 币对名称           |
> | `status`              | string | `TRADING`       | 币对当前状态       |
> | `baseAsset`           | string | `BTC0308CS3900` | 币对的名称         |
> | `baseAssetPrecision`  | float  | `0.001`         | 币对交易张数精度   |
> | `quoteAsset`          | string | `USDT`          | 计价的货币         |
> | `quoteAssetPrecision` | float  | `0.01`          | 币对交易价格的精度 |
> | `icebergAllowed`      | string | `false`         | 是否支持“冰山订单” |
>
> 在`symbols`里面的`filters`对应的信息组里：
>
> | 名称          | 类型   | 例子              | 描述                       |
> | ------------- | ------ | ----------------- | -------------------------- |
> | `filterType`  | string | `PRICE_FILTER`    | Filter类型                 |
> | `minPrice`    | float  | `0.001`           | 币对最小交易价格           |
> | `maxPrice`    | float  | `100000.00000000` | 币对最大交易价格           |
> | `tickSize`    | float  | `0.001`           | 币对交易价格精度           |
> | `minQty`      | float  | `0.01`            | 币对最小交易张数           |
> | `maxQty`      | float  | `100000.00000000` | 币对最大交易张数           |
> | `stepSize`    | float  | `0.001`           | 币对交易张数精度           |
> | `minNotional` | float  | `1`               | 订单金额精度 (数量 * 价格) |
>
> tokens 数据
>
> | 名称          | 类型    | 例子    | 描述                                                         |
> | ------------- | ------- | ------- | ------------------------------------------------------------ |
> | orgId         | integer | 9002    | 券商编号                                                     |
> | tokenId       | string  | BTC     | 币种Id                                                       |
> | tokenName     | string  | BTC     | 币种名称                                                     |
> | tokenFullName | string  | Bitcoin | 币种全称                                                     |
> | allowWithdraw | bool    | true    | true=允许提币，false=禁止提币                                |
> | allowDeposit  | bool    | true    | true=允许提币，false=禁止提币                                |
> | chainTypes    | Array   | [ ]     | 链类型。不同的链对应各自的allowWithdraw 和 allowDeposit 状态 |

**Response:**

```javascript
{
  "timezone": "UTC",
  "serverTime": 1538323200000,
  "rateLimits": [{
      "rateLimitType": "REQUESTS_WEIGHT",
      "interval": "MINUTE",
      "limit": 1500
    },
    {
      "rateLimitType": "ORDERS",
      "interval": "SECOND",
      "limit": 20
    },
    {
      "rateLimitType": "ORDERS",
      "interval": "DAY",
      "limit": 350000
    }
  ],
  "brokerFilters":[],
  "symbols": [{
    "symbol": "ETHBTC",
    "status": "TRADING",
    "baseAsset": "ETH",
    "baseAssetPrecision": "0.001",
    "quoteAsset": "BTC",
    "quotePrecision": "0.01",
    "icebergAllowed": false,
    "filters": [{
      "filterType": "PRICE_FILTER",
      "minPrice": "0.00000100",
      "maxPrice": "100000.00000000",
      "tickSize": "0.00000100"
    }, {
      "filterType": "LOT_SIZE",
      "minQty": "0.00100000",
      "maxQty": "100000.00000000",
      "stepSize": "0.00100000"
    }, {
      "filterType": "MIN_NOTIONAL",
      "minNotional": "0.00100000"
    }]
  }]
}
```

------

# 行情

## 安全类型: [None]()

**行情**下方的端点不需要API-Key或者签名就能自由访问



#### 订单簿

```shell
GET /openapi/quote/v1/depth
```

**Weight:**

根据limit不同：

> | Limit              | Weight |
> | ------------------ | ------ |
> | 5, 10, 20, 50, 100 | 1      |
> | 500                | 5      |
> | 1000               | 10     |

**Parameters:**

> | 名称   | 类型    | 是否强制 | 描述                      |
> | ------ | ------- | -------- | ------------------------- |
> | symbol | string  | YES      | Symbol名称 E.g. `BTCUSDT` |
> | limit  | integer | NO       | 默认 100; 最大 100.       |

**注意:** 如果设置limit=0会返回很多数据。

**Response:**

> | 名称   | 类型 | 例子            | 描述                                               |
> | ------ | ---- | --------------- | -------------------------------------------------- |
> | `time` | long | `1550829103981` | 当前时间（Unix Timestamp，毫秒ms）                 |
> | `bids` | list | (如下)          | 所有bid的价格和数量信息，最优bid价格由上到下排列。 |
> | `asks` | list | (如下)          | 所有ask的价格和数量信息，最优ask价格由上到下排列。 |
>
> `bids`和`asks`所对应的信息组代表了订单簿的所有价格以及价格对应数量的信息，由最优价格从上到下排列。
>
> | 名称 | 类型  | 例子     | 描述               |
> | ---- | ----- | -------- | ------------------ |
> | `''` | float | `123.10` | 价格               |
> | `''` | float | `300`    | 当前价格对应的数量 |

**Response:**

[价格, 数量]

```javascript
{
  "bids": [
    [
      "3.90000000",   // 价格
      "431.00000000"  // 数量
    ],
    [
      "4.00000000",
      "431.00000000"
    ]
  ],
  "asks": [
    [
      "4.00000200",  // 价格
      "12.00000000"  // 数量
    ],
    [
      "5.10000000",
      "28.00000000"
    ]
  ]
}
```

#### 合并订单簿（推荐）

```sh
GET /openapi/quote/v1/depth/merged
```

这个端点返回市场订单簿深度信息(非全量)。该端点300毫秒更新一次。

**Parameters:**

> | 名称   | 类型    | 是否强制 | 描述                      |
> | ------ | ------- | -------- | ------------------------- |
> | symbol | string  | YES      | Symbol名称 E.g. `BTCUSDT` |
> | limit  | integer | NO       | 默认100; 最大 100.        |

**Response:**

> | 名称   | 类型 | 例子            | 描述                                               |
> | ------ | ---- | --------------- | -------------------------------------------------- |
> | `time` | long | `1550829103981` | 当前时间（Unix Timestamp，毫秒ms）                 |
> | `bids` | list | (如下)          | 所有bid的价格和数量信息，最优bid价格由上到下排列。 |
> | `asks` | list | (如下)          | 所有ask的价格和数量信息，最优ask价格由上到下排列。 |
>
> `bids`和`asks`所对应的信息组代表了订单簿的所有价格以及价格对应数量的信息，由最优价格从上到下排列。
>
> | 名称 | 类型  | 例子     | 描述               |
> | ---- | ----- | -------- | ------------------ |
> | `''` | float | `123.10` | 价格               |
> | `''` | float | `300`    | 当前价格对应的数量 |

**Response:**

```javascript
{
  "bids": [
    [
      "3.90000000",   // 价格
      "431.00000000"  // 数量
    ],
    [
      "4.00000000",
      "431.00000000"
    ]
  ],
  "asks": [
    [
      "4.00000200",  // 价格
      "12.00000000"  // 数量
    ],
    [
      "5.10000000",
      "28.00000000"
    ]
  ]
}
```



#### 最近成交

```shell
GET /openapi/quote/v1/trades
```

获取当前最新成交

**Weight:** 1

**Parameters:**

> | 名称   | 类型    | 是否强制 | 描述                      |
> | ------ | ------- | -------- | ------------------------- |
> | symbol | string  | YES      | Symbol名称 E.g. `BTCUSDT` |
> | limit  | integer | NO       | Default 500; max 1000.    |
>

**Response:**

> | 名称           | 类型   | 例子          | 描述                                               |
> | -------------- | ------ | ------------- | -------------------------------------------------- |
> | `price`        | float  | `0.055`       | 交易价格                                           |
> | `time`         | long   | 1537797044116 | 当前Unix时间戳，毫秒(ms)                           |
> | `qty`          | float  | `5`           | 数量（张数）                                       |
> | `isBuyerMaker` | string | `true`        | `true`=订单创建时为买单，`false`= 订单创建时为卖单 |

**Response:**

```javascript
[
  {
    "price": "4.00000100",
    "qty": "12.00000000",
    "time": 1499865549590,
    "isBuyerMaker": true
  }
]
```

#### k线/烛线图数据

```shell
GET /openapi/quote/v1/klines
```

symbol的k线/烛线图数据。K线会根据开盘时间而辨别。

**Weight:** 1

**Parameters:**

> | 名称      | 类型    | 是否强制 | 描述                                                         |
> | --------- | ------- | -------- | ------------------------------------------------------------ |
> | symbol    | string  | YES      | Symbol名称 E.g. `BTCUSDT`                                    |
> | interval  | string  | YES      | K线图区间。可识别发送的值为： `1m`,`5m`,`15m`,`30m`,`1h`,`1d`,`1w`,`1M`（m=分钟，h=小时,d=天，w=星期，M=月） |
> | startTime | long    | NO       | 开始时间戳(毫秒ms)                                           |
> | endTime   | long    | NO       | 结束时间戳(毫秒ms)                                           |
> | limit     | integer | NO       | 默认1000; 最大1000.                                          |
>

* 如果startTime和endTime没有发送，只有最新的K线会被返回。

**Response:**

> | 名称 | 类型    | 例子              | 描述                   |
> | ---- | ------- | ----------------- | ---------------------- |
> | `''` | long    | `1538728740000`   | 开始时间戳，毫秒（ms） |
> | `''` | float   | `36.00000`        | 开盘价                 |
> | `''` | float   | `36.00000`        | 最高价                 |
> | `''` | float   | `36.00000`        | 最低价                 |
> | `''` | float   | `36.00000`        | 收盘价                 |
> | `''` | float   | `148976.11427815` | 交易金额               |
> | `''` | long    | `1538728740000`   | 停止时间戳，毫秒（ms） |
> | `''` | float   | `2434.19055334`   | 交易数量（张数）       |
> | `''` | integer | `308`             | 已成交数量（张数）     |
> | `''` | float   | `1756.87402397`   | 买方购买金额           |
> | `''` | float   | `28.46694368`     | 买方购买数量（张数）   |

**Response:**

```javascript
[
  [
    1499040000000,      // 开盘时间
    "0.01634790",       // 开盘价
    "0.80000000",       // 最高价
    "0.01575800",       // 最低价
    "0.01577100",       // 收盘价
    "148976.11427815",  // 交易量
    1499644799999,      // 收盘时间
    "2434.19055334",    // Quote asset数量
    308,                // 交易次数
    "1756.87402397",    // Taker buy base asset数量
    "28.46694368"       // Taker buy quote asset数量
  ]
]
```

#### 24小时ticker价格变化数据

```shell
GET /openapi/quote/v1/ticker/24hr
```

24小时价格变化数据。**注意** 如果没有发送symbol，会返回很多数据。

**Weight:**

如果只有一个symbol，1; 如果symbol没有被发送，**40**。

**Parameters:**

> | 名称   | 类型   | 是否强制 | 描述                       |
> | ------ | ------ | -------- | -------------------------- |
> | symbol | string | NO       | Symbol 名称 E.g. `BTCUSDT` |
>

* 如果symbol没有被发送，所有symbol的数据都会被返回。

**Response:**

> | 名称           | 类型   | 例子            | 描述        |
> | -------------- | ------ | --------------- | ----------- |
> | `time`         | long   | `1538728740000` | 开始时间戳  |
> | `symbol`       | string | `ETHBTC`        | Symbol 名称 |
> | `bestBidPrice` | float  | `4.000002000`   | 最佳买价    |
> | `bestAskPrice` | float  | `4.000002000`   | 最佳卖价    |
> | `lastPrice`    | float  | `4.000002000`   | 最新成交价  |
> | `openPrice`    | float  | `99.0000000`    | 开盘价      |
> | `highPrice`    | float  | `100.0000000`   | 最高价      |
> | `lowPrice`     | float  | `0.10000000`    | 最低价      |
> | `volume`       | float  | `8913.300000`   | 交易量      |

**Response:**

```javascript
{
  "time": 1538725500422,
  "symbol": "ETHBTC",
  "bestBidPrice": "4.00000200",
  "bestAskPrice": "4.00000200",
  "lastPrice": "4.00000200",
  "openPrice": "99.00000000",
  "highPrice": "100.00000000",
  "lowPrice": "0.10000000",
  "volume": "8913.30000000"
}
```

OR

```javascript
[
  {
    "time": 1538725500422,
    "symbol": "ETHBTC",
    "lastPrice": "4.00000200",
    "openPrice": "99.00000000",
    "highPrice": "100.00000000",
    "lowPrice": "0.10000000",
    "volume": "8913.30000000"
 }
]
```

#### Symbol价格

```shell
GET /openapi/quote/v1/ticker/price
```

单个或多个symbol的最新价。

**Weight:** 1

**Parameters:**

> | 名称   | 类型   | 是否强制 | 描述                       |
> | ------ | ------ | -------- | -------------------------- |
> | symbol | string | NO       | Symbol 名称 E.g. `BTCUSDT` |
>

* 如果symbol没有发送，所有symbol的最新价都会被返回。

**Response:**

> | 名称     | 类型   | 例子        | 描述        |
> | -------- | ------ | ----------- | ----------- |
> | `symbol` | string | `ETHBTC`    | Symbol 名称 |
> | `price`  | float  | `4.0000200` | Symbol 价格 |
>

**Response:**

```javascript
{
  "price": "4.00000200"
}
```

OR

```javascript
[
  {
    "symbol": "LTCBTC",
    "price": "4.00000200"
  },
  {
    "symbol": "ETHBTC",
    "price": "0.07946600"
  }
]
```

#### Symbol最佳订单簿价格

```shell
GET /openapi/quote/v1/ticker/bookTicker
```

单个或者多个symbol的最佳买单卖单价格。

**Weight:** 1

**Parameters:**

> | 名称   | 类型   | 是否强制 | 描述                       |
> | ------ | ------ | -------- | -------------------------- |
> | symbol | string | NO       | Symbol 名称 E.g. `BTCUSDT` |
>

* 如果symbol没有被发送，所有symbol的最佳订单簿价格都会被返回。

**Response:**

> | 名称       | 类型   | 例子        | 描述         |
> | ---------- | ------ | ----------- | ------------ |
> | `symbol`   | string | `ETHBTC`    | Symbol 名称  |
> | `bidPrice` | float  | `4.0000000` | 最佳买价     |
> | `bidQty`   | float  | `431`       | 最佳买价数量 |
> | `askPrice` | float  | `4.0000200` | 最佳卖价     |
> | `askQty`   | float  | `9`         | 最佳卖价数量 |
>

**Response:**

```javascript
{
  "symbol": "LTCBTC",
  "bidPrice": "4.00000000",
  "bidQty": "431.00000000",
  "askPrice": "4.00000200",
  "askQty": "9.00000000"
}
```

OR

```javascript
[
  {
    "symbol": "LTCBTC",
    "bidPrice": "4.00000000",
    "bidQty": "431.00000000",
    "askPrice": "4.00000200",
    "askQty": "9.00000000"
  },
  {
    "symbol": "ETHBTC",
    "bidPrice": "0.07946700",
    "bidQty": "9.00000000",
    "askPrice": "100000.00000000",
    "askQty": "1000.00000000"
  }
]
```

#### 现货币对

```shell
GET /openapi/v1/pairs
```

列出所有现货的币对列表，包括baseToken和quoteToken

**Weight:** 1

**Parameters:** NONE

**Response:**

```javascript
[
  {
    "symbol": "LTCBTC",
    "quoteToken": "LTC",
    "baseToken": "BTC"
  },
  {
    "symbol": "BTCUSDT",
    "quoteToken": "BTC",
    "baseToken": "USDT"
  }
]
```

------

# 交易

## 安全类型： [USER_DATA/TRADE]()

**交易**下方的端点需要[签名和API-Key验证]()



#### 创建新订单  (TRADE)

```shell
POST /openapi/v1/order  (HMAC SHA256)
```

发送一个新的订单

**Weight:** 1

**Parameters:**

> | 名称             | 类型    | 是否强制 | 描述                                                         |
> | ---------------- | ------- | -------- | ------------------------------------------------------------ |
> | symbol           | STRING  | YES      | Symbol名称 E.g. `BTCUSDT`                                    |
> | assetType        | STRING  | NO       |                                                              |
> | side             | STRING  | YES      | 订单方向, `BUY/SELL`                                         |
> | type             | STRING  | YES      | 订单类型, `LIMIT/MARKET/LIMIT_MAKER`                         |
> | timeInForce      | STRING  | NO       | 订单时间指令（Time in Force）。默认为`GTC`。可能出现的值为：`GTC`（Good Till Canceled，一直有效），`FOK`（Fill or Kill，全部成交或者取消），`IOC`（Immediate or Cancel，立即成交或者取消） |
> | quantity         | DECIMAL | YES      | 订单数量，对于市价买单（**MARKET BUY**）订单，`quantity`=`amount` |
> | price            | DECIMAL | NO       | 订单价格，对于`LIMIT` 订单**必需**发送                       |
> | newClientOrderId | STRING  | NO       | 一个自己给订单定义的ID，如果没有发送会自动生成。             |
>
> 在`type`上的额外强制参数:
>
> | 类型          | 额外强制参数                       |
> | ------------- | ---------------------------------- |
> | `LIMIT`       | `timeInForce`, `quantity`, `price` |
> | `MARKET`      | `quantity`                         |
> | `LIMIT_MAKER` | `quantity`, `price`                |

**Response:**

> | 名称            | 类型    | 例子            | 描                                                           |
> | --------------- | ------- | --------------- | ------------------------------------------------------------ |
> | `orderId`       | integer | `891`           | 订单ID（系统生成）                                           |
> | `clientOrderId` | integer | `213443`        | 订单ID（自己发送的）                                         |
> | `symbol`        | string  | `BTCUSDT`       | 币对名称                                                     |
> | `transactTime`  | integer | `1273774892913` | 订单创建时间                                                 |
> | `price`         | float   | `4765.29`       | 订单价格                                                     |
> | `origQty`       | float   | `1.01`          | 订单数量                                                     |
> | `executedQty`   | float   | `1.01`          | 已经成交订单数量                                             |
> | `avgPrice`      | float   | `4754.24`       | 订单已经成交的平均价格                                       |
> | `type`          | string  | `LIMIT`         | 订单类型。可能出现的值只能为:`LIMIT`(限价)和`MARKET`（市价） |
> | `side`          | string  | `BUY`           | 订单方向。可能出现的值只能为：`BUY`（买入做多） 和 `SELL`（卖出做空） |
> | `status`        | string  | `NEW`           | 订单状态。可能出现的值为：`NEW`(新订单，无成交)、`PARTIALLY_FILLED`（部分成交）、`FILLED`（全部成交）、`CANCELED`（已取消）和`REJECTED`（订单被拒绝）. |
> | `timeInForce`   | string  | `GTC`           | 订单时间指令（Time in Force）。可能出现的值为：`GTC`（Good Till Canceled，一直有效），`FOK`（Fill or Kill，全部成交或者取消），`IOC`（Immediate or Cancel，立即成交或者取消）. |

**Response:**

```javascript
{
    'symbol': 'LXTUSDT', 
    'orderId': '494736827050147840', 
    'clientOrderId': '157371322565051',
    'transactTime': '1573713225668', 
    'price': '0.005452', 
    'origQty': '110', 
    'executedQty': '0', 
    'status': 'NEW',
    'timeInForce': 'GTC', 
    'type': 'LIMIT', 
    'side': 'SELL'
}
```

#### 批量挂单

```shell
POST /openapi/v1/batch-order  (HMAC SHA256)
```

**Parameters:**

> | 名称             | 类型       | 是否强制 | 描述    |
> | ---------------- | ---------- | -------- | ------- |
> | symbol           | string     | YES      |         |
> | side             | string     | YES      |         |
> | type             | string     | YES      |         |
> | quantity         | bigDecimal | YES      |         |
> | price            | bigDecimal | NO       | 默认为0 |
> | assetType        | string     | NO       |         |
> | timeInForce      | string     | NO       |         |
> | newClientOrderId | string     | NO       |         |
> | stopPrice        | bigDecimal | NO       |         |
> | icebergQty       | bigDecimal | NO       |         |
> | recvWindow       | long       | NO       |         |
> | timestamp        | long       | NO       |         |
> | isTest           | boolean    | NO       |         |
> | methodVersion    | string     | NO       |         |
> | orderSource      | string     | NO       |         |

**Response:**

> | 名称            | 类型    | 例子     | 描述                 |
> | --------------- | ------- | -------- | -------------------- |
> | `orderId`       | integer | `891`    | 订单ID（系统生成）   |
> | `clientOrderId` | integer | `213443` | 订单ID（自己发送的） |

#### 创建新测试订单

```shell
POST /openapi/v1/order/test (HMAC SHA256)
```

用signature和recvWindow测试生成新订单。创建和验证一个新订单但是不送入撮合引擎。

**Weight:** 1

**Parameters:**

和 `POST /openapi/v1/order`一样。

**Response:**

```javascript
{}
```

#### 查询订单 

```shell
GET /openapi/v1/order (HMAC SHA256)
```

查询订单状态。

**Weight:** 1

**Parameters:**

> | 名称              | 类型   | 是否强制 | 描述                                            |
> | ----------------- | ------ | -------- | ----------------------------------------------- |
> | orderId           | long   | NO       | 订单Id E.g. `507904211109878016`                |
> | origClientOrderId | string | NO       | 特殊订单Id（用户自己生成）E.g. `12094ahsihsiad` |

Notes:

* 单一 `orderId` 或者 `origClientOrderId` 必须被发送。
* 对于某些历史数据 `cummulativeQuoteQty` 可能会 < 0, 这说明数据当前不可用。

**Response:**

> | 名称            | 类型    | 例子      | 描述                                                         |
> | --------------- | ------- | --------- | ------------------------------------------------------------ |
> | `orderId`       | integer | `891`     | 订单ID（系统生成）                                           |
> | `clientOrderId` | integer | `213443`  | 订单ID（自己发送的）                                         |
> | `symbol`        | string  | `BTCUSDT` | 币对名称                                                     |
> | `price`         | float   | `4765.29` | 订单价格                                                     |
> | `origQty`       | float   | `1.01`    | 订单数量                                                     |
> | `executedQty`   | float   | `1.01`    | 已经成交订单数量                                             |
> | `avgPrice`      | float   | `4754.24` | 订单已经成交的平均价格                                       |
> | `type`          | string  | `LIMIT`   | 订单类型。可能出现的值只能为:`LIMIT`(限价)和`MARKET`（市价） |
> | `side`          | string  | `BUY`     | 订单方向。可能出现的值只能为：`BUY`（买入做多） 和 `SELL`（卖出做空） |
> | `status`        | string  | `NEW`     | 订单状态。可能出现的值为：`NEW`(新订单，无成交)、`PARTIALLY_FILLED`（部分成交）、`FILLED`（全部成交）、`CANCELED`（已取消）和`REJECTED`（订单被拒绝）. |
> | `timeInForce`   | string  | `GTC`     | 订单时间指令（Time in Force）。可能出现的值为：`GTC`（Good Till Canceled，一直有效），`FOK`（Fill or Kill，全部成交或者取消），`IOC`（Immediate or Cancel，立即成交或者取消）. |

**Response:**

```javascript
{
  "symbol": "LTCBTC",
  "orderId": 1,
  "clientOrderId": "9t1M2K0Ya092",
  "price": "0.1",
  "origQty": "1.0",
  "executedQty": "0.0",
  "cummulativeQuoteQty": "0.0",
  "status": "NEW",
  "timeInForce": "GTC",
  "type": "LIMIT",
  "side": "BUY",
  "stopPrice": "0.0",
  "icebergQty": "0.0",
  "time": 1499827319559,
  "updateTime": 1499827319559,
  "isWorking": true
}
```

#### 取消订单 (TRADE)

```shell
DELETE /openapi/v1/order  (HMAC SHA256)
```

取消当前正在交易的订单。

**Weight:** 1

**Parameters:**

> | 名称          | 类型   | 是否强制 | 描述                                            |
> | ------------- | ------ | -------- | ----------------------------------------------- |
> | orderId       | LONG   | NO       | 订单Id E.g. `507904211109878016`                |
> | clientOrderId | STRING | NO       | 特殊订单Id（用户自己生成）E.g. `12094ahsihsiad` |

单一 `orderId` 或者 `clientOrderId`必须被发送。

**Response**

> | 名称            | 类型    | 例子        | 描述                                                         |
> | --------------- | ------- | ----------- | ------------------------------------------------------------ |
> | `accountId`     | long    |             |                                                              |
> | `symbol`        | string  | `BTCUSDT`   | 币对名称                                                     |
> | `orderId`       | integer | `713637304` | 订单ID（系统生成                                             |
> | `clientOrderId` | string  | `213443`    | 订单ID（自己发送的）                                         |
> | `transactTime`  | long    |             |                                                              |
> | `price`         | string  |             |                                                              |
> | `origQty`       | string  |             |                                                              |
> | `executedQty`   | String  |             |                                                              |
> | `status`        | string  | `NEW`       | 订单状态。可能出现的值为：`NEW`(新订单，无成交)、`PARTIALLY_FILLED`（部分成交）、`FILLED`（全部成交）、`CANCELED`（已取消）和`REJECTED`（订单被拒绝） |
> | `timeInForce`   | String  |             |                                                              |
> | `type`          | string  |             |                                                              |
> | `side`          | String  |             |                                                              |

**Response:**

```javascript
{
  "symbol": "LTCBTC",
  "clientOrderId": "tU721112KM",
  "orderId": 1,
  "status": "CANCELED"
}
```

#### 批量撤单：

```
POST /openapi/v1/order/batchSpecifiedCancel  (HMAC SHA256)
```

**Parameters:**

> | 名称           | 类型   | 是否强制 | 描述    |
> | -------------- | ------ | -------- | ------- |
> | orderIds       | long   | NO       | ","间隔 |
> | clientOrderIds | string | NO       | ","间隔 |

**Response:**

> | 名称    | 类型  | 例子 | 描述 |
> | ------- | ----- | ---- | ---- |
> | success | array |      |      |
> | failed  | array |      |      |



#### 当前订单

```shell
GET /openapi/v1/openOrders  (HMAC SHA256)
```

获取当前单个或者多个symbol的当前订单。**注意** 如果没有发送symbol，会返回很多数据。

**Weight:** 1

**Parameters:**

> | 名称    | 类型    | 是否强制 | 描述                             |
> | ------- | ------- | -------- | -------------------------------- |
> | symbol  | string  | NO       | Symbol 名称 E.g. `BTCUSDT`       |
> | orderId | long    | NO       | 订单Id E.g. `507904211109878016` |
> | limit   | integet | NO       | 默认 500; 最多 500.              |

**Notes:**

* 如果`orderId`设定好了，会筛选订单小于`orderId`的。否则会返回最近的订单信息。

**Response:**

> | 名称            | 类型    | 例子      | 描述                                                         |
> | --------------- | ------- | --------- | ------------------------------------------------------------ |
> | `orderId`       | integer | `891`     | 订单ID（系统生成）                                           |
> | `clientOrderId` | integer | `213443`  | 订单ID（自己发送的）                                         |
> | `symbol`        | string  | `BTCUSDT` | 币对名称                                                     |
> | `price`         | float   | `4765.29` | 订单价格                                                     |
> | `origQty`       | float   | `1.01`    | 订单数量                                                     |
> | `executedQty`   | float   | `1.01`    | 已经成交订单数量                                             |
> | `avgPrice`      | float   | `4754.24` | 订单已经成交的平均价格                                       |
> | `type`          | string  | `LIMIT`   | 订单类型。可能出现的值只能为:`LIMIT`(限价)和`MARKET`（市价） |
> | `side`          | string  | `BUY`     | 订单方向。可能出现的值只能为：`BUY`（买入做多） 和 `SELL`（卖出做空） |
> | `status`        | string  | `NEW`     | 订单状态。可能出现的值为：`NEW`(新订单，无成交)、`PARTIALLY_FILLED`（部分成交）、`FILLED`（全部成交）、`CANCELED`（已取消）和`REJECTED`（订单被拒绝）. |
> | `timeInForce`   | string  | `GTC`     | 订单时间指令（Time in Force）。可能出现的值为：`GTC`（Good Till Canceled，一直有效），`FOK`（Fill or Kill，全部成交或者取消），`IOC`（Immediate or Cancel，立即成交或者取消）. |

**Response:**

```javascript
[
  {
    "symbol": "LTCBTC",
    "orderId": 1,
    "clientOrderId": "t7921223K12",
    "price": "0.1",
    "origQty": "1.0",
    "executedQty": "0.0",
    "cummulativeQuoteQty": "0.0",
    "status": "NEW",
    "timeInForce": "GTC",
    "type": "LIMIT",
    "side": "BUY",
    "stopPrice": "0.0",
    "icebergQty": "0.0",
    "time": 1499827319559,
    "updateTime": 1499827319559,
    "isWorking": true
  }
]
```

#### 历史订单 (USER_DATA)

```shell
GET /openapi/v1/historyOrders (HMAC SHA256)
```

获取当前账户的所有订单。亦或是取消的，完全成交的，拒绝的。**注意**如果没有发送symbol，会返回很多数据。

**Weight:** 5

**Parameters:**

> | 名称      | 类型    | 是否强制 | 描述                             |
> | --------- | ------- | -------- | -------------------------------- |
> | symbol    | string  | NO       | Symbol名称 E.g. `BTCUSDT`        |
> | orderId   | long    | NO       | 订单Id E.g. `507904211109878016` |
> | startTime | long    | NO       | 开始时间戳(毫秒ms)               |
> | endTime   | long    | NO       | 结束时间戳(毫秒ms)               |
> | limit     | integer | NO       | Default 500; max 500.            |

**Notes:**

* 如果`orderId`设定好了，会筛选订单小于`orderId`的。否则会返回最近的订单信息。

**Response:**

> | 名称            | 类型    | 例子      | 描述                                                         |
> | --------------- | ------- | --------- | ------------------------------------------------------------ |
> | `orderId`       | integer | `891`     | 订单ID（系统生成）                                           |
> | `clientOrderId` | integer | `213443`  | 订单ID（自己发送的）                                         |
> | `symbol`        | string  | `BTCUSDT` | 币对名称                                                     |
> | `price`         | float   | `4765.29` | 订单价格                                                     |
> | `origQty`       | float   | `1.01`    | 订单数量                                                     |
> | `executedQty`   | float   | `1.01`    | 已经成交订单数量                                             |
> | `avgPrice`      | float   | `4754.24` | 订单已经成交的平均价格                                       |
> | `type`          | string  | `LIMIT`   | 订单类型。可能出现的值只能为:`LIMIT`(限价)和`MARKET`（市价） |
> | `side`          | string  | `BUY`     | 订单方向。可能出现的值只能为：`BUY`（买入做多） 和 `SELL`（卖出做空） |
> | `status`        | string  | `NEW`     | 订单状态。可能出现的值为：`FILLED`（全部成交）、`CANCELED`（已取消）和`REJECTED`（订单被拒绝）. |
> | `timeInForce`   | string  | `GTC`     | 订单时间指令（Time in Force）。可能出现的值为：`GTC`（Good Till Canceled，一直有效），`FOK`（Fill or Kill，全部成交或者取消），`IOC`（Immediate or Cancel，立即成交或者取消）. |

**Response:**

```javascript
[
  {
    "symbol": "LTCBTC",
    "orderId": 1,
    "clientOrderId": "987yjj2Ym",
    "price": "0.1",
    "origQty": "1.0",
    "executedQty": "0.0",
    "cummulativeQuoteQty": "0.0",
    "status": "NEW",
    "timeInForce": "GTC",
    "type": "LIMIT",
    "side": "BUY",
    "stopPrice": "0.0",
    "icebergQty": "0.0",
    "time": 1499827319559,
    "updateTime": 1499827319559,
    "isWorking": true
  }
]
```

------

# 账户

## 安全类型： [USER_DATA/TRADE]()

**账户**下方的端点需要[签名和API-Key验证]()



#### 账户信息 (USER_DATA)

```shell
GET /openapi/v1/account (HMAC SHA256)
```

获取当前账户信息

**Weight:** 5

**Parameters:** NONE

**Response:**

> | Name          | type    | example | description      |
> | ------------- | ------- | ------- | ---------------- |
> | `canTrade`    | boolean |         |                  |
> | `canWithdraw` | boolean |         |                  |
> | `canDeposit`  | boolean |         |                  |
> | `updateTime`  | long    |         |                  |
> | `balances`    | array   |         | 展示余额具体数据 |
>
> In the `balances` field:
>
> | 名称     | 类型   | 例子    | 描述     |
> | -------- | ------ | ------- | -------- |
> | `asset`  | string | `USDT`  | 币种名称 |
> | `free`   | float  | `600.0` | 可用     |
> | `locked` | float  | `100.0` | 冻结     |

**Response:**

```javascript
{
  "canTrade": true,
  "canWithdraw": true,
  "canDeposit": true,
  "updateTime": 123456789,
  "balances": [
    {
      "asset": "BTC",
      "free": "4723846.89208129",
      "locked": "0.00000000"
    },
    {
      "asset": "LTC",
      "free": "4763368.68006011",
      "locked": "0.00000000"
    }
  ]
}
```

#### 账户交易记录 (USER_DATA)

```shell
GET /openapi/v1/myTrades  (HMAC SHA256)
```

获取当前账户历史成交记录

**Weight:** 5

**Parameters:**

> | 名称         | 类型    | 是否强制 | 描述                   |
> | ------------ | ------- | -------- | ---------------------- |
> | symbolId     | string  | NO       |                        |
> | startTime    | long    | NO       |                        |
> | endTime      | long    | NO       |                        |
> | fromId       | long    | NO       |                        |
> | toId         | long    |          |                        |
> | limit        | integet | NO       | Default 500; max 1000. |
> | withIsNormal | String  | NO       |                        |

**Notes:**

* 如果只有`fromId`，会返回订单号小于`fromId`的，倒序排列。

* 如果只有`toId`，会返回订单号小于`toId`的，升序排列。

* 如果同时有`fromId`和`toId`, 会返回订单号在`fromId`和`toId`的，倒序排列。

* 如果`fromId`和`toId`都没有，会返回最新的成交记录，倒序排列。

**Response:**

```javascript
[
  {
    "symbol": "ETHBTC",
    "id": 28457,
    "orderId": 100234,
    "matchOrderId": 109834,
    "price": "4.00000100",
    "qty": "12.00000000",
    "commission": "10.10000000",
    "commissionAsset": "ETH",
    "time": 1499865549590,
    "isBuyer": true,
    "isMaker": false,
    "feeTokenId": "ETH",
    "feeAmount": "0.012"
  }
]
```

#### 账户存款记录 (USER_DATA)

```shell
GET /openapi/v1/depositOrders  (HMAC SHA256)
```

获取当前账户的存款记录

**Weight:** 5

**Parameters:**

> | 名称      | 类型    | 是否强制 | 描述                                              |
> | --------- | ------- | -------- | ------------------------------------------------- |
> | token     | string  | NO       | 默认全部                                          |
> | startTime | long    | NO       |                                                   |
> | endTime   | long    | NO       |                                                   |
> | fromId    | long    | NO       | 从哪个OrderId起开始抓取。默认抓取最新的存款记录。 |
> | limit     | integer | NO       | 默认 500; 最大 1000.                              |

**Notes:**

* 如果`orderId`设定好了，会筛选订单小于`orderId`的。否则会返回最近的订单信息。

**Response:**

> | 名称             | 类型    | 例子                 | 描述                      |
> | ---------------- | ------- | -------------------- | ------------------------- |
> | `time`           | float   | `1565769575929`      | 存款时间戳                |
> | `orderId`        | integer | `428100569859739648` | 订单ID                    |
> | `token`          | string  | `USDT`               | Token 名称                |
> | `address`        | string  |                      | 你的token 地址            |
> | `addressTag`     | string  |                      | 你的token 地址 tag        |
> | `fromAddress`    | string  |                      | 转账发起方 token 地址     |
> | `fromAddressTag` | string  |                      | 转账发起方 token 地址 tag |
> | `quantity`       | float   | `1100`               | 转账数量                  |

**Response:**

```javascript
[
  {
	"orderId": 100234,
	"token": "EOS",
	"address": "deposit2",
	"addressTag": "19012584",
	"fromAddress": "clarkkent",
	"fromAddressTag": "19029901",
	"time": 1499865549590,
	"quantity": "1.01"
  }
]
```

#### 获取某个提币记录 (USER_DATA)

```shell
GET /openapi/v1/withdraw/detail  (HMAC SHA256)
```

获取当前账户的提币记录

**Weight:** 2

**Parameters:**

> | 名称          | 类型   | 是否强制 | 描述                                     |
> | ------------- | ------ | -------- | ---------------------------------------- |
> | orderId       | long   | NO       | orderId和clientOrderId两者必须有一个有值 |
> | clientOrderId | string | NO       | orderId和clientOrderId两者必须有一个有值 |

**Response:**

```javascript
{
    "time":"1536232111669",
    "orderId":"90161227158286336",
    "accountId":"517256161325920",
    "tokenId":"BTC",
    "tokenName":"BTC",
    "address":"0x815bF1c3cc0f49b8FC66B21A7e48fCb476051209",
    "addressExt":"address tag",
    "quantity":"14", // 提币金额
    "arriveQuantity":"14", // 到账金额
    "statusCode":"PROCESSING_STATUS",
    "status":3,
    "txid":"",
    "txidUrl":"",
    "walletHandleTime":"1536232111669",
    "feeTokenId":"BTC",
    "feeTokenName":"BTC",
    "fee":"0.1",
    "requiredConfirmNum":0, // 要求确认数
    "confirmNum":0, // 确认数
    "kernelId":"", // BEAM 和 GRIN 独有
    "isInternalTransfer": false // 是否内部转账
}
```

#### 根据tokenId获取充币地址信息

```shell
GET /openapi/v1/depositAddress  (HMAC SHA256)
```

根据tokenId获取充币地址信息

**Weight:** 1

**Parameters:**

> | 名称      | 类型   | 是否强制 | 描述                                                        |
> | --------- | ------ | -------- | ----------------------------------------------------------- |
> | tokenId   | string | YES      | tokenId                                                     |
> | chainType | string | NO       | chain type, USDT的chainType分别是OMNI ERC20 TRC20，默认OMNI |

**Response:**


```javascript
    {
        "allowDeposit":false,//是否可充值
        "address":"0x815bF1c3cc0f49b8FC66B21A7e48fCb476051209",//地址
        "addressExt":"address tag",
        "minQuantity":"100",//最小金额
        "requiredConfirmNum":1,//到账确认数
        "canWithdrawConfirmNum":12,//提币确认数
        "tokenType":"ERC20_TOKEN"//链类型
    }
```

#### 账户提币记录 (USER_DATA)

```shell
GET /openapi/v1/withdrawalOrders  (HMAC SHA256)
```

获取当前账户的提币记录

**Weight:** 5

**Parameters:**

> | 名称      | 类型   | 是否强制 | 描述                                              |
> | --------- | ------ | -------- | ------------------------------------------------- |
> | token     | STRING | NO       | 默认全部                                          |
> | startTime | LONG   | NO       | 开始时间戳（毫秒）                                |
> | endTime   | LONG   | NO       | 结束时间戳（毫秒）                                |
> | fromId    | LONG   | NO       | 从哪个OrderId起开始抓取。默认抓取最新的存款记录。 |
> | limit     | INT    | NO       | 默认 500; 最大 1000.                              |

**Notes:**

* 如果`orderId`设定好了，会筛选订单小于`orderId`的。否则会返回最近的订单信息。

**Response:**

```javascript
[
    {
        "time":"1536232111669",
        "orderId":"90161227158286336",
        "accountId":"517256161325920",
        "tokenId":"BTC",
        "tokenName":"BTC",
        "address":"0x815bF1c3cc0f49b8FC66B21A7e48fCb476051209",
        "addressExt":"address tag",
        "quantity":"14", // 提币金额
        "arriveQuantity":"14", // 到账金额
        "statusCode":"PROCESSING_STATUS",
        "status":3,
        "txid":"",
        "txidUrl":"",
        "walletHandleTime":"1536232111669",
        "feeTokenId":"BTC",
        "feeTokenName":"BTC",
        "fee":"0.1",
        "requiredConfirmNum":0, // 要求确认数
        "confirmNum":0, // 确认数
        "kernelId":"", // BEAM 和 GRIN 独有
        "isInternalTransfer": false // 是否内部转账
    },
    {
        "time":"1536053746220",
        "orderId":"762522731831527",
        "accountId":"517256161325920",
        "tokenId":"BTC",
        "tokenName":"BTC",
        "address":"fdfasdfeqfas12323542rgfer54135123",
        "addressExt":"EOS tag",
        "quantity":"",
        "arriveQuantity":"10",
        "statusCode":"BROKER_AUDITING_STATUS",
        "status":"2",
        "txid":"",
        "txidUrl":"",
        "walletHandleTime":"1536232111669",
        "feeTokenId":"BTC",
        "feeTokenName":"BTC",
        "fee":"0.1",
        "requiredConfirmNum":0, // 要求确认数
        "confirmNum":0, // 确认数
        "kernelId":"", // BEAM 和 GRIN 独有
        "isInternalTransfer": false // 是否内部转账
    }
]
```

**提币状态说明**

| status | statusCode                | 描述         |
| :----- | :------------------------ | :----------- |
| 1      | BROKER_AUDITING_STATUS    | 券商审核中   |
| 2      | BROKER_REJECT_STATUS      | 券商审核拒绝 |
| 3      | AUDITING_STATUS           | 平台审核中   |
| 4      | AUDIT_REJECT_STATUS       | 平台审核拒绝 |
| 5      | PROCESSING_STATUS         | 钱包处理中   |
| 6      | WITHDRAWAL_SUCCESS_STATUS | 提币成功     |
| 7      | WITHDRAWAL_FAILURE_STATUS | 提币失败     |
| 8      | BLOCK_MINING_STATUS       | 区块打包中   |

### 用户数据流端点

详细的用户信息流说明在另一个文档中。

#### 开始用户信息流 (USER_STREAM)

```shell
POST /openapi/v1/userDataStream
```

开始一个新的用户信息流。如果keepalive指令没有发送，信息流将将会在60分钟后关闭。

**Weight:** 1

**Parameters:**

> | 名称       | 类型 | 是否强制 | 描述 |
> | ---------- | ---- | -------- | ---- |
> | recvWindow | long | NO       |      |
> | timestamp  | Long | YES      |      |

**Response:**

```javascript
{
  "listenKey": "1A9LWJjuMwKWYP4QQPw34GRm8gz3x5AephXSuqcDef1RnzoBVhEeGE963CoS1Sgj"
}
```

#### Keepalive用户信息流 (USER_STREAM)

```shell
PUT /openapi/v1/userDataStream
```

维持用户信息流来防止断开连接。用户信息流会在60分钟后自动中断，所以建议30分钟发送一次ping请求。

**Weight:** 1

**Parameters:**

> | 名称       | 类型   | 是否强制 | 描述 |
> | ---------- | ------ | -------- | ---- |
> | listenKey  | string | YES      |      |
> | recvWindow | long   | NO       |      |
> | timestamp  | Long   | YES      |      |

**Response:**

```javascript
{}
```

#### 关闭用户信息流 (USER_STREAM)

```shell
DELETE /openapi/v1/userDataStream
```

关闭用户信息流

**Weight:** 1

**Parameters:**

> | 名称       | 类型   | 是否强制 | 描述 |
> | ---------- | ------ | -------- | ---- |
> | listenKey  | string | YES      |      |
> | recvWindow | long   | NO       |      |
> | timestamp  | long   | YES      |      |

**Response:**

```javascript
{}
```

#### 子账户列表(SUB_ACCOUNT_LIST)

```shell
POST /openapi/v1/subAccount/query
```

查询子账户列表

**Parameters:** NONE

**Weight:** 5

**Response:**

```javascript
[
    {
        "accountId": "122216245228131",
        "accountName": "",
        "accountType": 1,
        "accountIndex": 0 // 账户index 0 默认账户 >0, 创建的子账户
    },
    {
        "accountId": "482694560475091200",
        "accountName": "createSubAccountByCurl", // 子账户名称
        "accountType": 1, // 子账户类型 1 币币账户 3 合约账户
        "accountIndex": 1
    },
    {
        "accountId": "422446415267060992",
        "accountName": "",
        "accountType": 3,
        "accountIndex": 0
    },
    {
        "accountId": "482711469199298816",
        "accountName": "createSubAccountByCurl",
        "accountType": 3,
        "accountIndex": 1
    },
]
```


#### 账户内转账 (ACCOUNT_TRANSFER)

```shell
POST /openapi/v1/transfer
```

转账

**Weight:** 1

**Parameters:**

> | 名称             | 类型   | 是否强制 | 描述                                                     |
> | ---------------- | ------ | -------- | -------------------------------------------------------- |
> | fromAccountType  | int    | YES      | 源账户类型, 1 钱包(币币)账户 2 期权账户 3 合约账户       |
> | fromAccountIndex | int    | YES      | 子账户index, 主账户Api调用时候有用，从子账户列表接口获取 |
> | toAccountType    | int    | YES      | 目标账户类型, 1 钱包(币币)账户 2 期权账户 3 合约账户     |
> | toAccountIndex   | int    | YES      | 子账户index, 主账户Api调用时候有用，从子账户列表接口获取 |
> | tokenId          | STRING | YES      | tokenID                                                  |
> | amount           | STRING | YES      | 转账数量                                                 |

**Response:**

```javascript
{
    "success":"true" // 0成功
}
```

**说明**

1、转账账户和收款账户的其中一方，必须是主账户(钱包账户)

2、主账户Api可以从钱包账户向其他账户(包括子账户)转账，也可以从其他账户向钱包账户转账

3、**子账户Api调用的时候只能从当前子账户向主账户(钱包账户)转账，所以fromAccountType\fromAccountIndex\toAccountType\toAccountIndex不用填**


#### 查询流水 (BALANCE_FLOW)

```shell
POST /openapi/v1/balance_flow
```

查询账户流水

**Weight:** 5

**Parameters:**

> | 名称         | 类型    | 是否强制 | 描述                    |
> | ------------ | ------- | -------- | ----------------------- |
> | accountType  | int     | NO       | 账户对应的account_type  |
> | accountIndex | int     | NO       | 账户对应的account_index |
> | tokenId      | string  | NO       | token_id                |
> | fromFlowId   | long    | NO       | 顺向查询数据            |
> | endFlowId    | long    | NO       | 反向查询数据            |
> | startTime    | long    | NO       | 开始时间                |
> | endTime      | long    | NO       | 结束时间                |
> | limit        | integer | NO       | 每页记录数              |

**说明**

1、主账户Api可以查询钱包账户或者其他账户(包括子账户，指定**accountType**和**accountIndex**)的流水’

2、子账户Api只能查询当前子账户的流水，所以不用指定**accountType**和**accountIndex**

**Response:**

> | Name          | Type    | Example              | Description                           |
> | ------------- | ------- | -------------------- | ------------------------------------- |
> | id            | integer | `539870570957903104` | Flow id                               |
> | accountId     | integer | `122216245228131`    | 你的 accountId                        |
> | tokenId       | string  | `USDT`               | Token ID                              |
> | tokenId       | string  | `USDT`               | Token 名称, 大部分情况下和TokenId一样 |
> | flowTypeValue | integer | `51`                 | Flow类型值                            |
> | flowType      | string  | `AIRDROP`            | Flow类型                              |
> | flowName      | string  | `Airdrop`            | Flow类型名称                          |
> | change        | float   | `-12.5`              | 此流水的变化数额                      |
> | total         | float   | `782.235`            | 流水结束后的账户余额                  |
> | created       | string  | `1579093587214`      | 流水发生的时间戳（毫秒）              |

**流水类型：**

| 归类                   | 类型参数名                | 类型参数代号 | 解释说明                                       |
| ---------------------- | ------------------------- | ------------ | ---------------------------------------------- |
| 通用流水类             | TRADE                     | 1            | 交易                                           |
| 通用流水类             | FEE                       | 2            | 交易手续费                                     |
| 通用流水类             | TRANSFER                  | 3            | 转账                                           |
| 通用流水类             | DEPOSIT                   | 4            | 充值                                           |
| 衍生品业务             | MAKER_REWARD              | 27           | maker奖励                                      |
| 衍生品业务             | PNL                       | 28           | 期货等的盈亏                                   |
| 衍生品业务             | SETTLEMENT                | 30           | 交割                                           |
| 衍生品业务             | LIQUIDATION               | 31           | 强平                                           |
| 衍生品业务             | FUNDING_SETTLEMENT        | 32           | 期货等的资金费率结算                           |
| 用户子账户之间内部转账 | USER_ACCOUNT_TRANSFER     | 51           | userAccountTransfer 专用，流水没有subjectExtId |
| OTC                    | OTC_BUY_COIN              | 65           | OTC 买入coin                                   |
| OTC                    | OTC_SELL_COIN             | 66           | OTC 卖出coin                                   |
| OTC                    | OTC_FEE                   | 73           | OTC 手续费                                     |
| OTC                    | OTC_TRADE                 | 200          | 旧版 OTC 流水                                  |
| 活动                   | ACTIVITY_AWARD            | 67           | 活动奖励                                       |
| 活动                   | INVITATION_REFERRAL_BONUS | 68           | 邀请返佣                                       |
| 活动                   | REGISTER_BONUS            | 69           | 注册送礼                                       |
| 活动                   | AIRDROP                   | 70           | 空投                                           |
| 活动                   | MINE_REWARD               | 71           | 挖矿奖励                                       |

**Response:**

```javascript
[
    {
        "id": "539870570957903104",
        "accountId": "122216245228131",
        "tokenId": "BTC",
        "tokenName": "BTC",
        "flowTypeValue": 51, // 流水类型
        "flowType": "USER_ACCOUNT_TRANSFER", // 流水类型名称
        "flowName": "Transfer", // 流水类型说明
        "change": "-12.5", // 变动值
        "total": "379.624059937852365", // 变动后当前tokenId总资产
        "created": "1579093587214"
    },
    {
        "id": "536072393645448960",
        "accountId": "122216245228131",
        "tokenId": "USDT",
        "tokenName": "USDT",
        "flowTypeValue": 7,
        "flowType": "AIRDROP",
        "flowName": "Airdrop",
        "change": "-2000",
        "total": "918662.0917630848",
        "created": "1578640809195"
    }
]
```

#### 提现

```shell
POST /openapi/v1/withdraw
```

提现

**Weight:** 1

**Parameters:**

> | 名称             | 类型   | 是否强制 | 描述                                                         |
> | ---------------- | ------ | -------- | ------------------------------------------------------------ |
> | tokenId          | string | YES      | TokenId。E.g. BTC、ETH..                                     |
> | clientOrderId    | long   | YES      | 券商端生成的订单id， 防止重复提币                            |
> | address          | string | YES      | 提币地址(注意：提现地址必须是在PC端或者APP端维护在常用地址列表里面的地址) |
> | addressExt       | string | NO       | EOS tag                                                      |
> | withdrawQuantity | string | YES      | 提币数量                                                     |
> | chainType        | string | NO       | chain type, USDT的chainType分别是`OMNI` `ERC20` `TRC20`，默认`OMNI` |

**Response:**

```javascript
    {
        "status": 0,
        "success": true,
        "needBrokerAudit": false, // 是否需要券商审核
        "orderId": "423885103582776064" // 提币成功订单id
    }
```

**说明**

1、主账户Api可以查询钱包账户或者其他账户(包括子账户，指定accountType和accountIndex)的流水’

2、子账户Api只能查询当前子账户的流水，所以不用指定accountType和accountIndex

**流水类型说明请见如下**

| 归类                   | 类型参数名                | 类型参数代号 | 解释说明                                       |      |
| ---------------------- | ------------------------- | ------------ | ---------------------------------------------- | ---- |
| 通用流水类             | TRADE                     | 1            | 交易                                           |      |
| 通用流水类             | FEE                       | 2            | 交易手续费                                     |      |
| 通用流水类             | TRANSFER                  | 3            | 转账                                           |      |
| 通用流水类             | DEPOSIT                   | 4            | 充值                                           |      |
| 衍生品业务             | MAKER_REWARD              | 27           | maker奖励                                      |      |
| 衍生品业务             | PNL                       | 28           | 期货等的盈亏                                   |      |
| 衍生品业务             | SETTLEMENT                | 30           | 交割                                           |      |
| 衍生品业务             | LIQUIDATION               | 31           | 强平                                           |      |
| 衍生品业务             | FUNDING_SETTLEMENT        | 32           | 期货等的资金费率结算                           |      |
| 用户子账户之间内部转账 | USER_ACCOUNT_TRANSFER     | 51           | userAccountTransfer 专用，流水没有subjectExtId |      |
| OTC                    | OTC_BUY_COIN              | 65           | OTC 买入coin                                   |      |
| OTC                    | OTC_SELL_COIN             | 66           | OTC 卖出coin                                   |      |
| OTC                    | OTC_FEE                   | 73           | OTC 手续费                                     |      |
| OTC                    | OTC_TRADE                 | 200          | 旧版 OTC 流水                                  |      |
| 活动                   | ACTIVITY_AWARD            | 67           | 活动奖励                                       |      |
| 活动                   | INVITATION_REFERRAL_BONUS | 68           | 邀请返佣                                       |      |
| 活动                   | REGISTER_BONUS            | 69           | 注册送礼                                       |      |
| 活动                   | AIRDROP                   | 70           | 空投                                           |      |
| 活动                   | MINE_REWARD               | 71           | 挖矿奖励                                       |      |

### 过滤层

过滤层（filter）定义某个broker的某个symbol的交易规则
过滤层（filter）有两个大类：`symbol filters` 和 `broker filters`

#### Symbol过滤层

##### PRICE_FILTER

`PRICE_FILTER` 定义某个symbol的`price` 精度. 一共有3个部分：

* `minPrice` 定义最小允许的 `price`/`stopPrice`
* `maxPrice` 定义最大允许的 `price`/`stopPrice`.
* `tickSize` 定义`price`/`stopPrice` 可以增加和减少的间隔。

如果要通过`price filter`要求，`price`/`stopPrice`必须满足：

* `price` >= `minPrice`
* `price` <= `maxPrice`
* (`price`-`minPrice`) % `tickSize` == 0

**/brokerInfo格式:**

```javascript
  {
    "filterType": "PRICE_FILTER",
    "minPrice": "0.00000100",
    "maxPrice": "100000.00000000",
    "tickSize": "0.00000100"
  }
```

##### LOT_SIZE

`LOT_SIZE` 过滤层定义某个symbol `quantity`(在拍卖行里又称为"lots"）的精度。 一共有三个部分：

* `minQty` 定义最小允许的  `quantity`/`icebergQty`
* `maxQty` 定义最大允许的  `quantity`/`icebergQty`
* `stepSize`定义`quantity`/`icebergQty`可以增加和减少的间隔。

如果要通过`lot size`要求，`quantity`/`icebergQty`必须满足:

* `quantity` >= `minQty`
* `quantity` <= `maxQty`
* (`quantity`-`minQty`) % `stepSize` == 0

**/brokerInfo格式:**

```javascript
  {
    "filterType": "LOT_SIZE",
    "minQty": "0.00100000",
    "maxQty": "100000.00000000",
    "stepSize": "0.00100000"
  }
```

##### MIN_NOTIONAL

`MIN_NOTIONAL` 过滤层定义某个symbol的名义金额精度。一个订单的名义金额为 `price` * `quantity`.

**/brokerInfo格式:**

```javascript
  {
    "filterType": "MIN_NOTIONAL",
    "minNotional": "0.00100000"
  }
```

