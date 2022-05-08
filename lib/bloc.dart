abstract class Bloc<T> {
  Stream<T> get stream;
  void dispose();
}
