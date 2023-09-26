part of 'get_reviews_bloc.dart';

abstract class GetReviewsEvent extends Equatable {
  const GetReviewsEvent();

  @override
  List<Object> get props => [];
}
class GetProviderReviewsEvent extends GetReviewsEvent {
   final bool refresh;
  GetProviderReviewsEvent({
     this.refresh=false,
  });
}
