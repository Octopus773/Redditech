/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:soreo/models/post.dart';
import 'package:soreo/repositories/post_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository repository;
  final String? subreddit;
  bool _fetching = false;

  PostBloc({
    required this.repository,
    this.subreddit
  }) : super(const PostState()) {
    on<PostFetchRequestedEvent>((event, emit) async {
      if (state.hasReachedMax || _fetching) {
        return;
      }
      try {
        _fetching = true;
        List<Post> posts = await repository.getPosts(
          subreddit: subreddit,
          sortBy: state.sortBy,
          since: state.sortSince,
          after: state.posts.isNotEmpty
            ? state.posts.last.id
            : null
        );
        emit(state.copyWith(
            posts: List.of(state.posts)..addAll(posts),
            status: PostStatus.success,
            hasReachedMax: posts.isEmpty
        ));
      } catch(e) {
        print(e);
        emit(state.copyWith(status: PostStatus.failure));
      }
      finally {
        _fetching = false;
      }
    });
    on<PostSortChangedEvent>((event, emit) async {
      emit(PostState(
        sortBy: event.sortBy,
        sortSince: event.sortSince
      ));
      add(PostFetchRequestedEvent());
    });
  }
}
