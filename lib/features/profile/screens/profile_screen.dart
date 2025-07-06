import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/domain/models/profile_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/screens/profile_screen1.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/widgets/delete_account_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  File? file;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  void _choose() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxHeight: 500, maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      }
    });
  }

  _updateUserAccount() async {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String phoneNumber = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if(Provider.of<ProfileController>(context, listen: false).userInfoModel!.fName == _firstNameController.text
        && Provider.of<ProfileController>(context, listen: false).userInfoModel!.lName == _lastNameController.text
        && Provider.of<ProfileController>(context, listen: false).userInfoModel!.phone == _phoneController.text && file == null
        && _passwordController.text.isEmpty && _confirmPasswordController.text.isEmpty) {

    showCustomSnackBar(getTranslated('change_something_to_update', context), context);

    }

    else if (firstName.isEmpty) {
      showCustomSnackBar(getTranslated('first_name_is_required', context), context);
    }

    else if(lastName.isEmpty) {
      showCustomSnackBar(getTranslated('last_name_is_required', context), context);
    }

    else if (email.isEmpty) {
      showCustomSnackBar(getTranslated('email_is_required', context), context);

    }

    else if (phoneNumber.isEmpty) {
      showCustomSnackBar(getTranslated('phone_must_be_required', context), context);
    }

    else if((password.isNotEmpty && password.length < 8) || (confirmPassword.isNotEmpty && confirmPassword.length < 8)) {
      showCustomSnackBar(getTranslated('minimum_password_is_8_character', context), context);
    }

    else if(password != confirmPassword) {
      showCustomSnackBar(getTranslated('confirm_password_not_matched', context), context);
    }

    else {
      ProfileModel updateUserInfoModel = Provider.of<ProfileController>(context, listen: false).userInfoModel!;
      updateUserInfoModel.method = 'put';
      updateUserInfoModel.fName = _firstNameController.text;
      updateUserInfoModel.lName = _lastNameController.text;
      updateUserInfoModel.phone = _phoneController.text;
      String pass = _passwordController.text;

      await Provider.of<ProfileController>(context, listen: false).updateUserInfo(
        updateUserInfoModel, pass, file, Provider.of<AuthController>(context, listen: false).getUserToken(),
      ).then((response) {
        if(response.isSuccess) {
          if(context.mounted) {
            Provider.of<ProfileController>(Get.context!, listen: false).getUserInfo(Get.context!);
            showCustomSnackBar(getTranslated('profile_info_updated_successfully', Get.context!), Get.context!, isError: false);
          }

          _passwordController.clear();
          _confirmPasswordController.clear();
          setState(() {});
        }else {
          showCustomSnackBar(response.message??'', Get.context!, isError: true);
        }
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<ProfileController>(
        builder: (context, profile, child) {
          _firstNameController.text = profile.userInfoModel!.fName??'';
          _lastNameController.text = profile.userInfoModel!.lName??'';
          _emailController.text = profile.userInfoModel!.email??'';
          _phoneController.text = profile.userInfoModel!.phone??'';

          return Stack(clipBehavior: Clip.none, children: [

            Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.width,
                color: Provider.of<ThemeController>(context, listen: false).darkTheme? Theme.of(context).cardColor:
                Theme.of(context).primaryColor),
            Container(transform: Matrix4.translationValues(-10, 0, 0),
                child: Padding(padding: const EdgeInsets.only(top: 50.0),
                    child: SizedBox(width: 110, child: Image.asset(Images.shadow,
                        opacity: const AlwaysStoppedAnimation(0.75))))),

            Positioned(right: -70, top: 150,
                child: Container(width: 200,height: 200,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Theme.of(context).cardColor.withValues(alpha:.05), width: 25)),
                )),

            Container(padding: const EdgeInsets.only(top: 35, left: 15),
                child: Row(children: [
                  CupertinoNavigationBarBackButton(
                    onPressed: () => Navigator.of(context).pop(), color: Colors.white,),
                  const SizedBox(width: 10),

                  Text(getTranslated('profile', context)??"",
                      style: textRegular.copyWith(fontSize: 20, color: Colors.white),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const Spacer(),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      child: InkWell(onTap: () => showModalBottomSheet(backgroundColor: Colors.transparent,
                          context: context, builder: (_)=>  DeleteAccountBottomSheet(customerId: profile.userID)),
                        child: Container(decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Icon(Icons.more_vert_rounded, color: Theme.of(context).cardColor),
                        ),
                      )),

                ])),

            Container(padding: const EdgeInsets.only(top: 55),
              child: Column(children: [
                Column(children: [

                  Container(margin: const EdgeInsets.only(top: Dimensions.marginSizeExtraLarge),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border.all(color: Colors.white, width: 3),
                      shape: BoxShape.circle,),
                    child: Stack(clipBehavior: Clip.none, children: [

                      ClipRRect(borderRadius: BorderRadius.circular(50),
                        child: file == null ?
                        CustomImageWidget(image: "${profile.userInfoModel!.imageFullUrl?.path}",
                          height: Dimensions.profileImageSize, fit: BoxFit.cover,width: Dimensions.profileImageSize,) :
                        Image.file(file!, width: Dimensions.profileImageSize,
                            height: Dimensions.profileImageSize, fit: BoxFit.fill),
                      ),

                      Positioned(bottom: 0, right: -10,
                          child: CircleAvatar(backgroundColor: Theme.of(context).primaryColor,
                              radius: 14,
                              child: IconButton(
                                onPressed: _choose,
                                padding: const EdgeInsets.all(0),
                                icon: const Icon(Icons.camera_alt_sharp, color: ColorResources.white, size: 18),
                              ),
                          ),
                      )
                    ]),
                  ),

                  Text(
                    '${profile.userInfoModel!.fName} ${profile.userInfoModel!.lName ?? ''}',
                    style: textBold.copyWith(color: ColorResources.white, fontSize: Dimensions.fontSizeLarge),
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeLarge),


                Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(color: ColorResources.getIconBg(context),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.marginSizeDefault),
                      topRight: Radius.circular(Dimensions.marginSizeDefault),
                    ),
                  ),
                  child: ListView(physics: const BouncingScrollPhysics(), children: [
                    CustomTextFieldWidget(
                      labelText: getTranslated('first_name', context),
                      inputType: TextInputType.name,
                      focusNode: _fNameFocus,
                      nextFocus: _lNameFocus,
                      hintText: profile.userInfoModel!.fName ?? '',
                      controller: _firstNameController,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    CustomTextFieldWidget(
                      labelText: getTranslated('last_name', context),
                      inputType: TextInputType.name,
                      focusNode: _lNameFocus,
                      nextFocus: _emailFocus,
                      hintText: profile.userInfoModel!.lName,
                      controller: _lastNameController,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),



                    CustomTextFieldWidget(
                      isEnabled: false,
                      labelText: getTranslated('email', context),
                      inputType: TextInputType.emailAddress,
                      focusNode: _emailFocus,
                      readOnly : true,
                      nextFocus: _phoneFocus,
                      hintText: profile.userInfoModel!.email ?? '',
                      controller: _emailController,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),


                    CustomTextFieldWidget(
                      isEnabled: profile.userInfoModel?.phone == null,
                      labelText: getTranslated('phone', context),
                      inputType: TextInputType.phone,
                      focusNode: _phoneFocus,
                      hintText: profile.userInfoModel!.phone ?? "",
                      nextFocus: _addressFocus,
                      controller: _phoneController,
                      isAmount: true,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),


                    CustomTextFieldWidget(
                      isPassword: true,
                      labelText: getTranslated('password', context),
                      hintText: getTranslated('enter_7_plus_character', context),
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      nextFocus: _confirmPasswordFocus,
                      inputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),


                    CustomTextFieldWidget(
                      labelText: getTranslated('confirm_password', context),
                      hintText: getTranslated('enter_7_plus_character', context),
                      isPassword: true,
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocus,
                      inputAction : TextInputAction.done,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),


                    InkWell(
                      child: const Text('HEllo'),
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileScreen1()));
                      },
                    ),


                  ],
                  ),
                ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: Dimensions.marginSizeLarge,
                    vertical: Dimensions.marginSizeSmall,
                  ),
                  child: !profile.isLoading ?
                  CustomButton(onTap: _updateUserAccount, buttonText: getTranslated('update_profile', context)) :
                  Center(child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                  )),
                ),
              ]),
            ),
          ]);
        },
      ),
    );
  }
}
