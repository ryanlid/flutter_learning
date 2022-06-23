import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/Note.dart';

// 笔记操作结果
enum NoteOperationRet {
  success,
  noteIsAlreadyExist,
  noteIsNotExited,
}

class NoteStore extends StatefulWidget {
  final Widget child;

  const NoteStore(this.child, {Key? key}) : super(key: key);

  @override
  State<NoteStore> createState() => _NoteStoreState();
}

class _NoteStoreState extends State<NoteStore> {
  final Map<String, Note> notes = {};

  // 创建笔记
  Future<NoteOperationRet> createNewNote(Note note) async {
    print('createNote');
    if (notes.containsKey(note.uuid)) {
      return NoteOperationRet.noteIsAlreadyExist;
    }
    await _saveNoteToDisk(note);

    setState(() {
      notes[note.uuid] = note;
    });

    return NoteOperationRet.success;
  }

  // 保存
  Future<void> _saveNoteToDisk(Note note) async {
    print('_saveNoteToDisk');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(note.uuid, json.encode(note.toJson()));
  }

  Future<NoteOperationRet> removeNote(String uuid) async {
    if (!notes.containsKey(uuid)) {
      return NoteOperationRet.noteIsNotExited;
    }
    _removeNoteFromDisk(uuid);
    setState(() {
      notes.remove(uuid);
    });
    return NoteOperationRet.success;
  }

  // 从磁盘删除笔记
  Future<void> _removeNoteFromDisk(String uuid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(uuid);
  }

  Future<NoteOperationRet> loadNotes() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      for (String key in preferences.getKeys()) {
        var str = preferences.getString(key);
        notes[key] = Note.fromJson(json.decode(str!));
      }
    });
    return NoteOperationRet.success;
  }

  @override
  Widget build(BuildContext context) {
    return _NoteStoreScope(this, widget.child);
  }
}

class _NoteStoreScope extends InheritedWidget {
  final _NoteStoreScope _noteStoreScope;

  const _NoteStoreScope(this._noteStoreScope, Widget child)
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
