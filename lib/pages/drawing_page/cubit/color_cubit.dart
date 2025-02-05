import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorCubit extends Cubit<Color> {
  ColorCubit() : super(Colors.black);

  void changeColor({required Color color}) {
    if (!isClosed) {
      emit(color);
    }
  }
}
