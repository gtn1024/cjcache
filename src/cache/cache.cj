package cjcache.cache

public interface Cache<K, V> where K <: Hashable & Equatable<K> {
    func put(k: K, v: V): Bool
    func get(k: K): Option<V>
    func purge(): Unit
    func remove(k: K): Bool
    func length(): Int32
    func capacity(): Int32
    func keys(): Array<K>
    func values(): Array<V>
}
