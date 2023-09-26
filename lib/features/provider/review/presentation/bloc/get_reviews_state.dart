// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_reviews_bloc.dart';

enum GetReviewStatus { loading,loadingMore, success, offline, error }

class GetReviewsState extends Equatable {
  final GetReviewStatus status;
  final List<ReviewEntity> data;
  final int pageNumber;
  final bool hasReachedMax;
final int total;
  final String errorMessage;

  const GetReviewsState(
      {this.status = GetReviewStatus.loading,
      this.hasReachedMax = false,
      this.data = const [],
      this.pageNumber = 1,
      this.errorMessage = "",
      this.total=0});

  @override
  List<Object> get props => [
        status,
        hasReachedMax,
        pageNumber,
        data,
        errorMessage,
        total
      ];



  GetReviewsState copyWith({
    GetReviewStatus? status,
    List<ReviewEntity>? data,
    int? pageNumber,
    bool? hasReachedMax,
    int? total,
    String? errorMessage,
  }) {
    return GetReviewsState(
     status: status ?? this.status,
    data:  data ?? this.data,
   pageNumber:   pageNumber ?? this.pageNumber,
    hasReachedMax:  hasReachedMax ?? this.hasReachedMax,
    total:  total ?? this.total,
     errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
