# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Test Commands

```bash
# Build all targets
swift build 2>&1 | xcsift

# Run tests
swift test 2>&1 | xcsift

# Build specific target
swift build --target CocoaCoordinator 2>&1 | xcsift
```

## Package Structure

Four library targets with layered dependencies:

| Target | Depends On | Purpose |
|---|---|---|
| `CocoaCoordinator` | AppKit | Core framework |
| `RxCocoaCoordinator` | CocoaCoordinator + RxSwift/RxCocoa | Reactive extensions |
| `OpenUXKitCoordinator` | CocoaCoordinator + OpenUXKit | UIKit-style push/pop navigation |
| `UXKitCoordinator` | CocoaCoordinator + UXKit (private) | Empty target; re-exports UXKit product |

`Package.swift` has a local-first dependency resolution pattern: when the package is used in a workspace (not cloned into `.build/checkouts`), it prefers local sibling packages over remote ones. OpenUXKit resolves to `../../../../Personal/Library/macOS/OpenUXKit` when available.

## Architecture: Abstraction Hierarchy

The framework implements the Coordinator pattern for macOS (AppKit). Abstractions from low-level to high-level:

**`Routable`** — Marker protocol. User-defined route enums conform to this (no methods required).

**`Transition<WindowController, ViewController>`** — Generic value type that wraps navigation behavior in a closure. Three type aliases simplify usage:
- `ViewTransition<VC>` / `BasicViewTransition` — operates only on a `NSViewController`
- `SceneTransition<WC, VC>` / `BasicSceneTransition` — operates on both `NSWindowController` + `NSViewController`
- `AppTransition` — no VC/WC context (side effects only)

**`TransitionProtocol`** — What a Transition must implement (`perform`, `multiple`). `multiple(_:)` chains transitions sequentially.

**`TransitionPerformer`** — Single method `performTransition(_:with:completion:)`. Implemented by `Coordinator`.

**`Router<Route>`** — External interface for triggering navigation. Callers hold `any Router<MyRoute>` (not a concrete coordinator). Convenience overloads all funnel into `contextTrigger`.

**`Coordinating`** — Combines `Router` + `TransitionPerformer` + parent/children tree management. `prepareTransition(for:)` is the single abstract method subclasses must implement.

**`Coordinator<Route, Transition>`** — Base class inheriting `NSResponder`. Participates in AppKit responder chain. `didCompleteTransition` is `package`-level, injected by `RxCocoaCoordinator`.

**`ViewCoordinator<Route, Transition>`** — Holds a `rootViewController`. Conforms to `Presentable` so it can be embedded. On `performTransition`, inserts itself into the VC's `nextResponder` chain and auto-adds child coordinators from the transition's `presentables`.

**`SceneCoordinator<Route, Transition>`** — Holds an `NSWindowController`. On `performTransition`, passes both the window controller and its `contentViewController` to the transition.

**`RedirectionRouter<ParentRoute, Route>`** — Translates child-module routes to parent routes. Useful for modular route decomposition without coupling parent to child route enums.

## Key Patterns

**Adding a new route flow:**
1. Define a `Routable` enum for your routes
2. Subclass `ViewCoordinator` (embedded VC flow) or `SceneCoordinator` (window flow)
3. Override `prepareTransition(for:) -> Transition` — return a `Transition` static factory method
4. Override `performTransition` if you need custom context beyond the default

**Transition factory methods** (on `Transition` extensions):
- `.present(_:mode:)` / `.dismiss()` — modal presentation modes (sheet, popover, animator, transition)
- `.set(_:)` on `NSSplitViewController` — set split pane children (2-, 3-, or 4-column layouts)
- `.select(index:)` / `.set(_:)` on `NSTabViewController`
- `.show()` / `.close()` / `.beginSheet(_:)` on `NSWindowController`
- `.none()`, `.multiple(_:)`, `.route(_:on:)`, `.trigger(_:on:)`

**Rx bindings** (`RxCocoaCoordinator`):
- `router.rx.trigger()` → `AnyObserver<Route>` — bind Observable<Route> directly to routing
- `coordinator.rx.didCompleteTransition()` → `Observable<Route>` — observe route completions

**Responder chain integration:** Both `ViewCoordinator` and `SceneCoordinator` call `setupNextResponder()` before each transition, inserting themselves between the root VC/WC and the next responder. This allows coordinators to handle `@IBAction` methods.

**Child lifecycle:** `removeChildrenIfNeeded()` is called automatically after each transition. It uses `canBeRemovedAsChild()` (checks whether the coordinator's `rootViewController` is still in the view hierarchy) to prune stale child coordinators.

## Utility Singletons

- `ModalWindowManager` — tracks `NSApplication.ModalSession` per window; auto-cleans on `windowWillClose`
- `GlobalPopover` — maintains a single global `NSPopover`; nils `contentViewController` on close
- `SheetWindowManager` — tracks `fromWindow → sheetWindow` pairs for `endSheet`
