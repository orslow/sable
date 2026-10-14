# sable Architecture

브라우저용 마우스 제스처 앱. 오른쪽 버튼을 누른 채 드래그한 방향을 인식해 키보드 단축키로 변환함. 메뉴 막대 전용 에이전트 앱(`LSUIElement`), 샌드박스 미사용.

## 1. 데이터 흐름

```
[WindowServer] right mouse down/dragged/up
      |
      v
CGEventTap (.cgSessionEventTap, .headInsertEventTap, .defaultTap)      AppDelegate.startEventTap()
      |  메인 런루프(commonModes)에 등록, NSApplication 이벤트 루프가 구동
      v
myCGEventCallback                                                       AppDelegate.swift
      |- 최전면 앱 이름이 allowedApps에 부분 일치하지 않으면 -> 이벤트 그대로 통과
      |- 더블클릭(mouseEventClickState == 2) -> 그대로 통과
      `- 그 외 -> 이벤트 삼킴(nil 반환) 후 vc(ViewController)로 전달
      v
ViewController.globalRightMouseDown / Dragged / Up                     ViewController.swift
      |- Dragged: 누적 이동량(x_movement, y_movement)으로 gestureRecorder() 호출
      |           8방향을 비트마스크(detected)에 OR 누적 (12시=0b10000000, 시계 방향)
      `- Up: detected == 0 이면 KeyBindings.rightClick()으로 Ctrl+클릭 재발행
             아니면 motionInterpreter() -> 팝업 버튼 제목 -> makeShortcut()
      v
KeyBindings.shared.*()  -> CGEvent.post(tap: .cghidEventTap)            KeyBindings.swift
      (Cmd+[, Cmd+], Cmd+W, Cmd+Shift+T, Ctrl+Tab ...)
```

### 설정 저장

| 파일 | 위치 | 내용 | 코드 |
|---|---|---|---|
| `globalKeybind.json` | `~/Documents` | 16개 제스처별 팝업 선택 인덱스 | `KeybindPreferences`, `ViewController.viewDidDisappear` |
| `appList.json` | `~/Documents` | 제스처 적용 대상 앱 이름 목록 | `AppListPreferences` |

- 둘 다 `Storage`(JSON 직렬화 헬퍼)로 읽고 씀. 샌드박스가 꺼져 있어 실제 사용자 Documents 폴더에 저장됨
- `KeybindPreferences`는 snake_case 키(`down_right` 등) 유지. 기존 파일과 호환

### UI

- 상태 막대 아이콘 -> `Preferences` 메뉴 -> 스토리보드 초기 윈도우(`visibleAtLaunch = NO`)를 표시
- 환경설정 창: 제스처별 `NSPopUpButton` 16개, `Launch at login` 체크박스, `Manage Apps...` 패널(코드로 생성한 `NSPanel`)
- 체크박스는 스토리보드 바인딩 `launchAtLogin.isEnabled` -> `LaunchAtLogin.kvo`(KVO 래퍼)

## 2. 주요 설계 결정

- **CGEventTap(active filter) 사용**: 오른쪽 클릭을 삼켜 컨텍스트 메뉴가 뜨지 않게 하기 위함. listen-only 모니터(`NSEvent.addGlobalMonitorForEvents`, `GlobalEventMonitor.swift`)로는 이벤트를 막을 수 없음. 대가로 손쉬운 사용(Accessibility) 권한 필수, 샌드박스 불가
- **제스처 없는 오른쪽 클릭은 Ctrl+왼쪽 클릭으로 재발행**: 원본 이벤트를 이미 삼켰으므로 컨텍스트 메뉴를 다시 띄우기 위한 우회
- **앱 이름 부분 일치 필터**: `"Chrome"` 하나로 Google Chrome, Chrome Canary 등을 함께 처리
- **로그인 시 실행은 `SMAppService.mainApp`(macOS 13+)**: 예전 `LaunchAtLogin` 4.x 패키지(헬퍼 앱 + `SMLoginItemSetEnabled`)는 deprecated API이고, 로컬 서명 빌드에서 헬퍼 재서명이 실패해 서명이 깨져 제거함. 그래서 최소 지원 OS가 13.0
- **팝업 버튼 제목 문자열로 동작 매핑**(`makeShortcut`): 스토리보드 메뉴 항목 제목을 바꾸면 매핑이 깨짐

## 3. 자주 겪는 문제

- **`applicationDidFinishLaunching`에서 런루프를 직접 돌리지 말 것**: 예전 코드는 마지막에 `CFRunLoopRun()`을 호출했음. 15.x에서는 HIToolbox 이벤트 스레드가 `QuitEventLoop -> CFRunLoopStop`을 호출해 우연히 풀렸지만, 이 내부 동작이 바뀐 OS(Golden Gate)에서는 실행이 끝나지 않아 모래시계만 도는 원인이 됨. 이벤트 탭은 메인 런루프에 등록만 하면 `NSApplication.run()`이 처리함
- **다시 빌드하면 손쉬운 사용 권한이 풀림**: 정식 인증서 없이 로컬 서명(ad-hoc)한 앱이라 TCC가 cdhash로 앱을 식별함. 시스템 설정 목록에는 켜져 있어도 `AXIsProcessTrusted()`가 false임. 목록에서 sable을 삭제(-)한 뒤 다시 추가해야 함
- **권한 대기 타임아웃**: 권한이 없으면 1초 간격으로 최대 5분 폴링한 뒤 종료 알림을 띄움(`waitForAccessibility`)
- **이벤트 탭 비활성화**: 콜백이 느리면 OS가 탭을 끄고 `.tapDisabledByTimeout`(또는 `.tapDisabledByUserInput`)을 콜백으로 보냄. 콜백 맨 앞에서 전역 `gestureEventTap`으로 다시 켬. 꺼진 동안 mouseUp을 놓칠 수 있어 `globalRightMouseDown`에서 제스처 상태를 매번 초기화함
- **콜백 반환값**: 통과 이벤트는 반드시 `Unmanaged.passUnretained(event)`로 반환. `passRetained`를 쓰면 이벤트마다 retain이 하나씩 남아 누수됨
- **`vc` 전역 변수**: `weak var vc = ViewController()`는 즉시 해제되어 nil임. 실제 값은 스토리보드가 `ViewController.viewDidLoad()`를 호출할 때 설정됨
- **레포의 `sable.app`**: 빌드 산출물을 직접 커밋함. Release로 빌드해 교체할 것(Debug 빌드는 `sable.debug.dylib`가 포함됨)
- **로그인 항목 승인**: `SMAppService.register()` 후 상태가 `.requiresApproval`이면 시스템 설정 > 일반 > 로그인 항목에서 허용해야 함. 이 경우 코드가 해당 화면을 엶
