
import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/domain/models/seller_model.dart';

class OrderDetailsModel {
  int? _id;
  int? _orderId;
  int? _productId;
  int? _sellerId;
  String? _digitalFileAfterSell;
  Product? _productDetails;
  int? _qty;
  double? _price;
  double? _tax;
  String? _taxModel;
  double? _discount;
  String? _deliveryStatus;
  String? _paymentStatus;
  String? _createdAt;
  String? _updatedAt;
  int? _shippingMethodId;
  String? _variant;
  int? _refundReq;
  Seller? _seller;
  List<VerificationImages>? verificationImages;
  Order? order;
  Product? product;
  bool? isExpanded;
  List<DigitalVariation>? digitalVariation;
  ImageFullUrl? digitalFileAfterSellFullUrl;
  ImageFullUrl? digitalFileReadyFullUrl;
  Review? _reviewData;
  double? _bringChangeAmount;



  OrderDetailsModel(
      {int? id,
        int? orderId,
        int? productId,
        int? sellerId,
        String? digitalFileAfterSell,
        Product? productDetails,
        int? qty,
        double? price,
        double? tax,
        String? taxModel,
        double? discount,
        String? deliveryStatus,
        String? paymentStatus,
        String? createdAt,
        String? updatedAt,
        int? shippingMethodId,
        String? variant,
        int? refundReq,
        Seller? seller,
        List<VerificationImages>? verificationImages,
        Order? order,
        Review? review,
        double? bringChangeAmount,


      }) {
    _id = id;
    _orderId = orderId;
    _productId = productId;
    _sellerId = sellerId;
    if(digitalFileAfterSell != null){
      _digitalFileAfterSell = digitalFileAfterSell;
    }
    _productDetails = productDetails;
    _qty = qty;
    _price = price;
    _tax = tax;
    _taxModel = taxModel;
    _discount = discount;
    _deliveryStatus = deliveryStatus;
    _paymentStatus = paymentStatus;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _shippingMethodId = shippingMethodId;
    _variant = variant;
    _refundReq = refundReq;
    if (seller != null) {
      _seller = seller;
    }
    this.verificationImages;
    this.order;
    product;
    isExpanded;
    digitalVariation;
    digitalFileAfterSellFullUrl;
    digitalFileReadyFullUrl;
    _reviewData = review;
    _bringChangeAmount = bringChangeAmount;

  }

  int? get id => _id;
  int? get orderId => _orderId;
  int? get productId => _productId;
  int? get sellerId => _sellerId;
  String? get digitalFileAfterSell => _digitalFileAfterSell;
  Product? get productDetails => _productDetails;
  int? get qty => _qty;
  double? get price => _price;
  double? get tax => _tax;
  String? get taxModel => _taxModel;
  double? get discount => _discount;
  String? get deliveryStatus => _deliveryStatus;
  String? get paymentStatus => _paymentStatus;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get shippingMethodId => _shippingMethodId;
  String? get variant => _variant;
  int? get refundReq => _refundReq;
  Seller? get seller => _seller;
  Review? get reviewModel => _reviewData;
  double? get bringChangeAmount => _bringChangeAmount;


  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _orderId = json['order_id'];
    _productId = json['product_id'];
    _sellerId = json['seller_id'];
    if(json['digital_file_after_sell'] != null) {
      _digitalFileAfterSell = json['digital_file_after_sell'];
    }
    if(json['product_details'] != null) {
      _productDetails = Product.fromJson(json['product_details']);
    }
    _qty = json['qty'];
    _price = json['price'].toDouble();
    _tax = json['tax'].toDouble();
    _taxModel = json['tax_model'];
    _discount = json['discount'].toDouble();
    _deliveryStatus = json['delivery_status'];
    _paymentStatus = json['payment_status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _shippingMethodId = json['shipping_method_id'];
    _variant = json['variant'];
    _refundReq = json['refund_request'];
    _seller = json['seller'] != null ? Seller.fromJson(json['seller']) : null;
    if (json['verification_images'] != null) {
      verificationImages = <VerificationImages>[];
      json['verification_images'].forEach((v) {
        verificationImages!.add(VerificationImages.fromJson(v));
      });
    }
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
    if(json['product'] != null) {
      product = Product.fromJson(json['product']);
    }
    if (json['digital_variation'] != null) {
      digitalVariation = <DigitalVariation>[];
      json['digital_variation'].forEach((v) {
        digitalVariation!.add(DigitalVariation.fromJson(v));
      });
    }

    digitalFileAfterSellFullUrl = json['digital_file_after_sell_full_url'] != null
        ? ImageFullUrl.fromJson(json['digital_file_after_sell_full_url']) : null;


    isExpanded = false;

    if(json['reviewData'] != null) {
      _reviewData = Review.fromJson(json["reviewData"]);

    }

    _bringChangeAmount = double.tryParse('${json['bring_change_amount']}');



  }

}


class VerificationImages {
  int? id;
  int? orderId;
  String? image;
  ImageFullUrl? imageFullUrl;
  String? createdAt;
  String? updatedAt;

  VerificationImages(
      {this.id, this.orderId, this.image, this.imageFullUrl, this.createdAt, this.updatedAt});

  VerificationImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    image = json['image'];
    imageFullUrl = json['image_full_url'] != null
      ? ImageFullUrl.fromJson(json['image_full_url'])
      : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

}

class Order {
  int? isShippingFree;
  String? sellerIs;
  String? status;

  Order({this.isShippingFree, this.sellerIs, this.status});

  Order.fromJson(Map<String, dynamic> json) {
    try{
      isShippingFree = int.parse(json['is_shipping_free'].toString());
    }catch(e){
      isShippingFree = json['is_shipping_free']?1:0;
    }
    sellerIs = json['seller_is'];
    status = json['order_status'];
  }


}

class Review {
  int id;
  int productId;

  Review({
    required this.id,
    required this.productId,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json["id"],
    productId: json["product_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
  };
}
