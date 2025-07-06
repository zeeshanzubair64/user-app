import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/screens/cart_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/controllers/chat_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/models/navigation_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/widgets/dashboard_menu_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/flash_deal_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/restock/controllers/restock_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/search_product/controllers/search_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/controllers/wishlist_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/network_info.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/widgets/app_exit_card_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/screens/inbox_screen.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/screens/aster_theme_home_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/screens/fashion_theme_home_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/screens/home_screens.dart';
import 'package:flutter_sixvalley_ecommerce/features/more/screens/more_screen_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/screens/order_screen.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});
  @override
  DashBoardScreenState createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoardScreen> {
  int _pageIndex = 0;
  late List<NavigationModel> _screens ;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  final PageStorageBucket bucket = PageStorageBucket();

  bool singleVendor = false;




  @override
  void initState() {
    super.initState();
    Provider.of<FlashDealController>(context, listen: false).getFlashDealList(true, true);
    if(Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
      Provider.of<WishListController>(context, listen: false).getWishList();
      Provider.of<ChatController>(context, listen: false).getChatList(1, reload: false, userType: 0);
      Provider.of<ChatController>(context, listen: false).getChatList(1, reload: false, userType: 1);
      Provider.of<RestockController>(context, listen: false).getRestockProductList(1, getAll: true);
    }

    final SplashController splashController = Provider.of<SplashController>(context, listen: false);
    singleVendor = splashController.configModel?.businessMode == "single";
    Provider.of<SearchProductController>(context, listen: false).getAuthorList(null);
    Provider.of<SearchProductController>(context, listen: false).getPublishingHouseList(null);

    if(splashController.configModel!.activeTheme == "default") {

      HomePage.loadData(false);

    }else if(splashController.configModel!.activeTheme == "theme_aster") {
      AsterThemeHomeScreen.loadData(false);
    }else{
      FashionThemeHomePage.loadData(false);
    }

      _screens = [
        NavigationModel(
          name: 'home',
          icon: Images.homeImage,
          screen: (splashController.configModel!.activeTheme == "default")
              ? const HomePage() : (splashController.configModel!.activeTheme == "theme_aster")
              ? const AsterThemeHomeScreen(): const FashionThemeHomePage(),
        ),

        NavigationModel(name: 'inbox', icon: Images.messageImage, screen: const InboxScreen(isBackButtonExist: false)),
        NavigationModel(name: 'cart', icon: Images.cartArrowDownImage, screen: const CartScreen(showBackButton: false), showCartIcon: true),
        NavigationModel(name: 'orders', icon: Images.shoppingImage, screen:  const OrderScreen(isBacButtonExist: false)),
        NavigationModel(name: 'more', icon: Images.moreImage, screen:  const MoreScreen()),

      ];

    // Padding(padding: const EdgeInsets.only(right: 12.0),
    //   child: IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
    //     icon: Stack(clipBehavior: Clip.none, children: [
    //
    //       Image.asset(Images.cartArrowDownImage, height: Dimensions.iconSizeDefault,
    //           width: Dimensions.iconSizeDefault, color: ColorResources.getPrimary(context)),
    //
    //       Positioned(top: -4, right: -4,
    //           child: Consumer<CartController>(builder: (context, cart, child) {
    //             return CircleAvatar(radius: ResponsiveHelper.isTab(context)? 10 :  7, backgroundColor: ColorResources.red,
    //                 child: Text(cart.cartList.length.toString(),
    //                     style: titilliumSemiBold.copyWith(color: ColorResources.white,
    //                         fontSize: Dimensions.fontSizeExtraSmall)));})),
    //     ]),
    //   ),
    // ),




    NetworkInfo.checkConnectivity(context);

  }

  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if(_pageIndex != 0) {
          _setPage(0);
          return;
        }else {
          await Future.delayed(const Duration(milliseconds: 150));
          if(context.mounted){
            if (!Navigator.of(context).canPop()) {
              showModalBottomSheet(backgroundColor: Colors.transparent,
                  context: Get.context!, builder: (_)=> const AppExitCard());
            }
          }
        }
        return;
      },
      child: Scaffold(
        key: _scaffoldKey,

        body: PageStorage(bucket: bucket, child: _screens[_pageIndex].screen),
        bottomNavigationBar: Container(height: 68,
          decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(
              top: Radius.circular(Dimensions.paddingSizeLarge)),
            color: Theme.of(context).cardColor,
            boxShadow: [BoxShadow(offset: const Offset(1,1), blurRadius: 2, spreadRadius: 1,
                color: Theme.of(context).primaryColor.withValues(alpha:.125))],),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _getBottomWidget(singleVendor)))));
  }


  void _setPage(int pageIndex) {
    setState(() {
      if(pageIndex ==1 && _pageIndex != 1 ){
        Provider.of<ChatController>(context, listen: false).setUserTypeIndex(context, 0);
        Provider.of<ChatController>(context, listen: false).resetIsSearchComplete();
      }
      _pageIndex = pageIndex;
    });
  }

  List<Widget> _getBottomWidget(bool isSingleVendor) {
    List<Widget> list = [];
    for(int index = 0; index < _screens.length; index++) {
      list.add(Expanded(child: CustomMenuWidget(
        isSelected: _pageIndex == index,
        name: _screens[index].name,
        icon: _screens[index].icon,
        showCartCount: _screens[index].showCartIcon ?? false,
        onTap: () => _setPage(index))));
    }
    return list;
  }

}




