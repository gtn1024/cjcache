<div align="center">
  <h1>cjcache</h1>
  <p>Cache library supports LRU for Cangjie</p>
</div>
<p align="center">
  <img alt="" src="https://img.shields.io/badge/release-v0.1.0-brightgreen" style="display: inline-block;" />
  <img alt="" src="https://img.shields.io/badge/cjc-v0.55.3-brightgreen" style="display: inline-block;" />
</p>

## 介绍 / Introduction

**注意：** 本项目仍在开发中，API 可能会发生变化。

**Note:** This project is still under development, and the API may change.

cjcache 是一个支持 LRU 算法的缓存库。

cjcache is a cache library supports LRU.

## 安装 / Installation

```toml
# In the `dependencies` section of `cjpm.toml`
cjcache = { git = "https://github.com/gtn1024/cjcache.git", tag = "v0.1.0" }
```

## 使用 / Usage

```cj
import cjcache.cache.lru.newLRU

main(): Int64 {
    let cache = newLRU<Int64, Int64>(
        8,
        {
            k, v => println("evicted key: ${k}, value: ${v}")
        }
    )
    for (i in 0..10) {
        cache.put(i, i)
    }

    for (i in 0..5) {
        let v = match (cache.get(i)) {
            case Some(v) => v
            case None => -1
        }

        println("key: ${i}, value: ${v}")
    }
    return 0
}
```

## API

| Function | Description |
| --- | --- |
| `newLRU<K, V>(size: Int32, onEvict: ?EvictCallback<K, V>) where K <: Hashable & Equatable<K>` | Create a new LRU cache with the given capacity and evict callback |

```cj
public interface Cache<K, V> where K <: Hashable & Equatable<K> {
    func put(k: K, v: V): Bool
    func get(k: K): Option<V>
    func purge(): Unit
    func remove(k: K): Bool
    func length(): Int32
    func capacity(): Int32
}
```

## 开发计划 / Development Plan

- [ ] LRU algorithm
    - [x] without expiration time strategy
    - [ ] expire after access strategy
    - [ ] expire after write strategy
- [ ] FIFO algorithm
    - [ ] without expiration time strategy
    - [ ] expire after access strategy
    - [ ] expire after write strategy
- [ ] FILO algorithm
    - [ ] without expiration time strategy
    - [ ] expire after access strategy
    - [ ] expire after write strategy
- [ ] LFU algorithm
    - [ ] without expiration time strategy
    - [ ] expire after access strategy
    - [ ] expire after write strategy
