# SimpleDeviceId
Simple Device Identifier retrieval framework

# Usage
```swift
    let deviceIdRetrieval = SimpleDeviceId()
    do {
        let deviceId = deviceIdRetrieval.getDeviceId() // always returns value or throws
    } catch e {
        // handle errors (see caveats below)
    }
```

See the Example folder for a sample project/usage.

# Identifier Stability and Caveats
## What is Identifier Stability?
Identifier stability refers to the ability of the `getDeviceId()` method to return the same value between calls for the same combination of device + application/vendor.

## Identifier Stability in SimpleDeviceId
SimpleDeviceId makes the best effort to keep the identifier stable even between application reinstalls. The core functionality depends on the `identifierForVendor` API that obtains `UUID` for the current device + vendor (appId prefix) combination [[official docs](https://developer.apple.com/documentation/uikit/uidevice/1620059-identifierforvendor)]. Since the `identifierForVendor` output changes between application reinstalls (to be precise only when there are no other apps from the same vendor left on the device), the framework saves the latest value in the Keychain. The Keychain data don't get deleted along with the app which enables the framework to improve the identifier stability (i. e. the ID is loaded from the Keychain if possible).

There is unfortunately *no guarantee* that the Keychain behaviour remains the same between iOS versions (it already broke once for 10.3 iOS beta version [[link](https://developer.apple.com/forums/thread/36442?answerId=281900022#281900022)]) so we recommend to use the framework with caution for use cases where identifier stability determines efficacy.

## Other Caveats
Apple documentation mentions that the underlying *UIDevice* API might return `nil` in [some scenarios](https://developer.apple.com/documentation/uikit/uidevice/1620059-identifierforvendor), especially when the device is not ready or hasn't been previously unlocked after a restart. If the *UIDevice* API fails to return a valid value and a fallback value isn't found in the Keychain, a specific error (<specific error class/enum name>) is thrown to indicate it.

## Possible Replacements

### AdvertisingIdentifier
iOS already has the ability to provide a stable identifier for advertising purposes. This framework does not make use of it because it requires a permission prompt from the user. See the [official Apple documentation](https://developer.apple.com/documentation/adsupport/asidentifiermanager/1614151-advertisingidentifier) for details.

### DeviceCheck
If the main incentive for stems from the need for fraud detection, Apple provides an API to set a flag on a potentially fraudulent device that helps it to identify the device in the future. See the [DeviceCheck API documentation](https://developer.apple.com/documentation/devicecheck) for further details.

# Distribution Options
Most mature projects/frameworks provide multiple options to choose from in the realm of package distribution. Well know package managers include CocoaPods, Carthage and Swift Package Manager. There are also ways to distribute the framework in its binary form

## CocoaPods
Package manager with centralised approach and focus on simplicity of use. Packages are defined through `.podspec` files (ruby scripts) that are stored in an official git *Specs* repository. This fact opens _CocoaPods_ to supply chain disruptions (already happened in the past). CocoaPods also supports private *Specs* repositories to make development and distribution of private frameworks simpler.

It handles dependency management through modification of the original Xcode project (creates a workspace with original project and a separate project for the dependencies) and therefore "automates" the process for the user. Sometimes it falls short of this promise because non-standard configuration usually requires hacks or manual modification of the generated Xcode project. Any modifications and newly introduced features also tend to break CocoaPods installations for new Xcode releases.

CocoaPods always compiles the project from the source code which offers the possibility to generate either static libraries or framework bundles (through the `use_frameworks` Podfile option). This might also trigger unnecessary recompilation of dependencies and result in longer builds times during development. 

CocoaPods goes beyond package management and offers various plugins that can automate steps in the development process (e.g. a plugin that stores project secrets in a local keychain and substitutes secret variables for the values during compliation so that the secrets are not stored in the repository).

## Carthage
Carthage focuses on unobtrusive dependency management that does not interfere with the configuration of the original project. That means that there is no modification to the .xcodeproj file but it also requires the user to add the frameworks manually to the project after they were compiled from the command line.

Unlike CocoaPods, it has no centralised repository of package specifications and intead uses simple references to git repositories or local files. It can automatically detect the framework targets in an .xcodeproj file in the specified repository and builds them according to the options. Since the tool itself does not check the integrity of the project, the compilation is not guaranteed to succeed.

The main advatage of Carthage is the compile-once approach which builds the frameworks beforehand and never recompiles them among with the main project. That can potentially speed up compilation times and the development process itself. Carthage currently does not support standalone static libraries (i.e. libraries have to be wrapped inside a framework to be compatible).

## Swift Package Manager
Package management solution officially supported by Apple (and Xcode). It's based on a decentralised access to package definitions - every unofficial package has to be added as a separate repository manually. It supports Linux as well (unlike the other mentioned package managers, which are supported on iOS/macOS only). 

The package requires a specific fixed source code structure which might make it harder to adopt for someone who wants to support the other package managers. Futhermore, the build configuration is defined through a Package.swift file and does not use config from .xcodeproj files (although SPM can generate .xcodeproj file from the package definition from the CLI).

SPM is still a fairly new project so some older frameworks might not support it as a distribution option which makes it complicated to use at scale.

## Direct Distribution
Using a package manager might not always be an option. The most versatile approach to code distribution (except providing the source code directly with build instructions) is to provide a prebuild binary that can be downloaded manually. This allows everyone to chose their own preferred way of dependency management. It has to be kept in mind that this is meant for experienced users only and can discourage newcomers from using the framework if no other options are provided.

### Static/Dynamic Libraries
It's possible to create a target that compiles to a library and distribute it in its binary form. The problematic part is that the library is tied to a specific architecture and has to be distributed alongside with its header files.

### XCFramework
Xcode officially supports binary distribution method called XCFramework. XCFramework is a bundle that may contain binaries for multiple different architectures (and furthermore can contain different library versions for backwards compatibility). It's also possible to distribute the entire framework in its binary form as a Swift package through SPM (see [docs](https://developer.apple.com/documentation/swift_packages/distributing_binary_frameworks_as_swift_packages)). Unlike a static library, the XCFramework contains header files and other resources which ensures that it can be distributed as a single entity/file.
