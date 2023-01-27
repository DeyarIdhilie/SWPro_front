import 'package:flutter/material.dart';

  InputDecoration buildInputDecoration(IconData icons,String hinttext) {
  return InputDecoration(
    hintText: hinttext,
    prefixIcon: Icon(icons),
    contentPadding: EdgeInsets.symmetric(vertical: 3.0), // Set the 
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(
          color: Colors.grey,
          width: 1.0
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(
        color: Colors.black,
        width: 1.0,
      ),
    ),
    enabledBorder:OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(
        color: Colors.black,
        width: 1.0,
      ),
    ),
  );
}