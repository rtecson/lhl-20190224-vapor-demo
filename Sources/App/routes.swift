import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Respond to GET localhost:8080
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Respond to GET localhost:8080/hello
    // with "Hello, world!\n"
    router.get("hello") { req in
        return "Hello, world!"
    }

    // Respond to GET localhost:8080/description
    // With a description of the URL request
    router.get("description") { req in
        return req.description
    }
    
    // Respond to GET localhost:8080/name/Bob
    router.get("name", String.parameter) { req -> String in
        guard let name = try? req.parameters.next(String.self) else {
            return "Error retrieving parameters\n"
        }
        return "Hello \(name)\n"
    }
    
    // Respond to GET localhost:8080/user/Bob
    router.get("user", String.parameter) { req -> User in
        guard let name = try? req.parameters.next(String.self) else {
            return User(name: "", email: "")
        }
        return User(
            name: "\(name)",
            email: "\(name)@email.com"
        )
    }
    
    // Respond to POST localhost:8080/login with JSON body containing email and password
    router.post("login") { req -> Future<HTTPStatus> in
        guard let loginRequest = try? req.content.decode(LoginRequest.self) else {
            throw Abort.init(HTTPResponseStatus.badRequest)
        }
        
        return loginRequest.map(to: HTTPStatus.self) { loginRequest in
            print(loginRequest.email) // user@vapor.codes
            print(loginRequest.password) // don't look!
            return .ok
        }
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}

struct LoginRequest: Content {
    var email: String
    var password: String
}

struct User: Content {
    var name: String
    var email: String
}
