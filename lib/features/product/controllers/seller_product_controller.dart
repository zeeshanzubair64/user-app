import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/local/cache_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/services/seller_product_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/domain/models/shop_again_from_recent_store_model.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class SellerProductController extends ChangeNotifier {
  final SellerProductServiceInterface? sellerProductServiceInterface;
  SellerProductController({required this.sellerProductServiceInterface});


  ProductModel? sellerProduct;
  ProductModel? sellerMoreProduct;

  Future <ApiResponse> getSellerProductList(String sellerId, int offset, String productId, {
    bool reload = true,
    String search = '',
    String? categoryIds = '[]',
    String? brandIds = '[]',
    String? authorIds = '[]',
    String? publishingIds = '[]',
    String? productType = 'all',
  }) async {

    // if(reload) {
    //   sellerProduct = null;
    // }

    ApiResponse apiResponse = await sellerProductServiceInterface!.getSellerProductList(
      sellerId, offset.toString(),
      productId, categoryIds : categoryIds,
      brandIds: brandIds, search: search,
      authorIds: authorIds, publishingIds: publishingIds,
      productType: productType
    );

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if(offset == 1){
        sellerProduct = ProductModel.fromJson(apiResponse.response!.data);
      }else{
        sellerProduct?.products?.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
        sellerProduct?.offset = (ProductModel.fromJson(apiResponse.response!.data).offset!);
        sellerProduct?.totalSize = ProductModel.fromJson(apiResponse.response!.data).totalSize;
      }
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }



  Future <ApiResponse> getSellerMoreProductList(String sellerId, int offset, String productId) async {
    sellerMoreProduct = null;

    ApiResponse apiResponse = await sellerProductServiceInterface!.getSellerProductList( sellerId, offset.toString(), productId );
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if(offset == 1){
        sellerMoreProduct = ProductModel.fromJson(apiResponse.response!.data);
      }
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }


  ProductModel? productModel;
  Future<void> getSellerWiseBestSellingProductList(String sellerId, int offset) async {
      ApiResponse apiResponse = await sellerProductServiceInterface!.getSellerWiseBestSellingProductList(sellerId, offset.toString());
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
          if(offset == 1){
            productModel = null;
            productModel = ProductModel.fromJson(apiResponse.response!.data);
          }else {
            productModel!.products!.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
            productModel!.offset = ProductModel.fromJson(apiResponse.response!.data).offset;
            productModel!.totalSize = ProductModel.fromJson(apiResponse.response!.data).totalSize;
          }
      } else {
        ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();
  }



  ProductModel? sellerWiseFeaturedProduct;
  Future<void> getSellerWiseFeaturedProductList(String sellerId, int offset) async {
    ApiResponse apiResponse = await sellerProductServiceInterface!.getSellerWiseFeaturedProductList(sellerId, offset.toString());
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if(offset == 1){
        sellerWiseFeaturedProduct = null;
        sellerWiseFeaturedProduct = ProductModel.fromJson(apiResponse.response!.data);
      }else {
        sellerWiseFeaturedProduct!.products!.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
        sellerWiseFeaturedProduct!.offset = ProductModel.fromJson(apiResponse.response!.data).offset;
        sellerWiseFeaturedProduct!.totalSize = ProductModel.fromJson(apiResponse.response!.data).totalSize;
      }
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }


  ProductModel? sellerWiseRecommandedProduct;
  Future<void> getSellerWiseRecommandedProductList(String sellerId, int offset) async {
    ApiResponse apiResponse = await sellerProductServiceInterface!.getSellerWiseRecomendedProductList(sellerId, offset.toString());
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if(offset == 1){
        sellerWiseRecommandedProduct = null;
        sellerWiseRecommandedProduct = ProductModel.fromJson(apiResponse.response!.data);
      }else {
        sellerWiseRecommandedProduct!.products!.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
        sellerWiseRecommandedProduct!.offset = ProductModel.fromJson(apiResponse.response!.data).offset;
        sellerWiseRecommandedProduct!.totalSize = ProductModel.fromJson(apiResponse.response!.data).totalSize;
      }
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }


  List<ShopAgainFromRecentStoreModel> shopAgainFromRecentStoreList = [];
  Future<void> getShopAgainFromRecentStore() async {

    final localData =  await database.getCacheResponseById(AppConstants.shopAgainFromRecentStore);

    if(localData != null) {
      final data = jsonDecode(localData.response);

      data.forEach((store) => shopAgainFromRecentStoreList.add(ShopAgainFromRecentStoreModel.fromJson(store)));
      notifyListeners();
    }


    ApiResponse apiResponse = await sellerProductServiceInterface!.getShopAgainFromRecentStoreList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      apiResponse.response?.data.forEach((shopAgain)=> shopAgainFromRecentStoreList.add(ShopAgainFromRecentStoreModel.fromJson(shopAgain)));

      if(localData != null) {
        await database.updateCacheResponse(AppConstants.shopAgainFromRecentStore, CacheResponseCompanion(
          endPoint: const Value(AppConstants.shopAgainFromRecentStore),
          header: Value(jsonEncode(apiResponse.response!.headers.map)),
          response: Value(jsonEncode(apiResponse.response?.data)),
        ));
      } else {
        await database.insertCacheResponse(
          CacheResponseCompanion(
            endPoint: const Value(AppConstants.shopAgainFromRecentStore),
            header: Value(jsonEncode(apiResponse.response!.headers.map)),
            response: Value(jsonEncode(apiResponse.response?.data)),
          ),
        );
      }

    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }




  void clearSellerProducts() {
    sellerWiseFeaturedProduct = null;
    sellerWiseRecommandedProduct = null;
  }

}

