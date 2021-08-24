# WordAssociate

The word association system can be established more quickly and uses less memory.

## Performance

In the case of a large amount of data, WA's search speed is faster, 8 times faster, with a small amount of data, the speed is a bit slower than using an array to search
> The speed is not necessarily accurate. After multiple tests, the speed of WA will be slower than the array search
Howerver if you serach in 1000000 words, WA only need 0.002s, tranditional way need 0.625s. Wow, Amazing.

## Creat WordAssociate

You can use default WordAssociate by `WordAssociate.shared`

And you can alse creat a custom WordAssociate via `WordAssociate.getWordAssociate("...")`

## Add a word

```swift
WordAssociate.shared.add("SomeThing")
```

Alos you can use `async` func in the macOS12 or iOS15
```swift
await WordAssociate.shared.add("SomeThing")
```

## Get words

```swift
WordAssociate.shared.get("...")
```

But this will return nothing. You can use `WordAssociate.shared.res` to get result.
