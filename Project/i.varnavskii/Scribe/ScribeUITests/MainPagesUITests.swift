//
//  MainPagesUITests.swift
//  ScribeUITests
//
//  Created by Варнавский Игорь Витальевич on 11.11.2026.
//

import XCTest

@MainActor
final class MainPagesUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() async throws {
        try await super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--ui-testing"]
        app.launch()
    }

    override func tearDown() async throws {
        app.terminate()
        app = nil
        try await super.tearDown()
    }

    func testHomeOpensCreateNoteAndRequiresTitleAndSubject() {
        XCTAssertTrue(app.navigationBars["Главная"].waitForExistence(timeout: 5))
        app.buttons["home.createNote"].tap()

        XCTAssertTrue(app.navigationBars["Новый конспект"].waitForExistence(timeout: 5))
        let createButton = app.buttons["Создать"]
        XCTAssertFalse(createButton.isEnabled)

        let titleField = app.textFields["Название конспекта"]
        titleField.tap()
        titleField.typeText("Lecture")

        // Даже с названием нельзя создать конспект без предмета.
        XCTAssertFalse(createButton.isEnabled)
    }

    func testEmptyNotesPageOpensCreateNote() {
        openTab("Конспекты")
        XCTAssertFalse(app.buttons["Выбрать"].isEnabled)

        app.buttons["notes.createNote"].tap()

        XCTAssertTrue(app.navigationBars["Новый конспект"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.textFields["Название конспекта"].exists)
    }

    func testNoteCanBeSavedAndOpenedAgain() {
        openTab("Конспекты")
        createNote()
        let editor = app.textViews["noteEditor.text"]
        XCTAssertTrue(editor.waitForExistence(timeout: 5))
        waitForEnabled(editor)
        let saveButton = app.buttons["noteEditor.save"]
        XCTAssertFalse(saveButton.isEnabled)
        editor.tap()
        editor.typeText("# Hello Markdown")
        saveButton.tap()
        expectation(for: NSPredicate(format: "enabled == false"), evaluatedWith: saveButton)
        waitForExpectations(timeout: 5)
        XCTAssertTrue(app.staticTexts["Все изменения сохранены"].waitForExistence(timeout: 5))
        app.navigationBars.buttons["Назад"].tap()

        let noteRow = app.staticTexts["Test lecture"]
        XCTAssertTrue(noteRow.waitForExistence(timeout: 5))
        noteRow.tap()

        XCTAssertTrue(editor.waitForExistence(timeout: 5))
        let savedText = NSPredicate(format: "value == %@", "# Hello Markdown")
        expectation(for: savedText, evaluatedWith: editor)
        waitForExpectations(timeout: 5)
        app.segmentedControls["noteEditor.mode"].buttons["Просмотр"].tap()
        XCTAssertTrue(app.staticTexts["Hello Markdown"].waitForExistence(timeout: 5))
        app.segmentedControls["noteEditor.mode"].buttons["Редактор"].tap()
        XCTAssertTrue(editor.waitForExistence(timeout: 5))
    }

    func testSettingsShowsMainControls() {
        openTab("Настройки")

        XCTAssertTrue(app.steppers.firstMatch.waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Все предметы"].exists)
        XCTAssertTrue(app.buttons["Сохранить"].isEnabled)
    }

    private func waitForEnabled(_ element: XCUIElement) {
        expectation(for: NSPredicate(format: "enabled == true"), evaluatedWith: element)
        waitForExpectations(timeout: 5)
    }

    private func openTab(_ title: String) {
        let tab = app.tabBars.buttons[title]
        XCTAssertTrue(tab.waitForExistence(timeout: 5))
        tab.tap()
        XCTAssertTrue(app.navigationBars[title].waitForExistence(timeout: 5))
    }

    private func createNote() {
        app.buttons["notes.createNote"].tap()
        let subjectMenu = app.buttons["createNote.subject"]
        XCTAssertTrue(subjectMenu.waitForExistence(timeout: 5))
        subjectMenu.tap()
        app.buttons["Создать новый предмет"].tap()

        let subjectField = app.textFields["Название предмета"]
        XCTAssertTrue(subjectField.waitForExistence(timeout: 5))
        subjectField.tap()
        subjectField.typeText("Swift")
        app.buttons["Сохранить"].tap()

        let titleField = app.textFields["Название конспекта"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 5))
        titleField.tap()
        titleField.typeText("Test lecture")
        app.buttons["Создать"].tap()
    }
}
