import 'package:bloc/bloc.dart';
import 'package:examKing/models/article_part.dart';
import 'package:examKing/service/backend.dart';
import 'package:meta/meta.dart';

part 'article_event.dart';
part 'article_state.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  List<ArticlePart>? article;
  int? level;

  BackendService backendService = BackendService();

  void initialize() {
    level = null;
    article = null;
  }

  ArticleBloc() : super(ArticleInitial()) {
    on<ArticleEventLoad>((event, emit) async {
      emit(ArticleStateLoading());
      level = event.level;
      article = await backendService.getArticle(event.level);
      emit(ArticleStateGetArticle());
    });

    on<ArticleEventInitialize>((event, emit) {
      emit(ArticleStateLoading());
    });
    on<ArticleEventLeave>((event, emit) {
      initialize();
    });
  }
}
