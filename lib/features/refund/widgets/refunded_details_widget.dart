
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/domain/models/order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/refund/controllers/refund_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/refund/widgets/change_log_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/app_localization.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/image_diaglog_widget.dart';
import 'package:provider/provider.dart';

class RefundDetailsWidget extends StatefulWidget {
  final Product? product;
  final int? orderDetailsId;
  final String? createdAt;
  final OrderDetailsModel? orderDetailsModel;
  const RefundDetailsWidget({super.key, required this.product, required this.orderDetailsId, this.orderDetailsModel, required this.createdAt});
  @override
  RefundDetailsWidgetState createState() => RefundDetailsWidgetState();
}

class RefundDetailsWidgetState extends State<RefundDetailsWidget> {
  @override
  void initState() {
    Provider.of<RefundController>(context, listen: false).getRefundResult(context, widget.orderDetailsId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(title: getTranslated('refund_request_details', context),
        showActionButton: true,showResetIcon: true, reset: Consumer<RefundController>(
          builder: (context, refund,_) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault),
              child: Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeEight),
                border: Border.all(color: Colors.green, width: 1)
              ),
                child:  refund.refundResultModel != null ? Text("${getTranslated("${refund.refundResultModel!.refundRequest![0].status}", context)}".toCapitalized(),
                    style:  textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.green)) : const Center(child: CircularProgressIndicator())),
            );
          }
        )),
      body: SingleChildScrollView(
        child: Consumer<OrderDetailsController>(
          builder: (context, orderDetailsController,_) {
            return Consumer<RefundController>(builder: (context,refundReq,_) {
              return Padding(padding: MediaQuery.of(context).viewInsets,
                child: Consumer<RefundController>(builder: (context, refund, _) {
                return refund.refundResultModel!=null && refund.refundResultModel!.refundRequest != null ?
                Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        side: BorderSide(
                          color: Theme.of(context).hintColor.withValues(alpha:0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(Dimensions.radiusSmall), topLeft: Radius.circular(Dimensions.radiusSmall)),
                            color: Theme.of(context).hintColor.withValues(alpha:.1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(text: TextSpan(text: '', style: DefaultTextStyle.of(context).style, children: <TextSpan>[
                              TextSpan(text: "${getTranslated('order_id_refund_details', context)}",
                                  style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor)),
                              TextSpan(text: "#${widget.orderDetailsModel?.orderId}",
                                  style:  textBold.copyWith(fontSize: Dimensions.fontSizeDefault))])),

                                const Expanded(child: SizedBox()),

                                Text(DateConverter.refundDateTime(widget.orderDetailsModel!.createdAt!),
                                    style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault), overflow: TextOverflow.ellipsis,),

                            ],),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${getTranslated('refundable_amount', context)}",
                                    style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                                        color: Theme.of(context).hintColor),
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(PriceConverter.convertPrice(context,
                                          refund.refundInfoModel!.refund!.refundAmount), style: textMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeExtraLarge),
                                        ),
                                      ),
                                    ],
                                  ),

                              ],),
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("${getTranslated('request_date', context)}",
                                    style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                                        color: Theme.of(context).hintColor)
                                ),

                                Text(DateConverter.refundDateTime(refund.refundResultModel!.refundRequest![0].createdAt!),
                                  style:  textMedium.copyWith(fontSize: Dimensions.fontSizeDefault), overflow: TextOverflow.ellipsis,
                                ),


                            ],)
                          ],),
                        )
                      ],),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: Dimensions.paddingSizeEight),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          side: BorderSide(
                            color: Theme.of(context).hintColor.withValues(alpha:0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Padding(
                            padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeExtraSmall),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 20, child: Image.asset(Images.refundReason)),

                                Padding(
                                  padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                                  child: Text("${getTranslated('request_reason_refund_details', context)}",
                                    style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault), overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],),
                          ),

                          Divider(color: Theme.of(context).hintColor.withValues(alpha:0.125)),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                            child: Text("${refund.refundResultModel!.refundRequest![0].refundReason}",
                              style:  textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                            ),
                          ),

                            (refund.refundResultModel!.refundRequest![0].images != null && refund.refundResultModel!.refundRequest![0].images!.isNotEmpty)?
                            Padding(
                              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                              child: SizedBox(height: 90,
                                child: RepaintBoundary(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount:  refund.refundResultModel!.refundRequest![0].images!.length,
                                    itemBuilder: (BuildContext context, index){
                                      return  refund.refundResultModel!.refundRequest![0].images!.isNotEmpty?
                                      Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault,),
                                        child: Stack(children: [
                                          InkWell(onTap: () => showDialog(context: context, builder: (ctx) =>
                                              ImageDialog(imageUrl:'${AppConstants.baseUrl}/storage/app/public/refund/'
                                                  '${refund.refundResultModel!.refundRequest![0].images![index]}'), ),
                                            child: Container(width: 85, height: 85,
                                              decoration: const BoxDecoration(
                                                  color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
                                              child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),
                                                child: CustomImageWidget(placeholder: Images.placeholder, image: '${refund.refundResultModel!.refundRequest![0].imagesFullUrl![index].path}',
                                                    width: 85, height: 85, fit: BoxFit.cover),) ,
                                            ),
                                          ),
                                        ],),):const SizedBox();
                                    },),
                                ),),
                            ):const SizedBox(),



                        ],),
                      ),
                    ),

                    if(refundReq.refundResultModel!.refundRequest![0].refundStatus!.isNotEmpty)...[
                      const ChangeLogWidget(),
                    ]

                  ]),) : const SizedBox();
              }),
              );
            });
          }
        ),
      ),
    );
  }
}


