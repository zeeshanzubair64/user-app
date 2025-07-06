
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/local/cache_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/domain/services/cart_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/domain/models/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/controllers/product_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/shipping/controllers/shipping_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:provider/provider.dart';


class CartController extends ChangeNotifier {
  final CartServiceInterface? cartServiceInterface;
  CartController({required this.cartServiceInterface});

  List<CartModel> _cartList = [];
  List<bool> isSelectedList = [];
  double amount = 0.0;
  bool isSelectAll = true;
  bool _cartLoading = false;
  bool  get cartLoading => _cartLoading;
  CartModel? cart;
  String? _updateQuantityErrorText;
  String? get addOrderStatusErrorText => _updateQuantityErrorText;
  bool _getData = true;
  bool _addToCartLoading = false;
  bool get addToCartLoading => _addToCartLoading;
  List<CartModel> get cartList => _cartList;
  bool get getData => _getData;


  void setCartData(){
    _getData = true;
  }

  void getCartDataLoaded(){
    _getData = false;
  }

  Future<ApiResponse> getCartData(BuildContext context, {bool reload = true}) async {

    var localData =  await database.getCacheResponseById(AppConstants.getCartDataUri);

    if(localData != null) {
      _cartList = [];
      var cartList = jsonDecode(localData.response);
      cartList.forEach((cart) => _cartList.add(CartModel.fromJson(cart)));
      notifyListeners();
    }


    if(reload){
      _cartLoading = true;
    }

    ApiResponse apiResponse = await cartServiceInterface!.getList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _cartList = [];
      apiResponse.response!.data.forEach((cart) => _cartList.add(CartModel.fromJson(cart)));

      if(localData != null  && apiResponse.response != null) {
        await database.updateCacheResponse(AppConstants.getCartDataUri, CacheResponseCompanion(
          endPoint: const Value(AppConstants.getCartDataUri),
          header: Value(jsonEncode(apiResponse.response!.headers.map)),
          response: Value(jsonEncode(apiResponse.response!.data)),
        ));
      } else {
        await database.insertCacheResponse(
          CacheResponseCompanion(
            endPoint: const Value(AppConstants.getCartDataUri),
            header: Value(jsonEncode(apiResponse.response!.headers.map)),
            response: Value(jsonEncode(apiResponse.response!.data)),
          ),
        );
      }
      _cartLoading = false;
    } else {
      _cartLoading = false;
       ApiChecker.checkApi(apiResponse);
    }




    _cartLoading = false;
    notifyListeners();
    return apiResponse;
  }

  bool updatingIncrement = false;
  bool updatingDecrement = false;



  Future<ApiResponse> updateCartProductQuantity(int? key, int quantity, BuildContext context, bool increment, int index) async{
    if(increment){
      cartList[index].increment = true;
    }else{
      cartList[index].decrement = true;
    }
    notifyListeners();
    ApiResponse apiResponse;
    apiResponse = await cartServiceInterface!.updateQuantity(key, quantity);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      cartList[index].increment  = false;
      cartList[index].decrement = false;
      String message = apiResponse.response!.data['message'].toString();
      showCustomSnackBar(message, Get.context!, isError: false);
      await getCartData(Get.context!, reload: false);

    } else {
      cartList[index].increment  = false;
      cartList[index].decrement = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }




  Future<ApiResponse> addToCartAPI(CartModelBody cart, BuildContext context, List<ChoiceOptions> choices, List<int>? variationIndexes, {int buyNow = 0, int? shippingMethodExist, int? shippingMethodId}) async {
    _addToCartLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await cartServiceInterface!.addToCartListData(cart, choices, variationIndexes, buyNow, shippingMethodExist, shippingMethodId);
    _addToCartLoading = false;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Navigator.of(Get.context!).pop();
      _addToCartLoading = false;
      showCustomSnackBar(apiResponse.response!.data['message'], Get.context!, isError: apiResponse.response!.data['status'] == 0, isToaster: true);
      getCartData(Get.context!);
    } else {
      _addToCartLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }


  Future<ApiResponse> restockRequest(CartModelBody cart, BuildContext context, List<ChoiceOptions> choices, List<int>? variationIndexes, {int buyNow = 0, int? shippingMethodExist, int? shippingMethodId, String? variationType}) async {
    _addToCartLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await cartServiceInterface!.restockRequest(cart, choices, variationIndexes, buyNow, shippingMethodExist, shippingMethodId);

    _addToCartLoading = false;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Navigator.of(Get.context!).pop();
      _addToCartLoading = false;
      if(context.mounted) {
        Provider.of<ProductDetailsController>(context, listen: false).updateProductRestock(variantKey: variationType);
      }

      await FirebaseMessaging.instance.subscribeToTopic(apiResponse.response!.data['topic']);
      showCustomSnackBar(apiResponse.response!.data['message'], Get.context!, isError: apiResponse.response!.data['status'] == 0, isToaster: true);
    } else {
      _addToCartLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }


  Future<void> removeFromCartAPI(int? key, int index) async{
    cartList[index].decrement = true;
    notifyListeners();
    ApiResponse apiResponse = await cartServiceInterface!.delete(key!);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      cartList[index].decrement = false;
      getCartData(Get.context!, reload: false);
    } else {
      cartList[index].decrement = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();

  }


  Future<void> addRemoveCartSelectedItem(List<int> ids, bool action) async{
    notifyListeners();
    Map<String, dynamic> data = {
      'ids' : ids,
      'action' : action ? 'checked' : 'unchecked'
    };
    ApiResponse apiResponse = await cartServiceInterface!.addRemoveCartSelectedItem(data);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      await Future.wait([
        Provider.of<ShippingController>(Get.context!, listen: false).getChosenShippingMethod(Get.context!),
        getCartData(Get.context!, reload: false),
      ]);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }


}
