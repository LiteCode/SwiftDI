# SwiftDI
SwiftDI it's a tool for Dependency Injection in Swift using a new feature with  `@propertyWrapper`.
SwiftDI works with Swift 5.1 and higher. Also support with SwiftUI. 

Please looks at our demo `SwiftDIDemo`!

## Features

[x] Support SwiftUI
[x] Compile-time linter
[x] Dependency graph
[ ] Graph visualisation
[ ] Tags
[ ] [DILint] Understanding that container passed to `SwiftDI.useContainer` method
[ ] Unit tests
[ ] [DILint] Support passed properties inside `DIPart`s.


## How it use?

1) Create your assemblies extended from `DIPart`:

```swift
class MyAssembly: DIPart {
    var body: some DIPart {
        // Some Assembly parts place here
    }
}
```

2) Register your objects inside `DIPart`:

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

3) Load your `DIPart`s to the DIContainer:

```swift

let container = DIContainer(part: MyAssembly())

```

or 

```swift

let container = DIContainer()
container.appendPart(MyAssembly())

```

4) Set your container to `SwiftDI`:

```swift
SwiftDI.useContainer(container)
```

5) Use your DI

```swift 
class MyController: UIViewController {
    @Injected var service: MyServiceInput
}
```

Does it! You're finish setup your DI container.

## Scopes
SwiftDI supports object scopes, you can use method `lifeCycle`

```swift
DIRegister(MyService.init)
    .lifeCycle(.single)
```

By default life time for instance is `objectGraph`.  `objectGraph` using `Mirror` for get info about nested injectables property and it can be slowly.

## DSL

* DIGroup - Contains one or many `DIPart`s. 

```swift
DIGroup {
    // Place you DIParts here
}
```

* DIRegister - Register some object
```swift
DIRegister(MyService.init)
```

You can pass your `DIPart` to another `DIPart` for pretty flow.

## How it works?

SwiftDI using `@propertyWrapper` to use power of injection.
`@Injected` it's struct uses `SwiftDI.sharedContainer` for resolve objects when `value` is call. 

# SwiftDILint

We also support compile time checking for you dependencies. For this magic use additional tools `swiftdi`.

![](assets/swiftdilint_example.gif)

### Installation

### Using [CocoaPods](https://cocoapods.org):

```ruby
pod 'SwiftDILint'
```

This pod will download the SwiftDILint binaries in your  `Pods/`. For usage invoke it via `#{PODS_ROOT}/SwiftDILint/swiftdi` in your Script Build Phases.

### Compile from source:
You can also build SwiftDILint from source. Cloning this project and running command below:
```
$ make install
```

If you wanna uninstall SwiftDILint from you computer:
```
$ make uninstall
```

### Usage 

For integraiting SwiftDILint into Xcode for getting warnings and errors, just add a new "Run Script Phase" with:

```bash
if which swiftdi >/dev/null; then
  swiftdi validate ${SRCROOT}
else
  echo "warning: SwiftDILint not installed, download from https://github.com/LiteCode/SwiftDI"
fi
```
Or if you've installed SwiftDILint via CocoaPods the script should look like this:

```bash
`#{PODS_ROOT}/SwiftDILint/swiftdi`
```

### Flags and keys

* `--force-error`,  `-e`
Replace all warnings to errors. If compile-time checking will return `warning`, lint replace this to `error` and you build will fault.

* `--output-path`
Write to file your validation result by given path. These needs for visualization your graphs and `DIPart`s init tree.  

# SwiftDI ❤️ SwiftUI!

SwiftDI also supports `SwiftUI` framework. 
You can inject your `BindableObject` and property automatically connect to view state.
For this magic just use `@EnvironmentObservableInjected`

```swift
struct ContentView: View {
	
	@EnvironmentObservableInjected var viewModel: ContentViewModel

	var body: some View {
		HStack {
			Text(viewModel.title)
		}.onAppear { self.viewModel.getData() }
	}
}
```

For non-mutating view object use `@EnvironmentInjected`:

```swift
struct ContentView: View {
	
	@EnvironmentInjected var authService: AuthorizationService

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

Or if you wanna add some instance to container using method `environmentInject`:

```swift

// SceneDelegate.swift

let window = UIWindow(windowScene: windowScene)
let authService = AuthorizationService(window: window)

let view = HomeView().environmentInject(authService)

// etc
```
