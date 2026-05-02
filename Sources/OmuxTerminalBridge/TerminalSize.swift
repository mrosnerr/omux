public struct TerminalSize: Equatable, Sendable {
    public var columns: Int
    public var rows: Int

    static let `default` = TerminalSize(columns: 80, rows: 24)

    public init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
    }
}
