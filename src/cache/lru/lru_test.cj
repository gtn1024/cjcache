package cjcache.cache.lru

import std.unittest.*
import std.unittest.testmacro.*

var evictCounter = 0
@Test
func testLRU() {
    evictCounter = 0
    let l = newLRU<Int64, Int64>(128, { k, v =>
        @Expect(k, v)
        evictCounter++
    })

    for (i in 0..256) {
        l.add(i, i)
    }
    @Expect(l.length(), 128)
    @Expect(l.capacity(), 128)
    @Expect(evictCounter, 128)

    let keys = l.keys()
    for (i in 0..keys.size) {
        @Expect(keys[i], 255 - i)

        let v = match(l.get(keys[i])) {
            case Some(v) => v
            case None => -1
        }
        @Expect(v, 255 - i)
    }

    let values = l.values()
    for (i in 0..values.size) {
        @Expect(values[i], 128 + i)
    }

    for (i in 0..128) {
        @Expect(l.get(i), None)
    }

    for (i in 128..256) {
        @Expect(l.get(i), Some(i))
    }

    for (i in 128..192) {
        @Expect(l.remove(i), true)
        @Expect(l.remove(i), false)
        @Expect(l.get(i), None)
    }
    l.get(192) // 192 in first
    let keys2 = l.keys()
    @Expect(keys2[0], 192)

    l.purge()
    @Expect(l.length(), 0)
    @Expect(l.get(200), None)
}
