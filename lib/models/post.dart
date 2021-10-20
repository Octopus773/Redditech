/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:equatable/equatable.dart';

enum PostSort {
  hot,
  random,
  rising,
  controversial,
  news,
  best,
  top
}

enum PostSortSince {
  none,
  hour,
  day,
  week,
  month,
  year,
  all
}

class Post extends Equatable {
  final String id;
  final String title;
  final String? text;

  const Post({
    required this.id,
    required this.title,
    required this.text
  });

  @override
  List<Object?> get props => [id, title, text];
}