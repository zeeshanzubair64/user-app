import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/seller_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:provider/provider.dart';


class SearchWidget extends StatefulWidget {
  final String? hintText;
  final int? sellerId;
  const SearchWidget({super.key, required this.hintText, this.sellerId});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final SellerProductController sellerProductController = Provider.of<SellerProductController>(context, listen: false);

    return Stack(children: [
      ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
        child: SizedBox(height: 50 , width: MediaQuery.of(context).size.width)),

      Padding(padding: const EdgeInsets.all(8.0),
        child: Container(width : MediaQuery.of(context).size.width, height:  50 ,
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            border: Border.all(color: Theme.of(context).hintColor.withValues(alpha:.15))),
          child: Row(children: [
            Expanded(child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all( Radius.circular(Dimensions.paddingSizeDefault))),

              child: Padding(padding:  const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeExtraSmall,
                    horizontal: Dimensions.paddingSizeSmall),

                child: TextFormField(controller: searchController,
                    textInputAction: TextInputAction.search,
                    maxLines: 1,
                    textAlignVertical: TextAlignVertical.center,
                    onFieldSubmitted: (val){
                      sellerProductController.getSellerProductList(widget.sellerId.toString(), 1, "", search: searchController.text.trim());
                    },
                    onChanged: (val){
                  setState(() {

                  });
                    },
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      isDense: true,

                      contentPadding: EdgeInsets.zero,
                      suffixIconConstraints: const BoxConstraints(maxHeight: 25),
                      hintStyle: textRegular.copyWith(color: Theme.of(context).hintColor),
                      border: InputBorder.none,
                      suffixIcon: searchController.text.isNotEmpty? InkWell(
                        onTap: (){
                          setState(() {
                            searchController.clear();
                            sellerProductController.getSellerProductList(widget.sellerId.toString(), 1, "");

                          });

                        },
                          child: Padding(padding: const EdgeInsets.only(bottom: 3.0),
                            child: Icon(Icons.clear, color: ColorResources.getChatIcon(context)),
                          )):const SizedBox(),
                    ),
                  ),
                ),

              ),
            ),

            InkWell(
              onTap:(){
                if(searchController.text.trim().isEmpty){
                  showCustomSnackBar(getTranslated('enter_somethings', context), context);
                }
                else{
                  sellerProductController.getSellerProductList(widget.sellerId.toString(), 1, "", search: searchController.text.trim());

                }
              },
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(padding: const EdgeInsets.all(10),
                  width: 45,height: 50 ,decoration: BoxDecoration(color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall))),
                  child:  Image.asset(Images.search, color: Colors.white),
                ),
              ),
            )


          ]),
        ),
      ),
    ]);
  }
}
