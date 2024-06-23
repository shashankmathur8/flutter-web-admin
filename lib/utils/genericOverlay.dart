
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_admin/utils/styles.dart';

import 'appColors.dart';
import 'customWidget.dart';

class GenericOverlay extends ModalRoute<void> {
  final String title;
  final String? message;
  final Widget? messageWidget;
  final String? negativeButtonText;
  final String positiveButtonText;
  final String iconPath;
  final VoidCallback onNegativePressCallback;
  final VoidCallback onPositivePressCallback;
  final String? keyId;
  var ticketingBitController;

  GenericOverlay({
    required this.iconPath,
    required this.title,
    this.message,
    this.messageWidget,
    this.negativeButtonText,
    required this.positiveButtonText,
    required this.onPositivePressCallback,
    required this.onNegativePressCallback,
    this.keyId,
    this.ticketingBitController
  }) : super();

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.3);

  @override
  String get barrierLabel => '';

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Scaffold(
      key: ValueKey(keyId),
      resizeToAvoidBottomInset:true,
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Container(
                  width: 570,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 7)
                      ]),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomWidgets().roundIconWidget(iconPath),
                              // Image(image: AssetImage(iconPath) ,),
                              const SizedBox(
                                width: 20,
                              ),
                              CustomWidgets().headerTitle(
                                  title,TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold

                              )),
                              Spacer(),
                               GestureDetector(
                                 onTap: (){
                                   Get.back();
                                 },
                                 child: Container(
                                  width: 20,
                                   height: 20,
                                   child: Center(child: Text("X",style: AppStyles.t16NWhite,)),
                                   color: Colors.red,
                                                               ),
                               )
                            ],
                          ),
                          Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 75,
                                  ),
                                  Flexible(
                                    child: message != null
                                        ? Text(
                                      message!,
                                    )
                                        : messageWidget != null
                                        ? messageWidget!
                                        : Container(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  negativeButtonText != null
                                      ? Align(
                                    alignment: Alignment.bottomRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        onNegativePressCallback();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            border: Border.all(
                                                color: AppColors.colorPrimary,
                                              width: 2
                                            ),
                                          color: Colors.white
                                        ),
                                        width: 102,
                                        height: 45,
                                        child: Center(
                                          child: Text(negativeButtonText!,style:
                                          TextStyle(
                                              color: AppColors.colorPrimary,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16
                                          ),),
                                        ),
                                      ),
                                    ),
                                  )
                                      : Container(),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        onPositivePressCallback();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(
                                            color: AppColors.colorPrimary,
                                              width: 2
                                          )
                                        ),
                                        width: 102,
                                        height: 45,
                                        child: Center(
                                          child: Text(positiveButtonText,style:
                                            TextStyle(
                                                color: AppColors.colorPrimary,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16
                                            ),),
                                        ),

                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
