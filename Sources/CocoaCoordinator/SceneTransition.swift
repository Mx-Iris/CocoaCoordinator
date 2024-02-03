#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public typealias SceneTransition<W: NSWindowController, V: NSViewController> = Transition<W, V>
public typealias BasicSceneTransition = SceneTransition<NSWindowController, NSViewController>

#endif
