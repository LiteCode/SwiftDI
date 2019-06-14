# SwiftDI

It's try to use `@propertyDelegate` for DI. Right now SwiftDI is early alpha version. **Be careful!**

### How to use

1) Create your container:

```swift
let container = DIContainer()
```

2) Create your assemblies extended from `DIPart`:

```swift
class MyAssembly: DIPart {
    static func load(container: DIContainer)
}
```

3) Register your objects:

```swift
container.register(MyService.init)
```

you can use `as<T>(_ type: T.Type)` for set a new injection identifier:

```swift
container.register(MyService.init)
    .as (MyServiceInput.self)
```

4) Load your `DIPart` to the container:

```swift

let container = DIContainer()
container.loadPart(MyAssembly.self)

```

5) Set your container to `SwiftDI`:

```swift
SwiftDI.sharedContainer = container
```
