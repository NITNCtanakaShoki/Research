import Vapor
import Fluent
import PostgresKit

struct SendController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let point = routes.grouped("send", ":from", ":to")
        point.post(use: send)
    }
    
    func send(req: Request) async throws -> HTTPStatus {
        guard
            let fromUsername = req.parameters.get("from"),
            let toUsername = req.parameters.get("to")
        else {
            throw Abort(.badRequest)
        }
        
        let content = try req.content.decode(Point.self)
        
        guard
            let _ = try await User.find(fromUsername, on: req.db),
            let _ = try await User.find(toUsername, on: req.db)
        else {
            throw Abort(.notFound, reason: "Not Found User of \(fromUsername) or \(toUsername)")
        }
        
        try await req.db.transaction { transaction in
            _ = try await (transaction as! SQLDatabase).raw("""
                UPDATE users
                   SET point = point - \(bind: content.point)
                 WHERE name = \(bind: fromUsername)
            """).all()
            _ = try await (transaction as! SQLDatabase).raw("""
                UPDATE users
                   SET point = point + \(bind: content.point)
                 WHERE name = \(bind: toUsername)
            """).all()
        }
        return .ok
    }
}


fileprivate struct Point: Content {
    var point: Int
}
