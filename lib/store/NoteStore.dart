import 'package:flutter/material.dart';

class NoteStore extends StatefulWidget {
  const NoteStore({Key? key}) : super(key: key);

  final Widget child;
  NoteStore(this.child);

  @override
  State<NoteStore> createState() => _NoteStoreState();
}

class _NoteStoreState extends State<NoteStore> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
