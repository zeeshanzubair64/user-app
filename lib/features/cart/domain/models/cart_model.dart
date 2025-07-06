import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/domain/models/seller_model.dart';
class CartModel {
  int? id;
  int? productId;
  String? image;
  String? name;
  String? thumbnail;
  ImageFullUrl? thumbnailFullUrl;
  int? sellerId;
  String? sellerIs;
  String? seller;
  double? price;
  double? discountedPrice;
  int? quantity;
  int? maxQuantity;
  String? variant;
  String? color;
  Variation? variation;
  double? discount;
  String? discountType;
  double? tax;
  String? taxModel;
  String? taxType;
  int? shippingMethodId;
  String? cartGroupId;
  String? shopInfo;
  List<ChoiceOptions>? choiceOptions;
  List<int>? variationIndexes;
  double?  shippingCost;
  String? shippingType;
  int? minimumOrderQuantity;
  ProductInfo? productInfo;
  String? productType;
  String? slug;
  double? minimumOrderAmountInfo;
  FreeDeliveryOrderAmount? freeDeliveryOrderAmount;
  bool? increment;
  bool? decrement;
  Shop? shop;
  int? isProductAvailable;
  bool? isChecked;
  bool? isGroupChecked;
  bool? isGroupItemChecked;




  CartModel(
      this.id,
      this.productId,
      this.thumbnail,
      this.thumbnailFullUrl,
      this.name,
      this.seller,
      this.price,
      this.discountedPrice,
      this.quantity,
      this.maxQuantity,
      this.variant,
      this.color,
      this.variation,
      this.discount,
      this.discountType,
      this.tax,
      this.taxModel,
      this.taxType,
      this.shippingMethodId,
      this.cartGroupId,
      this.sellerId,
      this.sellerIs,
      this.image,
      this.shopInfo,
      this.choiceOptions,
      this.variationIndexes,
      this.shippingCost,
      this.minimumOrderQuantity,
      this.productType,
      this.slug,
      this.minimumOrderAmountInfo,
      this.freeDeliveryOrderAmount,
      this.increment,
      this.decrement,
      this.shop,
      this.isProductAvailable,
      this.isChecked,
      this.isGroupChecked,
      this.isGroupItemChecked
      );


  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = int.parse(json['product_id'].toString());
    name = json['name'];
    seller = json['seller'];
    thumbnail = json['thumbnail'];
    sellerId = int.parse(json['seller_id'].toString());
    sellerIs = json['seller_is'];
    image = json['image'];
    price = json['price'].toDouble();
    discountedPrice = json['discounted_price'];
    quantity = int.parse(json['quantity'].toString());
    maxQuantity = json['max_quantity'];
    variant = json['variant'];
    color = json['color'];
    variation = json['variation'] != null ? Variation.fromJson(json['variation']) : null;
    discount = json['discount'].toDouble();
    discountType = json['discount_type'];
    tax = json['tax'].toDouble();
    taxModel = json['tax_model'];
    taxType = json['tax_type'];
    shippingMethodId = json['shipping_method_id'];
    cartGroupId = json['cart_group_id'];
    shopInfo = json['shop_info'];
    if (json['choice_options'] != null) {
      choiceOptions = [];
      json['choice_options'].forEach((v) {choiceOptions!.add(ChoiceOptions.fromJson(v));
      });
    }
    variationIndexes = json['variation_indexes'] != null ? json['variation_indexes'].cast<int>() : [];
    if(json['shipping_cost'] != null){
      shippingCost =double.parse(json['shipping_cost'].toString());
    }
    if(json['shipping_type'] != null){
      shippingType = json['shipping_type'];
    }
    productInfo = json['product'] != null ? ProductInfo.fromJson(json['product']) : null;
    productType = json['product_type'];
    slug = json['slug'];
    if(json['minimum_order_amount_info'] != null){
      try{
        minimumOrderAmountInfo = json['minimum_order_amount_info'].toDouble();
      }catch(e){
        minimumOrderAmountInfo = double.parse(json['minimum_order_amount_info'].toString());
      }
    }
    increment = false;
    decrement = false;
    freeDeliveryOrderAmount = json['free_delivery_order_amount'] != null ? FreeDeliveryOrderAmount.fromJson(json['free_delivery_order_amount']) : null;
    shop = json['shop'] != null ? Shop.fromJson(json['shop'], isAdminProduct: json['seller_is'] == 'admin') : null;
    if(json["is_product_available"] != null){
      isProductAvailable = int.parse(json["is_product_available"].toString());
    }else{
      isProductAvailable = 1;
    }

    if(json['is_checked'] != null) {
      isChecked = json['is_checked'] == 1 ? true : false;
    } else {
      isChecked = false;
    }
    thumbnailFullUrl = json['thumbnail_full_url'] != null
        ? ImageFullUrl.fromJson(json['thumbnail_full_url'])
        : null;
    isGroupChecked = false;
    isGroupItemChecked = false;
  }


}

class ProductInfo {
  int? minimumOrderQty;
  int? totalCurrentStock;
  ImageFullUrl? thumbnailFullUrl;

  ProductInfo({ this.minimumOrderQty, this.totalCurrentStock});

  ProductInfo.fromJson(Map<String, dynamic> json) {
    if(json['minimum_order_qty'] != null) {
      try{
        minimumOrderQty = json['minimum_order_qty'];
      }catch(e){
        minimumOrderQty = int.parse(json['minimum_order_qty'].toString());
      }
    }
    totalCurrentStock = json['total_current_stock'];
    thumbnailFullUrl = json['thumbnail_full_url'] != null
        ? ImageFullUrl.fromJson(json['thumbnail_full_url'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['minimum_order_qty'] = minimumOrderQty;
    data['total_current_stock'] = totalCurrentStock;
    return data;
  }
}

class FreeDeliveryOrderAmount {
  int? status;
  double? amount;
  int? percentage;
  double? shippingCostSaved;
  double? amountNeed;


  FreeDeliveryOrderAmount(
      {this.status,
        this.amount,
        this.percentage,
        this.shippingCostSaved,
        this.amountNeed,
        });

  FreeDeliveryOrderAmount.fromJson(Map<String, dynamic> json) {
    status = int.parse(json['status'].toString());
    if(json['amount'] != null){
      amount = json['amount'].toDouble();
    }

    if(json['percentage'] != null){
      percentage = int.parse(json['percentage'].toString());
    }

    if(json['shipping_cost_saved'] != null){
      shippingCostSaved = json['shipping_cost_saved'].toDouble();
    }

    if(json['amount_need'] != null){
      amountNeed = json['amount_need'].toDouble();
    }
  }
}



class CartModelBody{
  int? productId;
  String? variant;
  String? color;
  Variation? variation;
  int? quantity;
  String? variantKey;
  double? digitalVariantPrice;

  CartModelBody(
    {this.productId,
      this.variant,
      this.color,
      this.variation,
      this.quantity,
      this.variantKey,
      this.digitalVariantPrice});
}