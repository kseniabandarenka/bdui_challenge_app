import 'package:json_annotation/json_annotation.dart';

enum BDUIType {
  @JsonValue('screen')
  screen,
  
  @JsonValue('column')
  column,
  
  @JsonValue('container')
  container,
  
  @JsonValue('row')
  row,
  
  @JsonValue('text')
  text,
  
  @JsonValue('button')
  button,
  
  @JsonValue('progress_bar')
  progressBar,
  
  @JsonValue('text_field')
  textField,
  
  @JsonValue('challenge_card')
  challengeCard,
  
  @JsonValue('challenge_list')
  challengeList,
  
  @JsonValue('number_input')
  numberInput,
}