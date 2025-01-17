part of 'article_bloc.dart';

@immutable
sealed class ArticleState {}

final class ArticleInitial extends ArticleState {}

final class ArticleStateLoading extends ArticleState {}

final class ArticleStateGetArticle extends ArticleState {}

final class ArticleStateError extends ArticleState {
  final Exception exception;
  ArticleStateError({required this.exception});
}
