package cjcache.cache.lru

import std.collection.{LinkedList, HashMap, LinkedListNode, ArrayList}

type EvictCallback<K, V> = (K, V) -> Unit

public struct Entry<K, V> {
    let k: K
    let v: V

    public init(k: K, v: V) {
        this.k = k
        this.v = v
    }
}

public class LRU<K, V> where K <: Hashable & Equatable<K> {
    internal let size: Int32
    internal let evictList: LinkedList<Entry<K, V>>
    internal let items: HashMap<K, LinkedListNode<Entry<K, V>>>
    internal let onEvict: ?EvictCallback<K, V>

    internal init(size: Int32, onEvict: ?EvictCallback<K, V>) {
        this.size = size
        this.onEvict = onEvict
        this.evictList = LinkedList<Entry<K, V>>()
        this.items = HashMap<K, LinkedListNode<Entry<K, V>>>()
    }

    public func purge() {
        for ((k, v) in this.items) {
            this.onEvict?(k, v.value.v)
        }
        this.items.clear()
        this.evictList.clear()
    }

    public func put(k: K, v: V) {
        // Check for existing item
        if (this.items.contains(k)) {
            let node = this.items[k]
            this.evictList.remove(node)
            this.evictList.prepend(Entry(k, v))
            return false
        }

        // Add new item
        let node = this.evictList.prepend(Entry(k, v))
        this.items.put(k, node)

        let evict = Int32(this.evictList.size) > this.size
        if (evict) {
            this.removeOldest()
        }

        evict
    }

    internal func removeOldest(): Unit {
        let node = match(this.evictList.lastNode()) {
            case Some(n) => n
            case None => return
        }
        this.removeElement(node)
    }

    internal func removeElement(node: LinkedListNode<Entry<K, V>>) {
        let k = node.value.k
        let v = node.value.v
        this.items.remove(k)
        this.evictList.remove(node)
        this.onEvict?(k, v)
    }

    public func length() {
        Int32(this.evictList.size)
    }

    public func capacity() {
        this.size
    }

    /**
     * Returns a list of the keys in the LRU cache, from newest to oldest.
     */
    public func keys(): Array<K> {
        let list = ArrayList<K>(this.evictList.size)
        for (node in this.evictList) {
            list.append(node.k)
        }
        return list.toArray()
    }

    /**
     * Returns a list of the values in the LRU cache, from newest to oldest.
     */
    public func values(): Array<V> {
        let list = ArrayList<V>(this.evictList.size)
        for (node in this.evictList) {
            list.append(node.v)
        }
        return list.toArray()
    }

    public func get(k: K): ?V {
        if (this.items.contains(k)) {
            var node = this.items[k]
            let value = node.value
            this.evictList.remove(node)
            node = this.evictList.prepend(value)
            this.items.put(k, node)
            return Some(this.items[k].value.v)
        }
        return None
    }

    public func remove(k: K) {
        if (this.items.contains(k)) {
            let node = this.items[k]
            this.removeElement(node)
            return true
        }
        false
    }
}

public func newLRU<K, V>(size: Int32, onEvict: ?EvictCallback<K, V>) where K <: Hashable & Equatable<K> {
    LRU<K, V>(size, onEvict)
}
