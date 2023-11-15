# FinalTodo
FinalTodo
# 프로젝트 개요

## 기획 의도

익숙한 기술들을 활용하여 일정에 맞추어 배포까지의 경험을 목적으로 유사 경험이 있는 메모앱을 선정하게 되었으며, 기존 메모앱과의 차별성을 가지기 위해 `Gamification` 요소, 시간 알림 설정, 위치 알림 설정, 사용자 테마 설정을 가지고 있는 메모앱을 기획하였습니다. 

## 기대 효과

### 개발진

- 개인별로 기존 캠프에서 익힌 기술을 체득하는 것
- 익숙한 기술들을 활용한 배포까지의 경험
- 추후에 있을 프로젝트 및 앱 배포 경험 중 리젝대응에 대한 경험

### 사용자

- 메모를 작성할 때 마다 포인트를 획득하게되어 앱 내부의 캐릭터를 성장시킬 수 있는 `Gamification` 을 통하여 사용자에게 재미, 몰입, 동기부여 등을 유도하여 지속적인 앱 사용을 촉진

## 서비스 아키텍처 설명

### CoreData및 Firebase를 이용한 데이터 관리

- 메모 작성, 저장, 검색 기능은 Swift의 CoreData 프레임워크를 활용하여 구현되었고 사용자가 작성한 메모는 로컬 데이터베이스에 저장되며, 필요에 따라 검색 및 수정이 가능. 로그인 및 온라인 DB 용도로 사용하였으며 낮은 러닝커브로 사용이 편리한 온라인 DB 및 로그인 구현 가능하여 적용.

### Firebase 인증

- Firebase의 인증 서비스를 사용하여 사용자 로그인, 로그아웃 및 회원가입 기능을 구현. 안전한 사용자 인증을 보장하며, 사용자 데이터의 안전한 관리를 가능.

### 위치 설정

- MapKit을 통해 사용자의 현재 위치를 추적하고, 이를 메모와 연결하는 기능을 제공. 예를 들어, 특정 장소에 대한 메모를 작성하거나, 그 위치에 도착했을 때 해당 메모를 리마인드하는 기능구현.

### 알림 설정

- UserNotifications 프레임워크를 사용하여, 사용자가 특정 메모에 대한 알림을 설정. 이는 메모를 특정 시간에 리마인드하는 기능으로, 사용자의 일정 관리에 도움을 줌.

### 게임화 요소(Gamification)

- 사용자가 메모를 작성할 때마다 포인트를 획득하게 되며 획득한 포인트에 따라 사용자 인터페이스 내의 이미지가 업그레이드되는 시스템을 구현. 이 포인트는 사용자의 참여도를 높이고, 지속적인 앱 사용을 하기위한 동기 부여 요소로 작용.

# 프로젝트 팀 구성 및 역할

## 김서진

- 역할: `팀원`
- 담당 업무
    - SignIn, SignUp page UI구현
    - 공동뷰 작업
    - 테마컬러 선택 및 저장 작업
    - 다크모드 대응

## 오서령

- 역할: `팀원`
- 담당 업무
    - SettingPage / ProfilePage / DeleteAccountPageViewController / ThemeColorPage / CalendarListViewController UI 및 관련 기능 구현
    - CoreDataModel / User 데이터모델 구현
    - CoreDataManager 구현
    - Cell Identifier Extension 작업

## 이종범

- 역할: `팀원`
- 담당 업무
    - 

## 원성준

- 역할: `부리더`
- 담당 업무
    - UserNotifications 사용 메모별 날짜, 시간 각 알림기능 설정
    - 날짜, 시간 알림 데이터 저장 및 메모에 연결
    - 메모 추가하기 화면 UI 및 DB 연결
    - 메모 수정 화면 UI 및 DB 연결
    - FSCalendar 라이브러리 적용 및 UI 작업

## 서준영

- 역할: `리더`
- 담당 업무
    - UI
        - LockScreen
        - LockScreenSettingScene
        - RewardScene
        - SignInScene
        - SignUpScene
        - MemoScene
        - App Info Scene
    - Featrue
        - 앱 잠금화면 기능
        - CoreData CRUD
        - 로그인
        - 회원가입
        - Custom modal Controller 구현
        - Custom modal Gesture Controller 구현

# 프로젝트 타임라인

## 기획 [~2023.10.13]

