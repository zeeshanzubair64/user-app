import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:shimmer/shimmer.dart';

class OrderShimmerWidget extends StatelessWidget {
  const OrderShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Theme.of(context).cardColor),
            color: ColorResources.iconBg(),
            boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha:0.3), spreadRadius: 1, blurRadius: 5)]),
          margin: const EdgeInsets.only(bottom: Dimensions.marginSizeDefault),
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),

          child: Shimmer.fromColors(
            baseColor: Theme.of(context).cardColor,
            highlightColor: Colors.grey[300]!,
            enabled: true,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(height: 10, width: 150, color: ColorResources.white),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Container(height: 100, width: 100 ,decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,borderRadius: BorderRadius.circular(5))),
                  const SizedBox(width: 10),
                  Expanded(flex: 3, child: Column(children: [
                    Container(height: 20, color: ColorResources.white),
                    const SizedBox(height: 10),
                    Row(children: [
                      Container(height: 10, width: 70, color: Colors.white),
                      const SizedBox(width: 10),
                      Container(height: 10, width: 20, color: Colors.white),
                    ])])),
                ])])),
        );
      },
    );
  }
}