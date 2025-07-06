import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/domain/models/notification_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/controllers/notification_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/widget/notification_dialog_widget.dart';
import 'package:provider/provider.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationItem notificationItem;
  const NotificationItemWidget({super.key, required this.notificationItem});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap:(){
      Provider.of<NotificationController>(context, listen: false).seenNotification(notificationItem.id!);
      showModalBottomSheet(backgroundColor: Colors.transparent,
          context: context, builder: (context) =>
              NotificationDialogWidget(notificationModel: notificationItem));},
        child: Container(margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
            color: Theme.of(context).cardColor,
            child: ListTile(leading: Stack(children: [
              ClipRRect(borderRadius: BorderRadius.circular(40),
                  child: Container(decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:.15), width: .35),
                      borderRadius: BorderRadius.circular(40)),
                      child: CustomImageWidget(width: 50,height: 50,
                          image: '${notificationItem.imageFullUrl?.path}'))),



              if(notificationItem.seen == null)
                CircleAvatar(backgroundColor: Theme.of(context).colorScheme.error.withValues(alpha:.75),radius: 3)]),
                title: Text(notificationItem.title??'',
                    style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),

                subtitle: Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(notificationItem.createdAt!)),
                    style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,
                        color: ColorResources.getHint(context))))));
  }
}