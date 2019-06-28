# SwiftDI
SwiftDI it's a tool for Dependency Injection using  `@propertyDelegate`. Right now SwiftDI is alpha version. **Be careful!**

SwiftDI works with Swift 5.1 only and SwiftUI. 

Please looks at our demo `SwiftDIDemo`!

## How it use?

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
container.appendPart(MyAssembly.self)

```

5) Set your container to `SwiftDI`:

```swift
SwiftDI.useContainer(container)
```

6) Use your DI

```swift 
class MyController: UIViewController {
    @Injectable var service: MyServiceInput
}
```

Does it! You're finish setup your DI container.

## SwiftDI ❤️ SwiftUI!

SwiftDI also supports `SwiftUI` framework. You can inject `BindableObject` and property automatically connect to view state.
For this magic just use `@BindObjectInjectable`

```swift
struct ContentView: View {
	
	@BindObjectInjectable var viewModel: ContentViewModel

	var body: some View {
		HStack {
			Text(viewModel.title)
		}.onAppear { self.viewModel.getData() }
	}
}
```

## Scopes
SwiftDI supports object scopes, you can use method `lifeCycle`

```swift
container.register(MyService.init)
	.lifeCycle(.single)
```

## How it works?

SwiftDI using `@propertyDelegate` to use power of injection.
`@Injectable` it's struct uses `SwiftDI.sharedContainer` for resolve objects when `value` is call. 

## Needs more power?
Just plugin other DI Framework and conform container to the protocol `DIContainerConvertible`

## I don't test this:
1. Dependency cycles
2. Multi-bundle support
3. In prod
