/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soreo/blocs/posts/post_bloc.dart';
import 'package:soreo/models/post.dart';

class PostListView extends StatefulWidget {
  const PostListView({Key? key}) : super(key: key);

  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostListView> {
  final _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll * 0.9)) {
      context.read<PostBloc>().add(PostFetchRequestedEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
        builder: (child, state) {
        switch (state.status) {
          case PostStatus.initial:
            return const Center(child: CircularProgressIndicator());
          case PostStatus.failure:
            return const Center(child: Text("Failed to fetch posts."));
          case PostStatus.success:
            return ListView.builder(
              itemCount: state.posts.length + (state.hasReachedMax ? 0 : 1),
              controller: _scrollController,
              itemBuilder: (ctx, index) => index < state.posts.length
                ? _PostView(post: state.posts[index])
                : const Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 1.5),
                    ),
                  )
            );
        }
      }
    );
  }
}

class _PostView extends StatelessWidget {
  final Post post;

  const _PostView({
    required this.post,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Text(post.title);
  }
}