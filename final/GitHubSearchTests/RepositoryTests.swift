import XCTest

import ComposableArchitecture

@testable import GitHubSearch_final

@MainActor
final class RepositoryTests: XCTestCase {
  func test_user_get_repoSearchResults_when_search() async {
    // Arrange
    // TestStore를 생성합니다.

    // Act & Assert
    // 1. "Swift"를 입력했을 때, state.keyword가 "Swift"인지 테스트합니다.
    // 2. 검색을 했을 때, 예상하는 검색 결과가 나오는지를 테스트합니다.
  }
}
