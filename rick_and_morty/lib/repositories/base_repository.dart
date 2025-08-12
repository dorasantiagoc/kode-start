abstract class BaseRepository<T> {
  Future<List<T>> getAll();
  Future<T> getById(int id);
  Future<List<T>> search(String query);
}
