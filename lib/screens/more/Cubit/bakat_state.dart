part of 'bakat_cubit.dart';

@immutable
sealed class BakatState {}

final class BakatInitial extends BakatState {}
final class BakatSuccess extends BakatState  {
   final List<PackageResponse> packageResponse;
   BakatSuccess(this.packageResponse);
}
final class BakatLoading extends BakatState {}
final class BakatError extends BakatState {}
