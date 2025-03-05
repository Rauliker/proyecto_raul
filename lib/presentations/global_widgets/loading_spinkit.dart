import 'package:bidhub/core/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSpinkit extends StatelessWidget {
  const LoadingSpinkit({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitWave(
        color: blue,
        size: 20,
      ),
    );
  }
}
