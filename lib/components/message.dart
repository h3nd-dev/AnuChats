import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

void showMessage ({required String? message, required BuildContext? context,}){
  final Size size = MediaQuery.of(context!).size;
  final FToast _fToast = FToast();
  _fToast.init(context);
  _fToast.showToast(
    child: SizedBox(
      height: 60,
      width: 335,
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 14, 15, 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.green,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                message ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: GoogleFonts.workSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: Colors.white
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: const Icon(
                Icons.check_circle_outline, // Using a success icon
                color: Colors.white,
              ),
            ),

          ],
        ),
      ),
    ),

    toastDuration: const Duration(seconds: 2),
    gravity: ToastGravity.TOP,
    positionedToastBuilder: (context, child) => Positioned(
      top: size.height * 0.05,
      // bottom: size.height.sp * 0.01,
      //left: size.width * 0.0628,
      child: Center(child: child),
    ),

  );


}
void error ({String? message, BuildContext? context}){
  final Size size = MediaQuery.of(context!).size;
  final FToast _fToast = FToast();
  _fToast.init(context);
  _fToast.showToast(
    child: SizedBox(
      height: 60,
      width: 335,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 14, 15, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.red,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  message ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: GoogleFonts.workSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Colors.white
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: const Icon(
                  Icons.error, // Using a success icon
                  color: Colors.white,
                ),
              ),

            ],
          ),
        ),
      ),
    ),

    toastDuration: const Duration(seconds: 2),
    gravity: ToastGravity.TOP,
    positionedToastBuilder: (context, child) => Positioned(
      top: size.height * 0.05,
//         // bottom: size.height.sp * 0.01,
//       //left: size.width * 0.0628,
      child: Center(child: child),
    ),

  );
}