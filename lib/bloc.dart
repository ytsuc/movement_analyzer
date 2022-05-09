abstract class Bloc<T> {
  // Providerを使ったBLoCパターンを利用するためのクラス
  Stream<T> get stream;
  void dispose();
}
