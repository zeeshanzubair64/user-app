import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/domain/models/wishlist_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/widgets/remove_from_wishlist_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/screens/product_details_screen.dart';
import 'package:provider/provider.dart';

class WishListWidget extends StatelessWidget {
  final WishlistModel? wishlistModel;
  final int? index;
  const WishListWidget({super.key, this.wishlistModel, this.index});

  @override
  Widget build(BuildContext context) {
    final bool isLtr = Provider.of<LocalizationController>(context, listen: false).isLtr;

    return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        margin: const EdgeInsets.only(top: Dimensions.marginSizeSmall),
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha:0.1), spreadRadius: 1, blurRadius: 7, offset: const Offset(0, 1)),],
            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5)),
        child: IntrinsicHeight(
          child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [
            Stack(children: [
              Container(
                  decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                border: Border.all(width: .5, color: Theme.of(context).primaryColor.withValues(alpha:.25)),),
                child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 90),
                    child: CustomImageWidget(width: 90,
                      image: '${wishlistModel?.productFullInfo!.thumbnailFullUrl?.path}',
                    ),
                  ),
                ),
              ),



              ((wishlistModel?.productFullInfo!.discount != null) || (wishlistModel?.productFullInfo!.clearanceSale != null)) ?
              Positioned(top: Dimensions.paddingSizeSmall, left: isLtr ? 0 : null, right: isLtr ? null : 0,
                  child: Container(height: 20, padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(isLtr ?  Dimensions.paddingSizeExtraSmall : 0),
                        left: Radius.circular(isLtr ? 0 : Dimensions.paddingSizeExtraSmall),
                      ),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text((wishlistModel?.productFullInfo!.clearanceSale != null)
                          ? PriceConverter.percentageCalculation(context, wishlistModel?.productFullInfo!.unitPrice,
                          wishlistModel!.productFullInfo!.clearanceSale?.discountAmount, wishlistModel?.productFullInfo!.clearanceSale?.discountType)
                          : (wishlistModel?.productFullInfo!.unitPrice != null && wishlistModel?.productFullInfo!.discount != null &&
                          wishlistModel?.productFullInfo!.discountType != null)
                          ? PriceConverter.percentageCalculation(context, wishlistModel?.productFullInfo!.unitPrice,
                          wishlistModel!.productFullInfo!.discount, wishlistModel?.productFullInfo!.discountType)
                          : '',
                        style: textRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Colors.white)))) : const SizedBox(),
            ]),
            const SizedBox(width: Dimensions.paddingSizeSmall),
          
          
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(wishlistModel?.productFullInfo?.name ?? '',maxLines: 1,overflow: TextOverflow.ellipsis,
                    style: titilliumSemiBold.copyWith(color: ColorResources.getReviewRattingColor(context),
                        fontSize: Dimensions.fontSizeDefault))),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          
          
                InkWell(onTap: (){showModalBottomSheet(backgroundColor: Colors.transparent,
                    context: context, builder: (_) => RemoveFromWishlistBottomSheet(
                        productId : wishlistModel!.productFullInfo!.id!, index: index!));},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                      child: Image.asset(Images.delete, scale: 3, color: ColorResources.getRed(context).withValues(alpha:.90)))),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),
          
              Row(children: [
                ((wishlistModel?.productFullInfo!.discount != null) || (wishlistModel?.productFullInfo!.clearanceSale != null)) ?
                CustomDirectionalityWidget(
                  child: Text(wishlistModel!.productFullInfo!.unitPrice != null?
                  PriceConverter.convertPrice(context, wishlistModel!.productFullInfo!.unitPrice):'',
                    style: titilliumSemiBold.copyWith(color: ColorResources.getReviewRattingColor(context),
                        decoration: TextDecoration.lineThrough),),
                ):const SizedBox(),


                ((wishlistModel?.productFullInfo!.discount != null) || (wishlistModel?.productFullInfo!.clearanceSale != null)) ?
                const SizedBox(width: Dimensions.paddingSizeSmall):const SizedBox(),

                Flexible(child: CustomDirectionalityWidget(
                    child: Text(
                      PriceConverter.convertPrice(
                        context, wishlistModel!.productFullInfo!.unitPrice,
                        discountType: (wishlistModel!.productFullInfo!.clearanceSale?.discountAmount ?? 0)  > 0
                            ? wishlistModel!.productFullInfo!.clearanceSale?.discountType
                            : wishlistModel!.productFullInfo!.discountType,
                        discount: (wishlistModel!.productFullInfo!.clearanceSale?.discountAmount ?? 0)  > 0
                            ? wishlistModel!.productFullInfo!.clearanceSale?.discountAmount
                            : wishlistModel!.productFullInfo!.discount,
                      ),
                      style: robotoBold.copyWith(color: Theme.of(context).primaryColor),
                    ),
                )),





              ]),
          
          
              Row(children: [
                const Spacer(),
          
                Padding(
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                  child: InkWell(
                    onTap: (){
                    Navigator.push(context, PageRouteBuilder(transitionDuration: const Duration(milliseconds: 1000),
                      pageBuilder: (context, anim1, anim2) => ProductDetails(productId: wishlistModel!.productFullInfo!.id,
                          slug: wishlistModel!.productFullInfo!.slug, isFromWishList: true)));},
                    child: Container(height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                      alignment: Alignment.center, decoration: BoxDecoration(
                          color: Theme.of(context).highlightColor,
                          border: Border.all(width: .5, color: Theme.of(context).primaryColor.withValues(alpha:.35)),
                          boxShadow: Provider.of<ThemeController>(context, listen: false).darkTheme? null :
                          [BoxShadow(color: Colors.grey.withValues(alpha:0.2), spreadRadius: 1, blurRadius: 75, offset: const Offset(0, 1),),],
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                      child: Icon(Icons.shopping_cart_outlined, color: Theme.of(context).primaryColor, size: 25),
                    ),
                  ),
                ),
              ],
              ),
            ])),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

          ],),
        ),
      ),
    );
  }
}
