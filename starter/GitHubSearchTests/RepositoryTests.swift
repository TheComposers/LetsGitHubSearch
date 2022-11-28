import XCTest

import ComposableArchitecture

@testable import GitHubSearch

@MainActor
final class RepositoryTests: XCTestCase {
  func test_searchResults_whenSearch() async {
    // # Arrange
    // TestStore를 생성합니다.

    // # Act & Assert
    // 1. Swift 키워드가 입력됐을 때, store의 `keyword` state가 "Swift"인지 테스트합니다.
    // 2. 검색을 했을 때, 예상하는 검색 결과가 나오는지를 테스트합니다.
  }
}
