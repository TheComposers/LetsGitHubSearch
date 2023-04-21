import Foundation

public extension Data {
  func decodableData<T: Decodable>(of type: T.Type) throws -> T {
    let decoder = JSONDecoder()
    do {
      return try decoder.decode(type, from: self)
    } catch {
      throw APIError.decodingError
    }
  }
}
