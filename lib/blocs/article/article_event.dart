part of 'article_bloc.dart';

@immutable
sealed class ArticleEvent {}

class ArticleEventLoad extends ArticleEvent {
  final int level;
  ArticleEventLoad({required this.level});
}

class ArticleEventLeave extends ArticleEvent {}

class ArticleEventInitialize extends ArticleEvent {}
