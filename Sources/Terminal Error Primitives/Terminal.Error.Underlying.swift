public import Error_Primitives
public import Terminal_Primitive

extension Terminal.Error {

    public enum Underlying: Sendable {

        case kernel(Error_Primitives.Error)

        case platform(Error_Primitives.Error)

        case unsupported
    }
}
