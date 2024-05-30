import Foundation

///
/// `UnownedErased` is a property wrapper to hold objects with an unowned reference when using type-erasure.
///

public typealias UnownedRouter<Route: Routable> = UnownedErased<StrongRouter<Route>>

@MainActor
@propertyWrapper
public final class UnownedErased<Value> {
    private var _value: () -> Value
    public var wrappedValue: Value {
        return _value()
    }
    public init<Erasable: AnyObject>(_ value: Erasable, erase: @escaping (Erasable) -> Value) {
        self._value = UnownedErased.createValueClosure(for: value, erase: erase)
    }
    
    private static func createValueClosure<Erasable: AnyObject>(
        for value: Erasable,
        erase: @escaping (Erasable) -> Value) -> () -> Value {
        return { [unowned value] in erase(value) }
    }
}

extension UnownedErased: Router where Value: Router {
    public typealias RouteType = Value.Route
    
    public func contextTrigger(_ route: Value.Route, with options: TransitionOptions, completion: ContextPresentationHandler?) {
        wrappedValue.contextTrigger(route, with: options, completion: completion)
    }
}
