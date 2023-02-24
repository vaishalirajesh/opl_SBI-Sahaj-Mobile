import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;
  final double size;

  StarRating({this.starCount = 5, this.rating = .0, required this.onRatingChanged, required this.color, required this.size});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        Icons.star,
        color: MyColors.PnbUnFilledRatingColor,
        size: size,
      );
    }
    else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        color: color,
        size: size,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: color,
        size: size,
      );
    }
    return GestureDetector(
      onTap: onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(children: new List.generate(starCount, (index) => buildStar(context, index)));
  }
}


class RatingBarWidget extends StatefulWidget {
  final ValueChanged<double> onRatingChanged;
  final double size;
  RatingBarWidget({Key? key,required this.onRatingChanged, required this.size}) : super(key: key);
  @override
  _RatingBarWidgetState createState() => new _RatingBarWidgetState();
}

class _RatingBarWidgetState extends State<RatingBarWidget> {
  double rating = 5;

  @override
  Widget build(BuildContext context) {
    return
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StarRating(

            rating: rating,

            onRatingChanged: (rating) {
              setState(() => this.rating = rating);
              widget.onRatingChanged(this.rating);
              ThemeHelper.getInstance()?.colorScheme.secondaryContainer;
            }, color: ThemeHelper.getInstance()!.colorScheme.secondaryContainer,
            size: widget.size,

          )
        ],
      );
  }
}