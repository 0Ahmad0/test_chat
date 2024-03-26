import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../constants/style_manager.dart';
import '../models/models.dart';

class Const{
  static loading (context){
    //ToDo lock screen
    Get.dialog(
        Center(
          child: Container(
              alignment: Alignment.center,
              width:  MediaQuery.sizeOf(context).width  * 0.2,
              height: MediaQuery.sizeOf(context).width * 0.2,
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8)),
              child:
              CircularProgressIndicator(
                color: AppColors.primary,
              )
              // LoadingAnimationWidget.inkDrop(
              //     color: AppColors.primary,
              //     size: MediaQuery.sizeOf(context).width * 0.1)
          ),
        ),
        barrierDismissible: false
    );
  }
  static LOADING_DROPDOWN ({required String text,StateStream? stateStream}){
    return  ListTile(
      title: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      trailing:
      stateStream==StateStream.Empty?
          Icon(Icons.hourglass_empty_outlined)
      : stateStream==StateStream.Error?
      Icon(Icons.error_outline)
     : CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2,
        strokeAlign: CircularProgressIndicator.strokeAlignInside,
      )

      ,
    );
  }

  static TOAST(BuildContext context, {String textToast = "This Is Toast"}) {
    showToast(
        textToast,
        context: context,
        animation: StyledToastAnimation.fadeScale,
        position: StyledToastPosition.top,
        textStyle: getRegularStyle(color: AppColors.white)
    );
  }
  static SHOWLOADINGINDECATOR() {
    return Center(
      child: CircularProgressIndicator(
      ),
    );}

  static emptyWidget(context,{text='No Data Yet!'})=>Center(
    child: Text(text,style: TextStyle(
        fontSize: MediaQuery.sizeOf(context).width * 0.08,
        fontWeight: FontWeight.bold
    ),),
  );


}