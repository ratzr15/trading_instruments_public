extension MapExtensions<K, V> on Map<K, V> {
  List<T>? optTypedList<T>(K key) {
    try {
      return optList(key)?.map<T>((e) => e as T).toList();
    } catch (_) {
      return null;
    }
  }

  List<dynamic>? optList(K key) {
    return this[key] as List<dynamic>?;
  }
}
