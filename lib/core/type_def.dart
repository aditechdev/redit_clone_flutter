// typedef FutureEither<T> = Future<Either>
import 'package:fpdart/fpdart.dart';
import 'package:redit_clone_flutter/core/failures.dart';

typedef FutureEither<T> = Future<Either<Failures, T>>;
typedef FutureVoid<T> = FutureEither<void>;
