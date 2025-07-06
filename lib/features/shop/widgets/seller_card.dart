import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/domain/models/seller_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/screens/shop_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SellerCard extends StatefulWidget {
  final Seller? sellerModel;
  final bool isHomePage;
  final int index;
  final int length;
  const SellerCard({super.key, this.sellerModel, this.isHomePage = false, required this.index, required this.length});

  @override
  State<SellerCard> createState() => _SellerCardState();
}

class _SellerCardState extends State<SellerCard> {
  bool vacationIsOn = false;
  @override
  Widget build(BuildContext context) {
    final bool isLtr = Provider.of<LocalizationController>(context, listen: false).isLtr;
    var splashController = Provider.of<SplashController>(context, listen: false);
    if(widget.sellerModel?.shop?.vacationEndDate != null){
      DateTime vacationDate = DateTime.parse(widget.sellerModel!.shop!.vacationEndDate!);
      DateTime vacationStartDate = DateTime.parse(widget.sellerModel!.shop!.vacationStartDate!);
      final today = DateTime.now();
      final difference = vacationDate.difference(today).inDays;
      final startDate = vacationStartDate.difference(today).inDays;
      if(difference >= 0 && widget.sellerModel!.shop!.vacationStatus! && startDate <= 0){
        vacationIsOn = true;
      }
      else{
        vacationIsOn = false;
      }
    }


    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => TopSellerProductScreen(
          sellerId: widget.sellerModel?.id,
          temporaryClose: widget.sellerModel?.shop?.temporaryClose,
          vacationStatus: widget.sellerModel?.shop?.vacationStatus??false,
          vacationEndDate: widget.sellerModel?.shop?.vacationEndDate,
          vacationStartDate: widget.sellerModel?.shop?.vacationStartDate,
          name: widget.sellerModel?.shop?.name,
          banner: widget.sellerModel?.shop?.bannerFullUrl?.path,
          image: widget.sellerModel?.shop?.imageFullUrl?.path,)));
      },
      child : Padding(
        padding: widget.isHomePage? EdgeInsets.only(left : widget.index == 0? Dimensions.paddingSizeDefault :
        Provider.of<LocalizationController>(context, listen: false).isLtr ?
        Dimensions.paddingSizeDefault : 0, right: widget.index + 1 == widget.length?
        Dimensions.paddingSizeDefault : (Provider.of<LocalizationController>(context, listen: false).isLtr && widget.isHomePage) ?
            0 : Dimensions.paddingSizeDefault, bottom: widget.isHomePage?
        Dimensions.paddingSizeExtraSmall: Dimensions.paddingSizeDefault):
        const EdgeInsets.fromLTRB( Dimensions.paddingSizeSmall,  Dimensions.paddingSizeDefault,  Dimensions.paddingSizeSmall,0),
        child: Container(clipBehavior: Clip.none, decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha:0.075),
              spreadRadius: 1, blurRadius: 1, offset: const Offset(0,1))]),
          child: Column(children: [
              SizedBox(height: widget.isHomePage? 57 : 120,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.paddingSizeSmall),
                      topRight: Radius.circular(Dimensions.paddingSizeSmall)),
                  child: CustomImageWidget(image: widget.sellerModel!.id == 0 ?
                  splashController.configModel!.companyLogo?.path ?? '' :
                  widget.sellerModel!.shop!.bannerFullUrl?.path ?? ''))),

              Row(children: [
                  Container(transform: isLtr ? Matrix4.translationValues(12, -20, 0) : Matrix4.translationValues(-12, -20, 0), height: 60, width: 60,
                    child: Stack(children: [
                        Container(width: 60,height: 60,
                            decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeOverLarge)),
                              color: Theme.of(context).highlightColor),
                            child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeOverLarge)),
                              child: CustomImageWidget(
                              image: widget.sellerModel!.id == 0 ?
                              splashController.configModel!.companyFavIcon?.path ?? '' :
                              '${widget.sellerModel!.shop?.imageFullUrl?.path}',
                                  width: 60,height: 60))),

                        if((widget.sellerModel!.shop!.temporaryClose ?? false) || vacationIsOn)
                          Container(decoration: BoxDecoration(color: Colors.black.withValues(alpha:.5),
                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeOverLarge)))),

                      (widget.sellerModel!.shop!.temporaryClose ?? false) ?
                        Center(child: Text(getTranslated('temporary_closed', context)!, textAlign: TextAlign.center,
                          style: textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeExtraSmall))):
                        vacationIsOn == true?
                        Center(child: Text(getTranslated('close_for_now', context)!, textAlign: TextAlign.center,
                          style: textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeExtraSmall),)):
                        const SizedBox()])),


                  const SizedBox(width: Dimensions.paddingSizeLarge),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(widget.sellerModel?.shop?.name??'', maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge),),
                      Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                        child: Row(children: [
                          Icon(Icons.star_rate_rounded, color: Colors.yellow.shade700, size: 15,),
                          Text("${widget.sellerModel?.averageRating?.toStringAsFixed(1)} ",
                            style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall),),
                          Text(" (${widget.sellerModel?.ratingCount??0})",
                            style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).hintColor),),
                        ]))]))]),

            Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall,
                right: Dimensions.paddingSizeSmall, bottom:  Dimensions.paddingSizeSmall),
              child: Row( children: [

                Expanded(child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(color: Theme.of(context).hintColor.withValues(alpha:.125),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(NumberFormat.compact().format(widget.sellerModel?.productCount??0),
                      style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color:Theme.of(context).primaryColor),),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    Text("${getTranslated('products', context)}", style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall)
                    )])))])),
            ],
          ),
        ),
      )
    );
  }
}
