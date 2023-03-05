import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoveIcon extends StatefulWidget {
  final bool isLiked;
  final VoidCallback onTap;

  LoveIcon({required this.isLiked, required this.onTap});

  @override
  _LoveIconState createState() => _LoveIconState();
}

class _LoveIconState extends State<LoveIcon> {
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Icon(
          _isLiked ? Icons.favorite : Icons.favorite,
          color: _isLiked ? Colors.red : Colors.grey[200],
          size: 20,
        ),
      ),
      onTap: () {
        setState(() {
          _isLiked = !_isLiked;
          widget.onTap();
        });
      },
    );
  }
}
