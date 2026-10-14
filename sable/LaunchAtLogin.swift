//
//  LaunchAtLogin.swift
//  sable
//
//  Created by Claude Code
//

import Foundation
import ServiceManagement

// SMAppService 기반 로그인 시 자동 실행 관리 (macOS 13+, 헬퍼 앱 불필요)
enum LaunchAtLogin {
    static let kvo = KVO()

    static var isEnabled: Bool {
        get { SMAppService.mainApp.status == .enabled }
        set {
            kvo.willChangeValue(for: \.isEnabled)
            defer { kvo.didChangeValue(for: \.isEnabled) }

            do {
                if newValue {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("LaunchAtLogin: failed to \(newValue ? "register" : "unregister") - \(error.localizedDescription)")
            }

            // 시스템 설정에서 승인 필요 시 로그인 항목 화면 표시
            if newValue && SMAppService.mainApp.status == .requiresApproval {
                SMAppService.openSystemSettingsLoginItems()
            }
        }
    }

    // 스토리보드 바인딩(launchAtLogin.isEnabled)용 KVO 래퍼
    final class KVO: NSObject {
        @objc dynamic var isEnabled: Bool {
            get { LaunchAtLogin.isEnabled }
            set { LaunchAtLogin.isEnabled = newValue }
        }
    }
}
