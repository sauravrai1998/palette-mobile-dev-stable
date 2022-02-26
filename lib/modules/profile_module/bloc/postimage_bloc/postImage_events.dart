abstract class PostImageEvent {}

class PostImageUrlEvent extends PostImageEvent {
  final String url;
  PostImageUrlEvent({required this.url});
}
