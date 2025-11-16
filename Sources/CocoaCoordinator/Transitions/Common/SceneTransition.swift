#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public typealias SceneTransition<WindowController: NSWindowController, ViewController: NSViewController> = Transition<WindowController, ViewController>

public typealias BasicSceneTransition = SceneTransition<NSWindowController, NSViewController>

#endif
