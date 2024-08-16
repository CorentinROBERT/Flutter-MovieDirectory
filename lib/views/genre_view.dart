import 'package:flutter/material.dart';
import 'package:movie_directory/models/genre.dart';

class GenreView extends StatefulWidget {
  Genre genre;
  bool isSelected = false;

  GenreView({super.key, required this.genre});

  @override
  State<StatefulWidget> createState() => GenreState();
}

class GenreState extends State<GenreView> {
  @override
  Widget build(BuildContext context) {
    return ActionChip(
        backgroundColor:
            widget.isSelected ? Colors.grey.withAlpha(100) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        onPressed: () {
          setState(() {
            widget.isSelected = !widget.isSelected;
          });
        },
        label: Text(widget.genre.name));
  }
}
