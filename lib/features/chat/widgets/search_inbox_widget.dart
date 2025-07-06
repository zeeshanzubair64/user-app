import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/controllers/chat_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';


class SearchInboxWidget extends StatefulWidget {
  final String? hintText;
  const SearchInboxWidget({super.key, required this.hintText});

  @override
  State<SearchInboxWidget> createState() => _SearchInboxWidgetState();
}

class _SearchInboxWidgetState extends State<SearchInboxWidget> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Consumer<ChatController>(builder: (context, chat,_) {
      return Row(children: [
          Expanded(child: Container(decoration: const BoxDecoration(
              borderRadius: BorderRadius.all( Radius.circular(Dimensions.paddingSizeDefault))),

              child: TextFormField(controller: searchController,
                textInputAction: TextInputAction.search,
                maxLines: 1,
                textAlignVertical: TextAlignVertical.center,
                onFieldSubmitted: (val) {

                 if(val.trim().isEmpty) {
                   searchController.clear();
                 }else {
                   Provider.of<ChatController>(context, listen: false).searchChat(context, searchController.text.trim(), 0);
                   Provider.of<ChatController>(context, listen: false).searchChat(context, searchController.text.trim(), 1);
                 }

                },

                onChanged: (text) => chat.showSuffixIcon(context, text),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  isDense: true,
                  suffixIconConstraints: const BoxConstraints(maxHeight: 25),
                  hintStyle: textMedium.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeLarge),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 22),
                  fillColor: Theme.of(context).cardColor,
                  border:  OutlineInputBorder(
                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(10,),left: Radius.circular(10)),
                    borderSide: BorderSide( width: 0.5, color: Theme.of(context).primaryColor.withValues(alpha:0.5)),
                  ),
                  errorBorder:  OutlineInputBorder(
                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(10,),left: Radius.circular(10)),
                    borderSide: BorderSide( width: 0.5, color: Theme.of(context).primaryColor.withValues(alpha:0.5)),
                  ),

                  focusedBorder:  OutlineInputBorder(
                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(10,),left: Radius.circular(10)),
                    borderSide: BorderSide( width: 0.5, color: Theme.of(context).primaryColor.withValues(alpha:0.5)),
                  ),
                  enabledBorder :  OutlineInputBorder(
                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(10,),left: Radius.circular(10)),
                    borderSide: BorderSide( width: 0.5, color: Theme.of(context).primaryColor.withValues(alpha:0.5)),
                  ),
                  filled: true,

                  suffixIcon: searchController.text.trim().isNotEmpty ? IconButton(
                    color: Theme.of(context).hintColor,
                    onPressed: () {
                      searchController.clear();
                      // if(conversationController.searchController.text.trim().isNotEmpty) {
                      //   conversationController.clearSearchController();
                      // }
                      chat.showSuffixIcon(context, '');
                      FocusScope.of(context).unfocus();
                    },
                    icon: Icon(Icons.cancel_outlined, size: 18, color: Theme.of(context).hintColor),
                  ) : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: Icon(Icons.search_outlined,color: Theme.of(context).hintColor, size: 22),
                  ),

                  // suffixIcon: searchController.text.isNotEmpty? InkWell(
                  //     onTap: (){
                  //       setState(() {
                  //         searchController.clear();
                  //         Provider.of<ChatController>(context, listen: false).getChatList(1);
                  //       });
                  //
                  //     },
                  //     child: Padding(padding: const EdgeInsets.only(bottom: 3.0),
                  //       child: Icon(Icons.clear, color: ColorResources.getChatIcon(context)))):
                  // const SizedBox()))))),
                  //
                  // InkWell(onTap:(){if(searchController.text.trim().isEmpty){
                  //     showCustomSnackBar(getTranslated('enter_somethings', context), context);}
                  //   else{
                  //     Provider.of<ChatController>(context, listen: false).searchChat(context, searchController.text.trim());
                  //   }},
                  //   child: Padding(padding: const EdgeInsets.all(3.0),
                  //     child: Container(padding: const EdgeInsets.all(10),
                  //       width: 45,height: 50 ,decoration: const BoxDecoration(
                  //           borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall))),
                  //       child:  Image.asset(Images.search, color: searchController.text.isNotEmpty?
                  //       Theme.of(context).primaryColor :Theme.of(context).hintColor))))


                )))),

        ]);
      }
    );
  }
}
