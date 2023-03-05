import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  final int starCount;
  final double rating;
  final Color color;
  final double size;
  final Function(int) onRatingChanged;

  StarRating({
    this.starCount = 5,
    this.rating = .0,
    required this.color,
    this.size = 20.0,
    required this.onRatingChanged,
  });

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating.toInt();
  }

  Widget buildStar(BuildContext context, int index) {
    IconData iconData = Icons.star;
    Color iconColor = widget.color ?? Theme.of(context).primaryColor;
    if (index >= _currentRating) {
      iconData = Icons.star_border;
      iconColor = iconColor.withOpacity(0.5);
    } else if (index > _currentRating - 1 && index < _currentRating) {
      iconData = Icons.star_half;
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentRating = index + 1;
        });
        widget.onRatingChanged(_currentRating);
      },
      child: Icon(
        iconData,
        color: iconColor,
        size: widget.size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children:
          List.generate(widget.starCount, (index) => buildStar(context, index)),
    );
  }
}
