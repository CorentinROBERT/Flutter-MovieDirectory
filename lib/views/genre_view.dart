import 'package:flutter/material.dart';
import 'package:movie_directory/models/genre.dart';

class GenreView extends StatefulWidget {
  Genre genre;
  bool isSelected = false;
  Function(GenreView) onTap;

  GenreView({super.key, required this.genre, required this.onTap});

  @override
  State<StatefulWidget> createState() => GenreState();
}

class GenreState extends State<GenreView> {
  bool isSelected = false;

  @override
  void initState() {
    isSelected = widget.isSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ActionChip(
        backgroundColor: isSelected ? Colors.grey.withAlpha(100) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        onPressed: () {
          setState(() {
            widget.isSelected = !widget.isSelected;
            isSelected = !isSelected;
          });
          widget.onTap(widget);
        },
        label: Text(widget.genre.name));
  }
}
