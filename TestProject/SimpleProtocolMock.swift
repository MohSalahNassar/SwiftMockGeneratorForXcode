@testable import TestProject

class AnotherDeclarationInTheFileShouldNotBeAffected {

    func shouldNotInterfere() {

    }
}

class SimpleProtocolMock: SimpleProtocol {
    <selection></selection>
}
