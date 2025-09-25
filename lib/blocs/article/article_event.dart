part of 'article_bloc.dart';

@immutable
sealed class ArticleEvent {}

class ArticleEventLoad extends ArticleEvent {
  final Level level;
  final String currentWord;
  ArticleEventLoad({required this.level, required this.currentWord});
}

class ArticleEventLeave extends ArticleEvent {}

class ArticleEventInitialize extends ArticleEvent {}
