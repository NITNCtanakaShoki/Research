import Fluent

extension SendEvent {
    struct Migration: AsyncMigration {
        
        static let schema = "send_events"
        
        func prepare(on database: Database) async throws {
            try await database.schema(Self.schema)
                .id()
                .field("from_username", .string, .required, .references("users", "name"))
                .field("to_username", .string, .required, .references("users", "name"))
                .field("point", .int, .required)
                .field("created_at", .datetime, .required)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema(Self.schema).delete()
        }
    }
}
