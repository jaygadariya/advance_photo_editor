import 'package:flutter/material.dart';

class BottomBarContainer extends StatelessWidget {
  final Color? colors;
  final Function? ontap;
  final String? title;
  final IconData? icons;

  const BottomBarContainer({
    Key? key,
    this.ontap,
    this.title,
    this.icons,
    this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 5,
      child: Material(
        type: MaterialType.canvas,
        elevation: 0.0,
        shadowColor: const Color(0xFF000000),
        clipBehavior: Clip.none,
        borderOnForeground: true,
        animationDuration: Duration(milliseconds: 200),
        child: InkWell(
          onTap: ontap as void Function()?,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            verticalDirection: VerticalDirection.down,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icons, color: Colors.black),
              SizedBox(
                height: 4.0,
              ),
              Text(
                title!,
                style: TextStyle(
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
