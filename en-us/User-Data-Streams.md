# User Data Streams for Broker

## General WSS information

* A User Data Stream `listenKey` is valid for 60 minutes after creation.
* Doing a `PUT` on a `listenKey` will extend its validity for 60 minutes.
* Doing a `DELETE` on a `listenKey` will close the stream.
* User Data Streams are accessed at **/openapi/ws/\<listenKey\>**
* A single connection to api endpoint is only valid for 24 hours; expect to be disconnected at the 24 hour mark
* User data stream payloads are **not guaranteed** to be in order during heavy periods; **make sure to order your updates using E**

## API Endpoints

### Create a listenKey

```shell
POST /openapi/v1/userDataStream
```

Start a new user data stream. The stream will close after 60 minutes unless a keepalive is sent.

**Weight:**1

**Parameters:**

> Name | Type | Mandatory | Description
> ------------ | ------------ | ------------ | ------------
> recvWindow | LONG | NO |
> timestamp | LONG | YES |
>

**Response:**

```javascript
{
  "listenKey": "1A9LWJjuMwKWYP4QQPw34GRm8gz3x5AephXSuqcDef1RnzoBVhEeGE963CoS1Sgj"
}
```

### Ping/Keep-alive a listenKey

```shell
PUT /openapi/v1/userDataStream
```

Keepalive a user data stream to prevent a time out. User data streams will close after 60 minutes. It's recommended to send a ping about every 30 minutes.

**Weight:**1

**Parameters:**

> Name | Type | Mandatory | Description
> ------------ | ------------ | ------------ | ------------
> listenKey | STRING | YES |
>

**Response:**

```javascript
{}
```

### Close a listenKey

```shell
DELETE /openapi/v1/userDataStream
```

Close out a user data stream.

**Weight:**1

**Parameters:**

> Name | Type | Mandatory | Description
> ------------ | ------------ | ------------ | ------------
> listenKey | STRING | YES |
>

**Response:**

```javascript
{}
```

## Web Socket Payloads

### Account Update

Account state is updated with the `outboundAccountInfo` event.

**Payload:**

```javascript
{
  "e": "outboundAccountInfo",   // Event type
  "E": 1499405658849,           // Event time
  // "m": 0,                       // Maker commission rate (bips)
  // "t": 0,                       // Taker commission rate (bips)
  // "b": 0,                       // Buyer commission rate (bips)
  // "s": 0,                       // Seller commission rate (bips)
  "T": true,                    // Can trade?
  "W": true,                    // Can withdraw?
  "D": true,                    // Can deposit?
  // "u": 1499405658848,           // Time of last account update
  "B": [                        // Balances changed
    {
      "a": "LTC",               // Asset
      "f": "17366.18538083",    // Free amount
      "l": "0.00000000"         // Lockedtr amount
    }
  ]
}
```

### Order Update

Orders are updated with the `executionReport` event. Check the API documentation and below for relevant enum definitions.
Average price can be found by doing `Z` divided by `z`.

**Payload:**

```javascript
{
  "e": "executionReport",        // Event type
  "E": 1499405658658,            // Event time
  "s": "ETHBTC",                 // Symbol
  "c": 1000087761,               // Client order ID
  "S": "BUY",                    // Side
  "o": "LIMIT",                  // Order type
  "f": "GTC",                    // Time in force
  "q": "1.00000000",             // Order quantity
  "p": "0.10264410",             // Order price
  // "P": "0.00000000",             // Stop price
  // "F": "0.00000000",             // Iceberg quantity
  // "g": -1,                       // Ignore
  // "x": "NEW",                    // Current execution type
  "X": "NEW",                    // Current order status
  // "r": "NONE",                   // Order reject reason; will be an error code.
  "i": 4293153,                  // Order ID
  "l": "0.00000000",             // Last executed quantity
  "z": "0.00000000",             // Cumulative filled quantity
  "L": "0.00000000",             // Last executed price
  "n": "0",                      // Commission amount
  "N": null,                     // Commission asset
  "u": true,                     // Is the trade normal, ignore for now
  // "T": 1499405658657,            // Transaction time
  // "t": -1,                       // Trade ID
  // "I": 8641984,                  // Ignore
  "w": true,                     // Is the order working? Stops will have
  "m": false,                    // Is this trade the maker side?
  // "M": false,                    // Ignore
  "O": 1499405658657,            // Order creation time
  "Z": "0.00000000"              // Cumulative quote asset transacted quantity
}
```

##### Contract:

```javascript
{
    'e': 'contractExecutionReport',         // Event type
    'E': '1590553032232',         // Event time
    's': 'BTC-PERP-BUSDT',         // Symbol
    'c': 'abc123456',  // Client Order ID
    'S': 'SELL',        // Sidee
    'o': 'LIMIT',         // Order Type
    'f': 'IOC',         //  Time in Force
    'q': '2',         // Order Quantity
    'p': '8839.6',     // Order Price
    'X': 'FILLED',     // Current Order Status
    'i': '635999362524162048',         // Order Id
    // 'M': '',         // Ignore
    'l': '2',         // Last executed quantity
    'z': '2',         // Cumulative filled quantity
    'L': '8839.6',         // Last executed price
    'n': '0',         // Commission amount
    'N': 'BUSDT',         // Commission Token Name 
    'u': false,         // Is the trade normal, ignore for now
    'w': true,         // Is the order working? For stop orders
    'm': false,         // Is this trade the maker side?
    'O': '1590553032163',         // Order creation time
    'Z': '17679.2',         // Cumulative quote asset transacted quantity
    // 'A': '',        //Ignore
    'C': True,         // Is this a "close" order?
    'v': '3'        // Leverage
    }
```

**Execution types:**

* NEW
* PARTIALLY_FILLED
* FILLED
* CANCELED
* REJECTED

## Position Update

**Payload:**

```javascript
{
  "e": "outboundContractPositionInfo",  // Event type
  "A": "448992579076322903",            // Contract account id
  "s": "BTC-SWAP-USDT",                 // Contract symbol
  "S": "LONG",                          // Position direction
  "p": "9851.5",                        // avg price
  "P": "269",                           // Position total
  "a": "269",                           // Position avaiable
  "f": "7705.9",                        // flp
  "m": "59.7884",                       // margin
  "r": "-0.0139"                        // realized pnl
}
```

