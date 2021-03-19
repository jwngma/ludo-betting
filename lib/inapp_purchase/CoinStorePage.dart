//import 'dart:async';
//import 'dart:io';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:in_app_purchase/in_app_purchase.dart';
//
//import 'package:ludobettings/models/inAppTransactionModel.dart';
//import 'package:ludobettings/services/firestore_services.dart';
//import 'package:ludobettings/wallet/SuccesfulPurchase.dart';
//import 'package:provider/provider.dart';
//
//const bool kAutoConsume = true;
//
//const String _kConsumableId = 'silver_entry_coinn';
//
//// TODO: Please Add your android product ID here
//const List<String> _kAndroidProductIds = <String>[
//  'basic_entry_coin',
//  'bronze_entry_coin',
//  'silver_entry_coin',
//  'gold_entry_coin',
//  'diamond_entry_coin'
//];
//int entry_coin;
//
//class CoinStorePage extends StatefulWidget {
//  static const String routeName = "/CoinStorePage";
//
//  @override
//  _CoinStorePageState createState() => _CoinStorePageState();
//}
//
//class _CoinStorePageState extends State<CoinStorePage> {
//  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
//  StreamSubscription<List<PurchaseDetails>> _subscription;
//  List<String> _notFoundIds = [];
//  List<ProductDetails> _products = [];
//  FirestoreServices fireStoreServices = FirestoreServices();
//  bool _isAvailable = false;
//  bool _purchasePending = false;
//  bool _loading = true;
//  String _queryProductError;
//
//  @override
//  void initState() {
//    DateTime currentDate = DateTime.now();
//    var fiftyDaysFromNow = currentDate.add(new Duration(days: 50));
//    print(
//        '${fiftyDaysFromNow.month} - ${fiftyDaysFromNow.day} - ${fiftyDaysFromNow.year} ${fiftyDaysFromNow.hour}:${fiftyDaysFromNow.minute}');
//
//    Stream purchaseUpdated =
//        InAppPurchaseConnection.instance.purchaseUpdatedStream;
//    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
//      _listenToPurchaseUpdated(purchaseDetailsList);
//    }, onDone: () {
//      _subscription.cancel();
//    }, onError: (error) {
//      // handle error here.
//    });
//    initStoreInfo();
//    SystemChannels.textInput.invokeMethod('TextInput.hide');
//    _getEntryCoins();
//    super.initState();
//  }
//
//  _getEntryCoins() async {
//    var firestoreServices =
//        Provider.of<FirestoreServices>(context, listen: false);
//    int available_entry_coins = await firestoreServices.getEntryCoin();
//    setState(() {
//      entry_coin = available_entry_coins;
//    });
//  }
//
//  Future<void> initStoreInfo() async {
//    final bool isAvailable = await _connection.isAvailable();
//
//    if (!isAvailable) {
//      setState(() {
//        _isAvailable = isAvailable;
//        _products = [];
//        _notFoundIds = [];
//        _purchasePending = false;
//        _loading = false;
//      });
//      return;
//    }
//
//    ProductDetailsResponse productDetailResponse =
//        await _connection.queryProductDetails(_kAndroidProductIds.toSet());
//    if (productDetailResponse.error != null) {
//      setState(() {
//        _queryProductError = productDetailResponse.error.message;
//        _isAvailable = isAvailable;
//        _products = productDetailResponse.productDetails;
//        _notFoundIds = productDetailResponse.notFoundIDs;
//        _purchasePending = false;
//        _loading = false;
//      });
//      return;
//    }
//
//    if (productDetailResponse.productDetails.isEmpty) {
//      setState(() {
//        _queryProductError = null;
//        _isAvailable = isAvailable;
//        _products = productDetailResponse.productDetails;
//        _notFoundIds = productDetailResponse.notFoundIDs;
//        _purchasePending = false;
//        _loading = false;
//      });
//      return;
//    }
//
//    final QueryPurchaseDetailsResponse purchaseResponse =
//        await _connection.queryPastPurchases();
//    if (purchaseResponse.error != null) {
//      // handle query past purchase error..
//    }
//    final List<PurchaseDetails> verifiedPurchases = [];
//    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
//      if (await _verifyPurchase(purchase)) {
//        verifiedPurchases.add(purchase);
//      }
//    }
//    setState(() {
//      _isAvailable = isAvailable;
//      _products = productDetailResponse.productDetails;
//      _notFoundIds = productDetailResponse.notFoundIDs;
//      _purchasePending = false;
//      _loading = false;
//    });
//  }
//
//  @override
//  void dispose() {
//    _subscription.cancel();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    List<Widget> stack = [];
//
//    if (_queryProductError == null) {
//      stack.add(
//        ListView(
//          children: [
//            SizedBox(
//              height: 10,
//            ),
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Container(
//                height: 100,
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(20),
//                    color: Colors.grey),
//                child: Center(
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Center(
//                        child: Row(
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Center(
//                                child: Text(
//                              "Available Entry Coins:\n in Account",
//                              textAlign: TextAlign.center,
//                              style:
//                                  TextStyle(color: Colors.white, fontSize: 18),
//                            )),
//                            SizedBox(
//                              width: 10,
//                            ),
//                            Center(
//                              child: Text(
//                                entry_coin == 0 ? "0" : "$entry_coin ",
//                                style: TextStyle(
//                                    color: Colors.white, fontSize: 18),
//                              ),
//                            ),
//                            IconButton(
//                                icon: Icon(
//                                  FontAwesomeIcons.coins,
//                                  color: Colors.purpleAccent,
//                                ),
//                                onPressed: () {})
//                          ],
//                        ),
//                      ),
//                      Text(
//                        entry_coin == 0
//                            ? "Wait For Few Seconds To get loaded"
//                            : "Loaded",
//                        style: TextStyle(color: Colors.white, fontSize: 8),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//            ),
//            SizedBox(
//              height: 10,
//            ),
//            _buildConnectionCheckTile(),
//            _buildProductList(),
//            SizedBox(
//              height: 10,
//            ),
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Text(
//                "Note- This Coins can be used only to join the \nevents, they cannot be redemed to your wallets",
//                textAlign: TextAlign.center,
//                style: TextStyle(
//                  color: Colors.red,
//                  fontSize: 10,
//                ),
//              ),
//            )
//          ],
//        ),
//      );
//    } else {
//      stack.add(Center(
//        child: Text(_queryProductError),
//      ));
//    }
//    if (_purchasePending) {
//      stack.add(
//        Stack(
//          children: [
//            Opacity(
//              opacity: 0.3,
//              child: const ModalBarrier(dismissible: false, color: Colors.grey),
//            ),
//            Center(
//              child: CircularProgressIndicator(),
//            ),
//          ],
//        ),
//      );
//    }
//
//    return Scaffold(
//      backgroundColor: Colors.white,
//      body: Stack(
//        children: stack,
//      ),
//    );
//  }
//
//  Card _buildConnectionCheckTile() {
//    if (_loading) {
//      return Card(child: ListTile(title: const Text('Trying to connect...')));
//    }
//    final List<Widget> children = <Widget>[];
//
//    if (!_isAvailable) {
//      children.addAll([
//        Divider(),
//        ListTile(
//          title: Text('Not connected',
//              style: TextStyle(color: ThemeData.light().errorColor)),
//          subtitle: const Text(
//              'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.'),
//        ),
//      ]);
//    }
//    return Card(child: Column(children: children));
//  }
//
//  Card _buildProductList() {
//    if (_loading) {
//      return Card(
//          child: (ListTile(
//              leading: CircularProgressIndicator(),
//              title: Text('Fetching products...'))));
//    }
//    if (!_isAvailable) {
//      return Card();
//    }
//    final ListTile productHeader = ListTile(
//        title: Text(
//      'Entry Coins for Sale',
//      style: TextStyle(
//          fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
//      textAlign: TextAlign.center,
//    ));
//    List<ListTile> productList = <ListTile>[];
//    if (_notFoundIds.isNotEmpty) {
//      productList.add(ListTile(
//          title: Text('[${_notFoundIds.join(", ")}] not found',
//              style: TextStyle(color: ThemeData.light().errorColor)),
//          subtitle: Text(
//              'This app needs special configuration to run. Please see example/README.md for instructions.')));
//    }
//    productList.addAll(_products.map(
//      (ProductDetails productDetails) {
//        return ListTile(
//            title: Text(
//              productDetails.title,
//              style: TextStyle(fontSize: 15, color: Colors.red),
//            ),
//            subtitle: Text(
//              productDetails.description,
//              style: TextStyle(fontSize: 12, color: Colors.yellow),
//            ),
//            trailing: FlatButton(
//              child: Text(productDetails.price),
//              color: Colors.green[800],
//              textColor: Colors.white,
//              onPressed: () {
//                PurchaseParam purchaseParam = PurchaseParam(
//                    productDetails: productDetails,
//                    applicationUserName: null,
//                    sandboxTesting: false);
//                _connection.buyConsumable(
//                    purchaseParam: purchaseParam,
//                    autoConsume: kAutoConsume || Platform.isIOS);
//              },
//            ));
//      },
//    ));
//
//    return Card(
//        child: Column(
//            children: <Widget>[
//                  productHeader,
//                  Divider(
//                    color: Colors.white,
//                  )
//                ] +
//                productList));
//  }
//
//  void showPendingUI() {
//    setState(() {
//      _purchasePending = true;
//    });
//  }
//
//  void deliverProduct(PurchaseDetails purchaseDetails) async {
//    if (purchaseDetails.status.toString() == "PurchaseStatus.purchased") {
//      InAppTransactionModel inAppTransactionModel = InAppTransactionModel(
//        purchaseID: purchaseDetails.purchaseID,
//        transactionDate: purchaseDetails.transactionDate,
//        status: purchaseDetails.status.toString(),
//        productID: purchaseDetails.productID,
//        pendingCompletePurchase: purchaseDetails.pendingCompletePurchase,
//      );
//
//      print('status :' + inAppTransactionModel.status); // La
//      print('transactionDate :' + inAppTransactionModel.transactionDate); // La
//      print('purchaseID :' + inAppTransactionModel.purchaseID); // La// st
//      if (purchaseDetails.productID == "basic_entry_coin") {
//        fireStoreServices
//            .addTransactionsNew(context, inAppTransactionModel, 50)
//            .then((value) {
//          Navigator.push(context, MaterialPageRoute(builder: (context) {
//            return SuccesfulPurchase(
//              amount: 50,
//              transactionId: purchaseDetails.purchaseID,
//              desc: "You have siccessfuly added 50 coins",
//              done: purchaseDetails.pendingCompletePurchase,
//            );
//          }));
//
////          showDialog(
////              context: context,
////              barrierDismissible: false,
////              builder: (context) => PaymentSuccess(
////                    title: "Coins Added Successfully",
////                    description: "You have Successfully bought 50 Entry coins",
////                    primaryButtonText: "Ok",
////                    primaryButtonRoute: RedeemScreen.routeName,
////                  ));
//        });
//      } else if (purchaseDetails.productID == "bronze_entry_coin") {
//        fireStoreServices
//            .addTransactionsNew(context, inAppTransactionModel, 100)
//            .then((value) {
//          Navigator.push(context, MaterialPageRoute(builder: (context) {
//            return SuccesfulPurchase(
//              amount: 100,
//              transactionId: purchaseDetails.purchaseID,
//              desc: "You have siccessfuly added 50 coins",
//              done: purchaseDetails.pendingCompletePurchase,
//            );
//          }));
////          showDialog(
////              context: context,
////              barrierDismissible: false,
////              builder: (context) => PaymentSuccess(
////                    title: "Coins Added Successfully",
////                    description: "You have Successfully bought 100 Entry coins",
////                    primaryButtonText: "Ok",
////                    primaryButtonRoute: RedeemScreen.routeName,
////                  ));
//        });
//      } else if (purchaseDetails.productID == "silver_entry_coin") {
//        fireStoreServices
//            .addTransactionsNew(context, inAppTransactionModel, 200)
//            .then((value) {
//          Navigator.push(context, MaterialPageRoute(builder: (context) {
//            return SuccesfulPurchase(
//              amount: 200,
//              transactionId: purchaseDetails.purchaseID,
//              desc: "You have siccessfuly added 50 coins",
//              done: purchaseDetails.pendingCompletePurchase,
//            );
//          }));
////          showDialog(
////              context: context,
////              barrierDismissible: false,
////              builder: (context) => PaymentSuccess(
////                    title: "Coins Added Successfully",
////                    description: "You have Successfully bought 200 Entry coins",
////                    primaryButtonText: "Ok",
////                    primaryButtonRoute: RedeemScreen.routeName,
////                  ));
//        });
//      } else if (purchaseDetails.productID == "gold_entry_coin") {
//        fireStoreServices
//            .addTransactionsNew(context, inAppTransactionModel, 500)
//            .then((value) {
//          Navigator.push(context, MaterialPageRoute(builder: (context) {
//            return SuccesfulPurchase(
//              amount: 500,
//              transactionId: purchaseDetails.purchaseID,
//              desc: "You have siccessfuly added 50 coins",
//              done: purchaseDetails.pendingCompletePurchase,
//            );
//          }));
////          showDialog(
////              context: context,
////              barrierDismissible: false,
////              builder: (context) => PaymentSuccess(
////                    title: "Coins  Added Successfully",
////                    description:
////                        "You have Successfully bought 500 Entry  coins",
////                    primaryButtonText: "Ok",
////                    primaryButtonRoute: RedeemScreen.routeName,
////                  ));
//        });
//      } else if (purchaseDetails.productID == "diamond_entry_coin") {
//        fireStoreServices
//            .addTransactionsNew(context, inAppTransactionModel, 1000)
//            .then((value) {
//          Navigator.push(context, MaterialPageRoute(builder: (context) {
//            return SuccesfulPurchase(
//              amount: 1000,
//              transactionId: purchaseDetails.purchaseID,
//              desc: "You have siccessfuly added 50 coins",
//              done: purchaseDetails.pendingCompletePurchase,
//            );
//          }));
////          showDialog(
////              context: context,
////              barrierDismissible: false,
////              builder: (context) => PaymentSuccess(
////                    title: "Coins Added Successfully",
////                    description:
////                        "You have Successfully bought 1000 Entry coins",
////                    primaryButtonText: "Ok",
////                    primaryButtonRoute: RedeemScreen.routeName,
////                  ));
//        });
//      } else {
//        print(
//            "The Purchase Product detail is : product: ${purchaseDetails.productID} Status: ${purchaseDetails.status.toString()} Transaction date ${purchaseDetails.transactionDate}");
//      }
//    }
//  }
//
//  void handleError(IAPError error) {
//    setState(() {
//      _purchasePending = false;
//    });
//  }
//
//  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
//    print('From _verifyPurchase, Status: ' + purchaseDetails.status.toString());
//    print("From _verifyPurchase ,The Product purchase status is :" +
//        purchaseDetails.status.toString());
//    print("From _verifyPurchase ,The Product purchase Transactiondate is :" +
//        purchaseDetails.transactionDate.toString());
//    return Future<bool>.value(true);
//  }
//
//  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
//    print(
//        '_handleInvalidPurchase Status :' + purchaseDetails.status.toString());
//    print('_handleInvalidPurchase ' + purchaseDetails.purchaseID);
//    print('_handleInvalidPurchase ' + purchaseDetails.transactionDate);
//  }
//
//  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
//    print('_listenToPurchaseUpdated ');
//    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
//      print("Purchase Details: " + purchaseDetails.purchaseID);
//      if (purchaseDetails.status == PurchaseStatus.pending) {
//        showPendingUI();
//      } else {
//        if (purchaseDetails.status == PurchaseStatus.error) {
//          handleError(purchaseDetails.error);
//        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
//          bool valid = await _verifyPurchase(purchaseDetails);
//          if (valid) {
//            deliverProduct(purchaseDetails);
//          } else {
//            _handleInvalidPurchase(purchaseDetails);
//            return;
//          }
//        }
//        if (Platform.isAndroid) {
//          if (!kAutoConsume && purchaseDetails.productID == _kConsumableId) {
//            await InAppPurchaseConnection.instance
//                .consumePurchase(purchaseDetails);
//          }
//        }
//        if (purchaseDetails.pendingCompletePurchase) {
//          await InAppPurchaseConnection.instance
//              .completePurchase(purchaseDetails);
//        }
//      }
//    });
//  }
//}
//
//////import 'dart:async';
//////import 'dart:io';
//////import 'package:flutter/material.dart';
//////import 'package:in_app_purchase/in_app_purchase.dart';
//////import 'package:in_app_purchase/store_kit_wrappers.dart';
//////import 'consumable_store.dart';
//////
//////const bool kAutoConsume = true;
//////
//////const String _kConsumableId = '';
//////const String _kSubscriptionId = '';
//////
//////// TODO: Please Add your android product ID here
//////const List<String> _kAndroidProductIds = <String>[
//////  'basic_entry_coin',
//////  'bronze_entry_coin',
//////  'testin_coin',
//////  'testing_two'
//////];
//////
//////class CoinStorePage extends StatefulWidget {
//////  @override
//////  _CoinStorePageState createState() => _CoinStorePageState();
//////}
//////
//////class _CoinStorePageState extends State<CoinStorePage> {
//////  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
//////  StreamSubscription<List<PurchaseDetails>> _subscription;
//////  List<String> _notFoundIds = [];
//////  List<ProductDetails> _products = [];
//////  List<PurchaseDetails> _purchases = [];
//////  List<String> _consumables = [];
//////  bool _isAvailable = false;
//////  bool _purchasePending = false;
//////  bool _loading = true;
//////  String _queryProductError;
//////
//////  @override
//////  void initState() {
//////    DateTime currentDate = DateTime.now();
//////    DateTime noADDate;
//////
//////    var fiftyDaysFromNow = currentDate.add(new Duration(days: 50));
//////    print(
//////        '${fiftyDaysFromNow.month} - ${fiftyDaysFromNow.day} - ${fiftyDaysFromNow.year} ${fiftyDaysFromNow.hour}:${fiftyDaysFromNow.minute}');
//////
//////    Stream purchaseUpdated =
//////        InAppPurchaseConnection.instance.purchaseUpdatedStream;
//////    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
//////      _listenToPurchaseUpdated(purchaseDetailsList);
//////    }, onDone: () {
//////      _subscription.cancel();
//////    }, onError: (error) {
//////      // handle error here.
//////    });
//////    initStoreInfo();
//////    super.initState();
//////  }
//////
//////  Future<void> initStoreInfo() async {
//////    final bool isAvailable = await _connection.isAvailable();
//////
//////    if (!isAvailable) {
//////      setState(() {
//////        _isAvailable = isAvailable;
//////        _products = [];
//////        _purchases = [];
//////        _notFoundIds = [];
//////        _consumables = [];
//////        _purchasePending = false;
//////        _loading = false;
//////      });
//////      return;
//////    }
//////
//////    ProductDetailsResponse productDetailResponse =
//////        await _connection.queryProductDetails(
//////            _kAndroidProductIds.toSet()); //_kProductIds.toSet());
//////    if (productDetailResponse.error != null) {
//////      setState(() {
//////        _queryProductError = productDetailResponse.error.message;
//////        _isAvailable = isAvailable;
//////        _products = productDetailResponse.productDetails;
//////        _purchases = [];
//////        _notFoundIds = productDetailResponse.notFoundIDs;
//////        _consumables = [];
//////        _purchasePending = false;
//////        _loading = false;
//////      });
//////      return;
//////    }
//////
//////    if (productDetailResponse.productDetails.isEmpty) {
//////      setState(() {
//////        _queryProductError = null;
//////        _isAvailable = isAvailable;
//////        _products = productDetailResponse.productDetails;
//////        _purchases = [];
//////        _notFoundIds = productDetailResponse.notFoundIDs;
//////        _consumables = [];
//////        _purchasePending = false;
//////        _loading = false;
//////      });
//////      return;
//////    }
//////
//////    final QueryPurchaseDetailsResponse purchaseResponse =
//////        await _connection.queryPastPurchases();
//////    if (purchaseResponse.error != null) {
//////      // handle query past purchase error..
//////    }
//////    final List<PurchaseDetails> verifiedPurchases = [];
//////    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
//////      if (await _verifyPurchase(purchase)) {
//////        verifiedPurchases.add(purchase);
//////      }
//////    }
//////    List<String> consumables = await ConsumableStore.load();
//////    setState(() {
//////      _isAvailable = isAvailable;
//////      _products = productDetailResponse.productDetails;
//////      _purchases = verifiedPurchases;
//////      _notFoundIds = productDetailResponse.notFoundIDs;
//////      _consumables = consumables;
//////      _purchasePending = false;
//////      _loading = false;
//////    });
//////  }
//////
//////  @override
//////  void dispose() {
//////    _subscription.cancel();
//////    super.dispose();
//////  }
//////
//////  @override
//////  Widget build(BuildContext context) {
//////    List<Widget> stack = [];
//////    if (_queryProductError == null) {
//////      stack.add(
//////        ListView(
//////          children: [
//////            _buildConnectionCheckTile(),
//////            _buildProductList(),
//////            _buildConsumableBox(),
//////          ],
//////        ),
//////      );
//////    } else {
//////      stack.add(Center(
//////        child: Text(_queryProductError),
//////      ));
//////    }
//////    if (_purchasePending) {
//////      stack.add(
//////        Stack(
//////          children: [
//////            Opacity(
//////              opacity: 0.3,
//////              child: const ModalBarrier(dismissible: false, color: Colors.grey),
//////            ),
//////            Center(
//////              child: CircularProgressIndicator(),
//////            ),
//////          ],
//////        ),
//////      );
//////    }
//////
//////    return MaterialApp(
//////      home: Scaffold(
//////        body: Stack(
//////          children: stack,
//////        ),
//////      ),
//////    );
//////  }
//////
//////  Card _buildConnectionCheckTile() {
//////    if (_loading) {
//////      return Card(child: ListTile(title: const Text('Trying to connect...')));
//////    }
//////    final Widget storeHeader = ListTile(
//////      leading: Icon(_isAvailable ? Icons.check : Icons.block,
//////          color: _isAvailable ? Colors.green : ThemeData.light().errorColor),
//////      title: Text(
//////          'The store is ' + (_isAvailable ? 'available' : 'unavailable') + '.'),
//////    );
//////    final List<Widget> children = <Widget>[storeHeader];
//////
//////    if (!_isAvailable) {
//////      children.addAll([
//////        Divider(),
//////        ListTile(
//////          title: Text('Not connected',
//////              style: TextStyle(color: ThemeData.light().errorColor)),
//////          subtitle: const Text(
//////              'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.'),
//////        ),
//////      ]);
//////    }
//////    return Card(child: Column(children: children));
//////  }
//////
//////  Card _buildProductList() {
//////    if (_loading) {
//////      return Card(
//////          child: (ListTile(
//////              leading: CircularProgressIndicator(),
//////              title: Text('Fetching products...'))));
//////    }
//////    if (!_isAvailable) {
//////      return Card();
//////    }
//////    final ListTile productHeader = ListTile(title: Text('Products for Sale'));
//////    List<ListTile> productList = <ListTile>[];
//////    if (_notFoundIds.isNotEmpty) {
//////      productList.add(ListTile(
//////          title: Text('[${_notFoundIds.join(", ")}] not found',
//////              style: TextStyle(color: ThemeData.light().errorColor)),
//////          subtitle: Text(
//////              'This app needs special configuration to run. Please see example/README.md for instructions.')));
//////    }
//////
//////    // This loading previous purchases code is just a demo. Please do not use this as it is.
//////    // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
//////    // We recommend that you use your own server to verity the purchase data.
//////    Map<String, PurchaseDetails> purchases =
//////        Map.fromEntries(_purchases.map((PurchaseDetails purchase) {
//////      if (purchase.pendingCompletePurchase) {
//////        InAppPurchaseConnection.instance.completePurchase(purchase);
//////      }
//////      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
//////    }));
//////    productList.addAll(_products.map(
//////      (ProductDetails productDetails) {
//////        PurchaseDetails previousPurchase = purchases[productDetails.id];
//////        return ListTile(
//////            title: Text(
//////              productDetails.title,
//////            ),
//////            subtitle: Text(
//////              productDetails.description,
//////            ),
//////            trailing: previousPurchase != null
//////                ? Icon(Icons.check)
//////                : FlatButton(
//////                    child: Text(productDetails.price),
//////                    color: Colors.green[800],
//////                    textColor: Colors.white,
//////                    onPressed: () {
//////                      PurchaseParam purchaseParam = PurchaseParam(
//////                          productDetails: productDetails,
//////                          applicationUserName: null,
//////                          sandboxTesting: false);
//////                      if (productDetails.id == _kConsumableId) {
//////                        _connection.buyConsumable(
//////                            purchaseParam: purchaseParam,
//////                            autoConsume: kAutoConsume || Platform.isIOS);
//////                      } else {
//////                        _connection.buyNonConsumable(
//////                            purchaseParam: purchaseParam);
//////                      }
//////                    },
//////                  ));
//////      },
//////    ));
//////
//////    return Card(
//////        child:
//////            Column(children: <Widget>[productHeader, Divider()] + productList));
//////  }
//////
//////  Card _buildConsumableBox() {
//////    if (_loading) {
//////      return Card(
//////          child: (ListTile(
//////              leading: CircularProgressIndicator(),
//////              title: Text('Fetching consumables...'))));
//////    }
//////    if (!_isAvailable || _notFoundIds.contains(_kConsumableId)) {
//////      return Card();
//////    }
//////    final ListTile consumableHeader =
//////        ListTile(title: Text('Purchased consumables'));
//////    final List<Widget> tokens = _consumables.map((String id) {
//////      return GridTile(
//////        child: IconButton(
//////          icon: Icon(
//////            Icons.stars,
//////            size: 42.0,
//////            color: Colors.orange,
//////          ),
//////          splashColor: Colors.yellowAccent,
//////          onPressed: () => consume(id),
//////        ),
//////      );
//////    }).toList();
//////    return Card(
//////        child: Column(children: <Widget>[
//////      consumableHeader,
//////      Divider(),
//////      GridView.count(
//////        crossAxisCount: 5,
//////        children: tokens,
//////        shrinkWrap: true,
//////        padding: EdgeInsets.all(16.0),
//////      )
//////    ]));
//////  }
//////
//////  Future<void> consume(String id) async {
//////    print('consume id is $id');
//////    await ConsumableStore.consume(id);
//////    final List<String> consumables = await ConsumableStore.load();
//////    setState(() {
//////      _consumables = consumables;
//////    });
//////  }
//////
//////  void showPendingUI() {
//////    setState(() {
//////      _purchasePending = true;
//////    });
//////  }
//////
//////  void deliverProduct(PurchaseDetails purchaseDetails) async {
//////    print('status :' + purchaseDetails.status.toString()); // La
//////    print('transactionDate :' + purchaseDetails.transactionDate); // La
//////    print('purchaseID :' + purchaseDetails.purchaseID); // La// st
//////    // IMPORTANT!! Always verify a purchase purchase details before delivering the product.
//////    if (purchaseDetails.productID == _kConsumableId) {
//////      await ConsumableStore.save(purchaseDetails.purchaseID);
//////      List<String> consumables = await ConsumableStore.load();
//////      setState(() {
//////        _purchasePending = false;
//////        _consumables = consumables;
//////      });
//////    } else {
//////      setState(() {
//////        _purchases.add(purchaseDetails);
//////        _purchasePending = false;
//////      });
//////    }
//////  }
//////
//////  void handleError(IAPError error) {
//////    setState(() {
//////      _purchasePending = false;
//////    });
//////  }
//////
//////  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
//////    // IMPORTANT!! Always verify a purchase before delivering the product.
//////    // For the purpose of an example, we directly return true.
//////    print('From _verifyPurchase, Status: ' + purchaseDetails.status.toString());
//////    print(
//////        "From _verifyPurchase ,The Product purchase status is :" + purchaseDetails.status.toString());
//////    print(
//////        "From _verifyPurchase ,The Product purchase Transactiondate is :" + purchaseDetails.transactionDate.toString());
//////    return Future<bool>.value(true);
//////  }
//////
//////  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
//////    // handle invalid purchase here if  _verifyPurchase` failed.
//////    print(
//////        '_handleInvalidPurchase Status :' + purchaseDetails.status.toString());
//////    print('_handleInvalidPurchase ' + purchaseDetails.purchaseID);
//////    print('_handleInvalidPurchase ' + purchaseDetails.transactionDate);
//////  }
//////
//////  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
//////    print('_listenToPurchaseUpdated ');
//////    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
//////      print("Purchase Details: " + purchaseDetails.purchaseID);
//////      if (purchaseDetails.status == PurchaseStatus.pending) {
//////        showPendingUI();
//////      } else {
//////        if (purchaseDetails.status == PurchaseStatus.error) {
//////          handleError(purchaseDetails.error);
//////        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
//////          bool valid = await _verifyPurchase(purchaseDetails);
//////          if (valid) {
//////            deliverProduct(purchaseDetails);
//////          } else {
//////            _handleInvalidPurchase(purchaseDetails);
//////            return;
//////          }
//////        }
//////        if (Platform.isAndroid) {
//////          if (!kAutoConsume && purchaseDetails.productID == _kConsumableId) {
//////            await InAppPurchaseConnection.instance
//////                .consumePurchase(purchaseDetails);
//////          }
//////        }
//////        if (purchaseDetails.pendingCompletePurchase) {
//////          await InAppPurchaseConnection.instance
//////              .completePurchase(purchaseDetails);
//////        }
//////      }
//////    });
//////  }
//////}