- 기획
- 코드 컨벤션 깃 컨벤션 등 협업에 필요한 룰을 확립
- 필수 페이지 UI 구현

## V 1.0 [2023.10.13~2023.11.07]

- 각 Scene 구현
- 로컬 및 온라인 CRUD 기능 구현
- 시간 알림
- 위치 알림
- 커스텀 컬러 제공
- 잠금화면
- 배포 중 리젝 대응 및 해결

## V 1.1 [2023.11.08~2023.11.09]

- 디버깅
- 커스텀 모달화면 제스쳐
- 폴더 삭제시 알림
- 다크모드 대응

## V 1.1.1 [2023.11.09~2023.11.11]

- 디버깅
- UI 수정

## V 1.1.2 [2023.11.12~2023.11.15]

- 일부 Scene 디자인 패턴
- 디자인 피드백 적용

# 프로젝트 수행 결과

## 배포 경험

## `V1.0` 배포

### App Store 심사 지침 준수

안정성, 디자인, 법적 요구 사항 등을 준수

### **개인정보에 처리 방침**

민감한 개인정보를 사용할 때에, 정확한 사용 의도 표명과 사용자에게 정보 접근 허용에 대한 강압적인 제스쳐가 전혀 없어야 함을 알게 됨.

---

## `V1.1` , `V1.1.1` , `V1.1.2` 배포

### 다양한 환경에 따른 대응의 필요성

다양한 기기 및 다크 모드 사용, 인터넷 연결의 유무 등 다양한 환경에 대응

## 트러블 슈팅

### Q1. 로그아웃 후에도 로그인 관련 페이지에서 메인 페이지로 돌아갈 수 있는 문제

A1. 로그인 관련 페이지가 항상 네비게이션 컨트롤러 스택에 올라가 있어서 데이터 낭비 및 뒤로가기를 통해 로그아웃 후에도 메인페이지로 돌아갈 수 있는 문제가 발생하였습니다. 로그인 혹은 로그아웃을 위한 화면 전환 시 네비게이션 컨트롤러를 이용해 push하지 않고, 루트뷰컨트롤러를 바꿔서 문제를 해결하였습니다.

### Q2. 위치 정보 알림에서 짧은 시간마다 새로고침 시 배터리 사용량 과부하 문제

A2. GPS 거리 오차로 정확한 위치 정보 체크인 기능이 구현될 지 알 수 없어 상시 새로고침을 하였으나, 확인 결과 맵킷을 사용하면 상당히 정확하게 현 위치를 파악하였습니다. 이에 위치 정보를 상시 새로고침 하지 않고, 일정 간격을 두어 사용자의 편의성을 해치지 않는 내에서 과부하 문제를 완화하였습니다.

### **Q3. 알림설정에 대한 문제**

A3. 예약완료 버튼을 눌렀을때 날짜와 시간이 모두 설정되었는지 확인하는 로직을 추가하여, 설정되지 않았을 경우 경고 메시지를 표시하도록 수정. 

동일한 알림이 스케줄링 되는 경우, 메모의 고유식별자를 사용하여 각 메모에 대한 알림을 식별하고 메모를 저장하거나 업데이트할 때 기존에 설정된 알림을 먼저 취소한 후 새로운 알림을 스케줄링.

# 자체 평가 의견

## 추후 개발 및 기술적인 도전 계획

- DB의 성능 개선
- 피드백을 통해 사용자 친화적인 UI 반영 및 수정
- 데이터 동기화를 자주하여 데이터의 최신화 유지
- 인터넷 연결의 대응을 좀 더 유연하게 대처

## 자체 평가 (팀원 혹은 우리 팀이 잘한 부분과 아쉬운 부분 등)

### 잘한 부분

- 참여도가 굉장히 좋았으며 팀전체가 프로젝트에 대한 애착이 있어 기획의 의도였던 배포까지 성공하였음
- 인터넷의 연결 유무에 따른 예외 처리를 대응한 것
- 공통되는 작업을 미리 파악하여 프로젝트의 공수를 줄여 진행한 것

### 아쉬운 부분

- 일정 관리의 미흡으로 인해 기획했던 추가기능 구현 및 패턴 적용을 완료하지 못한 부분
- 프로젝트 전체의 구조화 부족
- 깃 전략을 자세하게 만들지 않아서 브랜치 관리가 힘들어짐
