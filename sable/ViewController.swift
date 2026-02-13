//
//  ViewController.swift
//  sable
//
//  Created by jueon on 2021/01/06.
//  Copyright © 2021 jueon. All rights reserved.
//

import Cocoa
import LaunchAtLogin

weak var vc = ViewController()

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    // MARK: - App List Management
    var appList: [String] = []
    var appTableView: NSTableView!
    var appListPanel: NSPanel?

    func setupAppListButton() {
        let button = NSButton(title: "Manage Apps…", target: self, action: #selector(toggleAppListPanel(_:)))
        button.bezelStyle = .rounded
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)

        // Launch at login 체크박스(y=10, x=20) 옆에 배치
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 160),
            button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8),
            button.heightAnchor.constraint(equalToConstant: 24),
        ])
    }

    @objc func toggleAppListPanel(_ sender: Any) {
        if let panel = appListPanel, panel.isVisible {
            panel.close()
            return
        }
        showAppListPanel()
    }

    func showAppListPanel() {
        // Preferences 윈도우 기준 우측에 패널 배치
        let panelWidth: CGFloat = 240
        let panelHeight: CGFloat = 300

        var panelRect = NSRect(x: 0, y: 0, width: panelWidth, height: panelHeight)
        if let prefWindow = self.view.window {
            let prefFrame = prefWindow.frame
            panelRect.origin.x = prefFrame.maxX + 8
            panelRect.origin.y = prefFrame.midY - panelHeight / 2
        }

        let panel = NSPanel(
            contentRect: panelRect,
            styleMask: [.titled, .closable, .utilityWindow],
            backing: .buffered,
            defer: false
        )
        panel.title = "Applications"
        panel.isFloatingPanel = true
        panel.hidesOnDeactivate = false
        panel.level = .floating

        let contentView = NSView(frame: NSRect(x: 0, y: 0, width: panelWidth, height: panelHeight))

        // ScrollView + TableView
        let scrollView = NSScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.hasVerticalScroller = true
        scrollView.borderType = .bezelBorder

        appTableView = NSTableView()
        appTableView.delegate = self
        appTableView.dataSource = self
        appTableView.headerView = nil
        appTableView.rowHeight = 22
        appTableView.usesAlternatingRowBackgroundColors = true

        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("AppColumn"))
        column.title = "Application"
        appTableView.addTableColumn(column)

        scrollView.documentView = appTableView
        contentView.addSubview(scrollView)

        // + 버튼
        let addButton = NSButton(title: "+", target: self, action: #selector(addApp(_:)))
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.bezelStyle = .smallSquare
        addButton.font = NSFont.systemFont(ofSize: 16)
        contentView.addSubview(addButton)

        // - 버튼
        let removeButton = NSButton(title: "−", target: self, action: #selector(removeApp(_:)))
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.bezelStyle = .smallSquare
        removeButton.font = NSFont.systemFont(ofSize: 16)
        contentView.addSubview(removeButton)

        // 안내 텍스트
        let hint = NSTextField(labelWithString: "App name is matched partially.\ne.g. \"Chrome\" matches Google Chrome.")
        hint.font = NSFont.systemFont(ofSize: 10)
        hint.textColor = .secondaryLabelColor
        hint.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hint)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            scrollView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -8),

            addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            addButton.bottomAnchor.constraint(equalTo: hint.topAnchor, constant: -8),
            addButton.widthAnchor.constraint(equalToConstant: 28),
            addButton.heightAnchor.constraint(equalToConstant: 28),

            removeButton.leadingAnchor.constraint(equalTo: addButton.trailingAnchor, constant: 0),
            removeButton.bottomAnchor.constraint(equalTo: addButton.bottomAnchor),
            removeButton.widthAnchor.constraint(equalToConstant: 28),
            removeButton.heightAnchor.constraint(equalToConstant: 28),

            hint.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            hint.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            hint.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])

        panel.contentView = contentView
        panel.makeKeyAndOrderFront(nil)
        appListPanel = panel
        appTableView.reloadData()
    }

    @objc func addApp(_ sender: Any) {
        let alert = NSAlert()
        alert.messageText = "Add Application"
        alert.informativeText = "Enter the application name (e.g., Chrome, Safari):"
        alert.addButton(withTitle: "Add")
        alert.addButton(withTitle: "Cancel")

        let inputField = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        inputField.placeholderString = "Application name"
        alert.accessoryView = inputField

        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            let appName = inputField.stringValue.trimmingCharacters(in: .whitespaces)
            if !appName.isEmpty && !appList.contains(appName) {
                appList.append(appName)
                appTableView.reloadData()
                saveAppList()
            }
        }
    }

    @objc func removeApp(_ sender: Any) {
        let selectedRow = appTableView.selectedRow
        if selectedRow >= 0 && selectedRow < appList.count {
            appList.remove(at: selectedRow)
            appTableView.reloadData()
            saveAppList()
        }
    }

    func loadAppList() {
        appList = AppListPreferences.getAppList()
        appTableView?.reloadData()
    }

    func saveAppList() {
        var prefs = AppListPreferences.load()
        prefs.apps = appList
        prefs.save()
        reloadAllowedApps()
    }

    // MARK: - NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        return appList.count
    }

    // MARK: - NSTableViewDelegate
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellIdentifier = NSUserInterfaceItemIdentifier("AppCell")
        var cell = tableView.makeView(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView

        if cell == nil {
            cell = NSTableCellView()
            cell?.identifier = cellIdentifier
            let textField = NSTextField(labelWithString: "")
            textField.translatesAutoresizingMaskIntoConstraints = false
            cell?.addSubview(textField)
            cell?.textField = textField
            NSLayoutConstraint.activate([
                textField.leadingAnchor.constraint(equalTo: cell!.leadingAnchor, constant: 4),
                textField.trailingAnchor.constraint(equalTo: cell!.trailingAnchor, constant: -4),
                textField.centerYAnchor.constraint(equalTo: cell!.centerYAnchor)
            ])
        }

        cell?.textField?.stringValue = appList[row]
        return cell
    }
    
    @objc dynamic var launchAtLogin = LaunchAtLogin.kvo
    
    @IBOutlet var MainView: NSView!
    
    override func viewDidDisappear() {
        updateGlobalShortcutOnJson()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        vc = self

        if Storage.fileExists("globalKeybind.json", in: .documents),
           let globalKeybinds = Storage.retrieve("globalKeybind.json", from: .documents, as: KeybindPreferences.self) {
            updateKeybindButtonFromJson(globalKeybinds)
        }

        // App list setup
        setupAppListButton()
        loadAppList()
    }
    
    // update keybinding when view disappear
    func updateGlobalShortcutOnJson() {
        let newGlobalKeybind = KeybindPreferences(
            left: leftButton.indexOfSelectedItem,
            right: rightButton.indexOfSelectedItem,
            up: upButton.indexOfSelectedItem,
            down: downButton.indexOfSelectedItem,
            u: uButton.indexOfSelectedItem,
            i: iButton.indexOfSelectedItem,
            k: kButton.indexOfSelectedItem,
            j: jButton.indexOfSelectedItem,
            downRight: downRightButton.indexOfSelectedItem,
            rightUp: rightUpButton.indexOfSelectedItem,
            upLeft: upLeftButton.indexOfSelectedItem,
            leftDown: leftDownButton.indexOfSelectedItem,
            upRight: upRightButton.indexOfSelectedItem,
            rightDown: rightDownButton.indexOfSelectedItem,
            downLeft: downLeftButton.indexOfSelectedItem,
            leftUp: leftUpButton.indexOfSelectedItem,
            characters: "nothing"
        )

        Storage.store(newGlobalKeybind, to: .documents, as: "globalKeybind.json")
    }

    // Set the shortcut button to show the keys to press
    func updateKeybindButtonFromJson(_ KeybindPreference : KeybindPreferences) {
        leftButton.selectItem(at: KeybindPreference.left)
        rightButton.selectItem(at: KeybindPreference.right)
        upButton.selectItem(at: KeybindPreference.up)
        downButton.selectItem(at: KeybindPreference.down)
        uButton.selectItem(at: KeybindPreference.u)
        iButton.selectItem(at: KeybindPreference.i)
        kButton.selectItem(at: KeybindPreference.k)
        jButton.selectItem(at: KeybindPreference.j)
        downRightButton.selectItem(at: KeybindPreference.downRight)
        rightUpButton.selectItem(at: KeybindPreference.rightUp)
        upLeftButton.selectItem(at: KeybindPreference.upLeft)
        leftDownButton.selectItem(at: KeybindPreference.leftDown)
        upRightButton.selectItem(at: KeybindPreference.upRight)
        rightDownButton.selectItem(at: KeybindPreference.rightDown)
        downLeftButton.selectItem(at: KeybindPreference.downLeft)
        leftUpButton.selectItem(at: KeybindPreference.leftUp)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    var current_x: CGFloat = 0.0, current_y: CGFloat = 0.0, x_movement: CGFloat = 0.0, y_movement: CGFloat = 0.0
    var detected = 0b00000000 // starts from 12 o'clock
    
    func globalRightMouseDown(with event: CGEvent) {
        current_x = event.location.x
        current_y = event.location.y
        // print(current_x, current_y)
    }

    func globalRightMouseDragged(with event: CGEvent) {
        let x = event.location.x
        let y = event.location.y

        x_movement += x - current_x
        y_movement -= y - current_y // reverse on CGEvent
        current_x = x
        current_y = y
        gestureRecorder(xd: x_movement, yd: y_movement)
    }
    
    func globalRightMouseUp(with event: CGEvent) {
        // just right click without any gesture
        if detected==0 {
            action.rightClick(pos: event.location)
            return
        }
        
        motionInterpreter()
        (x_movement, y_movement) = (0, 0)
        detected=0
        
        /*
        let seconds = 0.3
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            EscKeyDown?.post(tap: loc)
            EscKeyUp?.post(tap: loc)
        }
        */
    }

    let mrd: CGFloat = 50.0 // 최소 인식 거리
    let sqrtMrd: CGFloat = sqrt(50.0) // sqrt(mrd) 캐시
    let angle: CGFloat = 0.25 // 대각선 인식 기준 각도

    func gestureRecorder(xd: CGFloat, yd: CGFloat) {
        if yd > mrd && abs(xd) / yd < angle { // 12 o'clock
            detected |= 0b10000000
        }
        if xd > mrd && abs(yd) / xd < angle { // 3 o'clock
            detected |= 0b00100000
        }
        if yd < -mrd && abs(xd) / -yd < angle { // 6 o'clock
            detected |= 0b00001000
        }
        if xd < -mrd && abs(yd) / -xd < angle { // 9 o'clock
            detected |= 0b00000010
        }
        if xd > sqrtMrd && yd > sqrtMrd &&
            yd / xd > angle && xd / yd > angle { // 1:30
            detected |= 0b01000000
        }
        if xd > sqrtMrd && yd < -sqrtMrd &&
            -yd / xd > angle && xd / -yd > angle { // 4:30
            detected |= 0b00010000
        }
        if xd < -sqrtMrd && yd < -sqrtMrd &&
            yd / xd > angle && xd / yd > angle { // 7:30
            detected |= 0b00000100
        }
        if xd < -sqrtMrd && yd > sqrtMrd &&
            yd / -xd > angle && -xd / yd > angle { // 10:30
            detected |= 0b00000001
        }
    }
    @IBOutlet weak var leftButton: NSPopUpButton!
    @IBOutlet weak var rightButton: NSPopUpButton!
    @IBOutlet weak var upButton: NSPopUpButton!
    @IBOutlet weak var downButton: NSPopUpButton!
    @IBOutlet weak var uButton: NSPopUpButton!
    @IBOutlet weak var iButton: NSPopUpButton!
    @IBOutlet weak var kButton: NSPopUpButton!
    @IBOutlet weak var jButton: NSPopUpButton!
    @IBOutlet weak var downRightButton: NSPopUpButton!
    @IBOutlet weak var rightUpButton: NSPopUpButton!
    @IBOutlet weak var upLeftButton: NSPopUpButton!
    @IBOutlet weak var leftDownButton: NSPopUpButton!
    @IBOutlet weak var upRightButton: NSPopUpButton!
    @IBOutlet weak var rightDownButton: NSPopUpButton!
    @IBOutlet weak var downLeftButton: NSPopUpButton!
    @IBOutlet weak var leftUpButton: NSPopUpButton!
    
    
    func motionInterpreter() {
        switch detected {
        case 0b00000010:
            makeShortcut(item: leftButton.title)
        case 0b00100000:
            makeShortcut(item: rightButton.title)
        case 0b10000000:
            makeShortcut(item: upButton.title)
        case 0b00001000:
            makeShortcut(item: downButton.title)
        case 0b00000001:
            makeShortcut(item: uButton.title)
        case 0b01000000:
            makeShortcut(item: iButton.title)
        case 0b00010000:
            makeShortcut(item: kButton.title)
        case 0b00000100:
            makeShortcut(item: jButton.title)
        case 0b00011000:
            makeShortcut(item: downRightButton.title)
        case 0b01100000:
            makeShortcut(item: rightUpButton.title)
        case 0b10000001:
            makeShortcut(item: upLeftButton.title)
        case 0b00000110:
            makeShortcut(item: leftDownButton.title)
        case 0b11000000:
            makeShortcut(item: upRightButton.title)
        case 0b00110000:
            makeShortcut(item: rightDownButton.title)
        case 0b00001100:
            makeShortcut(item: downLeftButton.title)
        case 0b00000011:
            makeShortcut(item: leftUpButton.title)
        default:
            break
        }
    }
    
    // No action, Back, Forward, Scroll to top, Scroll to bottom, Close tab, Reopen closed tab, Move to left tab, Move to right tab, Reload
    let action = KeyBindings.shared
    func makeShortcut(item: String) {
        switch item {
        case "Back":
            action.back()
        case "Forward":
            action.forward()
        case "Scroll to top":
            action.scrollToTop()
        case "Scroll to bottom":
            action.scrollToBottom()
        case "Close tab":
            action.closeTab()
        case "Reopen closed tab":
            action.reopenClosedTab()
        case "Move to left tab":
            action.leftTab()
        case "Move to right tab":
            action.rightTab()
        case "Reload":
            action.reload()
        case "Open a new window":
            action.newWindow()
        case "Open a new tab":
            action.newTab()
        default:
            break
        }
    }
}
