import AppKit

final class GlobalPopover: NSObject, NSPopoverDelegate {
    static public let shared = GlobalPopover()
    
    private let popover = NSPopover()
    
    private override init() {
        super.init()
        popover.delegate = self
    }
    
    public func show(viewController: NSViewController, relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) {
        popover.contentViewController = viewController
        popover.show(relativeTo: positioningRect, of: positioningView, preferredEdge: preferredEdge)
    }
    
    public func close() {
        popover.close()
    }
    
    public func popoverDidClose(_ notification: Notification) {
        popover.contentViewController = nil
    }
}
