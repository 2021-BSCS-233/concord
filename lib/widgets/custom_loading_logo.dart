import 'package:flutter/cupertino.dart';

class CustomLoadingLogo extends StatelessWidget {
  const CustomLoadingLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          height: 150,
          width: 150,
          child: Image.asset('assets/images/grayscale_logo.png')),
    );
  }
}
