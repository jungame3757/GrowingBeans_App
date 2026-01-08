# GitHub 관리 가이드: GrowingBeans 프로젝트 🌱

이 문서는 GrowingBeans 프로젝트의 효율적인 개발과 코드 관리를 위한 GitHub 운영 방식을 설명합니다.

## 1. 브랜치 전략 (Git Flow 기초)

프로젝트의 안정성을 유지하기 위해 다음과 같은 브랜치 구조를 권장합니다.

- **`master` (또는 `main`)**: 
  - 사용자가 사용하는 **배포용** 브랜치입니다.
  - 항상 실행 가능한 안정적인 코드만 포함해야 합니다.
- **`test` (또는 `develop`)**: 
  - 새로운 기능들이 통합되는 **개발용** 메인 브랜치입니다.
  - 기능 개발이 완료되면 이곳에서 테스트를 거친 후 `master`로 병합합니다.
- **기능별 브랜치 (`feature/기능이름`)**: 
  - 특정 기능(예: `feature/login`, `feature/quiz-ui`)을 개발할 때 생성합니다.
  - 개발 완료 후 `test` 브랜치로 Pull Request를 통해 병합합니다.

---

## 2. 작업 워크플로우

새로운 기능을 추가할 때의 일반적인 순서입니다.

1.  **브랜치 생성**: `git checkout -b feature/new-feature`
2.  **코드 작업**: 기능 구현 및 로컬 테스트
3.  **커밋 및 푸시**: 
    - `git add .`
    - `git commit -m "feat: 새로운 퀴즈 유형 추가"`
    - `git push origin feature/new-feature`
4.  **Pull Request (PR) 생성**: GitHub에서 `feature` 브랜치를 `test` 브랜치로 합쳐달라는 요청을 보냅니다.
5.  **검토 및 병합**: 코드를 확인하고 문제가 없으면 병합(Merge)합니다.

---

## 3. 커밋 메시지 규칙 (Convention)

어떤 작업이 이루어졌는지 한눈에 알 수 있도록 규칙을 정하는 것이 좋습니다.

| 타입 | 의미 | 예시 |
| :--- | :--- | :--- |
| **feat** | 새로운 기능 추가 | `feat: 캐릭터 애니메이션 추가` |
| **fix** | 버그 수정 | `fix: 진행 바 계산 오류 수정` |
| **docs** | 문서 수정 | `docs: README.md 업데이트` |
| **style** | 코드 포맷팅, 스타일 수정 (로직 변경X) | `style: 오타 수정 및 코드 정리` |
| **refactor** | 코드 리팩토링 | `refactor: 퀴즈 로직 함수화` |

---

## 4. GitHub CLI (`gh`) 활용 팁

터미널에서 바로 GitHub 작업을 수행할 수 있습니다.

- **브랜치 상태 확인**: `gh pr list` (진행 중인 PR 확인)
- **PR 생성**: `gh pr create --title "커밋 메시지" --body "상세 내용"`
- **원격 저장소 보기**: `gh repo view --web` (브라우저에서 바로 열기)

---

## 5. 정기적인 동기화

다른 사람이 작업한 내용을 내 로컬에 반영하려면 항상 작업 전에 다음을 실행하세요.
```bash
git checkout test
git pull origin test
```
