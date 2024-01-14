import AppKit

final class ModalWindowManager: NSObject, NSWindowDelegate {
    public static let shared = ModalWindowManager()

    private var sessions: [Int: NSApplication.ModalSession] = [:]

    public var windowClass: NSWindow.Type?
    
    @discardableResult
    public func beginModalSession(for viewController: NSViewController) -> NSWindow {
        let window = NSWindow(contentViewController: viewController)
        window.styleMask = [.closable, .titled]
        window.titleVisibility = .hidden
        window.delegate = self
        let session = NSApplication.shared.beginModalSession(for: window)
        window.center()
        setModalSession(session, for: window)
        return window
    }

    public func endModalSession() {
        guard let currentModalWindow = NSApplication.shared.modalWindow else { return }
        currentModalWindow.close()
    }

    private func setModalSession(_ session: NSApplication.ModalSession, for window: NSWindow) {
        sessions[window.windowNumber] = session
    }

    public func windowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSWindow, let session = sessions[window.windowNumber] else { return }
        NSApplication.shared.endModalSession(session)
        sessions.removeValue(forKey: window.windowNumber)
    }
}
