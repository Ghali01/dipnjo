import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:user/ui/widgets/app_bar.dart';
import 'package:user/utilities/colors.dart';

class QrCodePage extends StatelessWidget {
  const QrCodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 56),
        child: AppAppBar(title: 'Qr Code'),
      ),
      body: Center(
        child: Container(
          width: 370,
          height: 400,
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xffa17f73),
                    Color(0xff82554f),
                  ]),
              borderRadius: BorderRadius.circular(24)),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(
                height: 32,
              ),
              const Text(
                'QR Code',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700),
              ).tr(),
              const SizedBox(
                height: 32,
              ),
              SizedBox.square(
                dimension: 250,
                child: DottedBorder(
                  customPath: (p0) => Path()
                    ..moveTo(0, 20)
                    ..lineTo(0, 0)
                    ..lineTo(20, 0)
                    ..moveTo(230, 0)
                    ..lineTo(250, 0)
                    ..lineTo(250, 20)
                    ..moveTo(250, 230)
                    ..lineTo(250, 250)
                    ..lineTo(230, 250)
                    ..moveTo(20, 250)
                    ..lineTo(0, 250)
                    ..lineTo(0, 230),
                  color: Colors.white,
                  strokeWidth: 3,
                  strokeCap: StrokeCap.square,
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: QrImage(
                      data: FirebaseAuth.instance.currentUser!.uid,
                      foregroundColor: Colors.white,
                      size: 230,
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
}
