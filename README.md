# SwiftDI
SwiftDI it's a tool for Dependency Injection using  `@propertyWrapper`. Right now SwiftDI is alpha version. **Be careful!**

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
    var body: some DIPart {
        // Some Assembly parts place here
    }
}
```

3) Register your objects:

```swift
class MyAssembly: DIPart {
    var body: some DIPart {
        DIRegister(MyService.init)
    }
}
```

you can use `as<T>(_ type: T.Type)` for set a new injection identifier:

```swift
class MyAssembly: DIPart {
    var body: some DIPart {
        DIRegister(MyService.init)
            .as (MyServiceInput.self)
    }
}
```

4) Load your `DIPart` to the container:

```swift

let container = DIContainer(part: MyAssembly())

```

or 

```swift

let container = DIContainer()
container.appendPart(MyAssembly())

```

5) Set your container to `SwiftDI`:

```swift
SwiftDI.useContainer(container)
```

6) Use your DI

```swift 
class MyController: UIViewController {
    @Injected var service: MyServiceInput
}
```

Does it! You're finish setup your DI container.

## DSL

1) DIGroup - Contains one or many `DIPart`s

```swift
DIGroup {
    // Place you DIParts here
}
```

2) DIRegister - Register some object
```swift
DIRegister(MyService.init)
```

also contains methods `lifeCycle()` and `as()`

## SwiftDI ❤️ SwiftUI!

SwiftDI also supports `SwiftUI` framework. 
You can inject your `BindableObject` and property automatically connect to view state.
For this magic just use `@EnvironmentObservedInject`

```swift
struct ContentView: View {
	
	@EnvironmentObservedInject var viewModel: ContentViewModel

	var body: some View {
		HStack {
			Text(viewModel.title)
		}.onAppear { self.viewModel.getData() }
	}
}
```

For non-mutating view object use `@EnvironmentInject`:

```swift
struct ContentView: View {
	
	@EnvironmentInject var authService: AuthorizationService

	var body: some View {
		HStack {
			Text("Waiting...")
		}.onAppear { self.authService.auth() }
	}
}
```

By default SwiftDI using shared container, but if you wanna pass custom container to view using method `inject(container:)` for view:
```swift
let container = DIContainer()

let view = HomeView().inject(container: container)
```

Or if you wanna add some method to container using method `environmentInject`:

```swift

// SceneDelegate.swift

let window = UIWindow(windowScene: windowScene)
let authService = AuthorizationService(window: window)

let view = HomeView().environmentInject(authService)

// etc
```

## Scopes
SwiftDI supports object scopes, you can use method `lifeCycle`

```swift
DIRegister(MyService.init)
	.lifeCycle(.single)
```

By default life time for instance is `objectGraph`.  `objectGraph` using `Mirror` for get info about nested injectables property and it can be slowly.

## How it works?

SwiftDI using `@propertyWrapper` to use power of injection.
`@Inject` it's struct uses `SwiftDI.sharedContainer` for resolve objects when `value` is call. 
