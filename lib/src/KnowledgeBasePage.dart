import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class KnowledgeBasePage extends StatelessWidget {
  const KnowledgeBasePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: Svg('assets/grid.svg', size: Size.square(40)),
          repeat: ImageRepeat.repeat,
          colorFilter: ColorFilter.mode(Colors.black12, BlendMode.srcIn),
        ),
      ),
      child: Center(child: Text("Hello", style: TextStyle(fontSize: 80))),
    );
  }
}
