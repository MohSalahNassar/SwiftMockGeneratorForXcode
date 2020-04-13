import AppKit

class PreferencesView: NSView {

    @IBOutlet private var manualContainer: NSView!
    @IBOutlet private var automaticContainer: NSView!
    @IBOutlet private var automaticPathCheckbox: NSButton!
    @IBOutlet private var projectPathField: NSTextField!

    private let preferences = Preferences()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(detectProjectPath), name: NSWindow.didBecomeMainNotification, object: nil)
    }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        updateView()
    }

    @IBAction private func didChangeAutomaticPathCheckbox(_ sender: NSButton) {
        updateAutomaticPathPreference()
        updateView()
        detectProjectPath()
    }

    private func updateAutomaticPathPreference() {
        preferences.automaticallyDetectProjectPath = automaticPathCheckbox.state == .on
    }

    private func updateView() {
        automaticPathCheckbox.state = preferences.automaticallyDetectProjectPath ? .on : .off
        updateContainers()
    }

    private func updateContainers() {
        let hideManualContainer = preferences.automaticallyDetectProjectPath
        manualContainer.isHidden = hideManualContainer
        automaticContainer.isHidden = !hideManualContainer
    }

    @objc private func detectProjectPath() {
        if let project = projectPath {
            projectPathField.stringValue = project.path
        } else {
            projectPathField.stringValue = "Cannot find a project. Make sure a project is open in Xcode."
        }
    }

    private var projectPath: URL? {
        return XcodeProjectPathFinder().findOpenProjectPath()
    }

    @IBAction private func selectDirectory(_ sender: Any?) {
        let panel = NSOpenPanel()
        panel.message = "Choose your project directory"
        panel.prompt = "Grant permission"
        panel.allowedFileTypes = ["none"]
        panel.allowsOtherFileTypes = false
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.directoryURL = projectPath
        if panel.runModal() == NSApplication.ModalResponse.OK {
            bookmark(panel.url)
        }
    }
}
