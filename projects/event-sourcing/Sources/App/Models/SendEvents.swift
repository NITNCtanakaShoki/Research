extension [SendEvent] {
    
    func point(of username: String) -> Int {
        let events = sorted()
        var points = [String: Int]()
        for event in events {
            points[event.$from.id] = (points[event.$from.id] ?? 0) - event.point
            points[event.$to.id] = (points[event.$to.id] ?? 0) + event.point
        }
        return points[username] ?? 0
    }
}
