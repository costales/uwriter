/*
* uWriter http://launchpad.net/uwriter
* Copyright (C) 2015 Marcos Alvarez Costales https://launchpad.net/~costales
*
* uWriter is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 3 of the License, or
* (at your option) any later version.
*
* uWriter is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*/

import QtQuick 2.12
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import QtWebEngine 1.8
import Morph.Web 0.1
import Qt.labs.settings 1.0
import "js/utils.js" as QmlJs

MainView {
    objectName: "mainView"

    applicationName: "uwp.costales"

    width: units.gu(100)
    height: units.gu(70)
    anchorToKeyboard: true

    AdaptivePageLayout {
        id: mainPageStack

        property string filename: ''
        property string saveAsOperation: ''

        property var settings: Settings {
            property int editorColors: 0
            property bool autosave: false
            property bool convergence: true
        }

        property bool childPageOpened: false

        anchors.fill: parent
        primaryPageSource: pageMain
        layouts: PageColumnsLayout {
            when: width > height && mainPageStack.childPageOpened && mainPageStack.settings.convergence
            // column #0
            PageColumn {
                fillWidth: true
            }
            // column #1
            PageColumn {
                maximumWidth: units.gu(42)
                preferredWidth: (width / 2) - units.gu(8) // -8 hack for bq E4.5
            }
        }

        function executeJavaScript(code) {
            console.log(code)
            _webview.runJavaScript(code);
        }


        Page {
            id: pageMain

            onVisibleChanged: {
                if (visible) {
                    _webview.forceActiveFocus();
                }
            }

            property bool btnsEnabled: false

            header: PageHeader {
                id: pageHeader
                title: "Writer"
                StyleHints {
                    foregroundColor: '#ffffff'
                    backgroundColor: '#ffb84f'
                    dividerColor: UbuntuColors.slate
                }
                leadingActionBar {
                    numberOfSlots: 1
                    actions: [
                        Action {
                            id: actionMenu
                            iconName: "navigation-menu"
                            shortcut: "Ctrl+M"
                            enabled: pageMain.btnsEnabled && !mainPageStack.childPageOpened
                            text: i18n.tr("Menu")
                            onTriggered: {
                                Qt.inputMethod.hide();
                                mainPageStack.childPageOpened = true;
                                pageMain.pageStack.addPageToNextColumn(pageMain, Qt.resolvedUrl("Menu.qml"));
                            }
                        }
                    ]
                }
                trailingActionBar {
                    numberOfSlots: 5
                    actions: [
                        Action {
                            id: actionSaveAs
                            iconName: "save-as"
                            enabled: pageMain.btnsEnabled
                            text: i18n.tr("Save as")
                            onTriggered: {
                                mainPageStack.childPageOpened = true;
                                pageMain.pageStack.addPageToNextColumn(pageMain, Qt.resolvedUrl("SaveAs.qml"), {"setNewDoc": false, "callLoadDoc": false, "mainFilename": mainPageStack.filename});
                            }
                        },
                        Action {
                            id: actionSave
                            iconName: "save"
                            shortcut: "Ctrl+S"
                            enabled: pageMain.btnsEnabled
                            text: i18n.tr("Save")
                            onTriggered: {
                                if (!mainPageStack.filename) {
                                    mainPageStack.childPageOpened = true;
                                    pageMain.pageStack.addPageToNextColumn(pageMain, Qt.resolvedUrl("SaveAs.qml"), {"setNewDoc": false, "callLoadDoc": false, "mainFilename": mainPageStack.filename});
                                }
                                else {
                                    mainPageStack.executeJavaScript("qml_save_content(false)");
                                }
                            }
                        },
                        Action {
                            id: actionLoad
                            iconName: "document-open"
                            shortcut: "Ctrl+O"
                            enabled: pageMain.btnsEnabled
                            text: i18n.tr("Load")
                            onTriggered: {
                                mainPageStack.executeJavaScript("qml_query_modified('load')");
                            }
                        },
                        Action {
                            id: actionNew
                            iconName: "note"
                            shortcut: "Ctrl+N"
                            enabled: pageMain.btnsEnabled
                            text: i18n.tr("New")
                            onTriggered: {
                                mainPageStack.executeJavaScript("qml_query_modified('new')");
                            }
                        }
                    ]
                }
            }

			WebEngineProfile {
				id: webcontext
                httpUserAgent: "Mozilla/5.0 (Linux; Android 5.0; Nexus 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.102 Mobile Safari/537.36"
			}

            WebEngineView {
				id: _webview
                anchors.top: pageHeader.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                profile: webcontext
                url: "../uwp/index.html"
				settings.localContentCanAccessFileUrls: true
				settings.localContentCanAccessRemoteUrls: true
				settings.javascriptEnabled: true
				settings.focusOnNavigationEnabled: true
				settings.allowWindowActivationFromJavaScript: true

				onJavaScriptConsoleMessage: {
					var msg = "[JS] (%1:%2) %3".arg(sourceID).arg(lineNumber).arg(message)
				    console.log(msg)
				}

				Connections {
					onLoadingChanged: {
						if (loadRequest.status === WebEngineView.LoadSucceededStatus && !mainPageStack.onLoadingExecuted) {
                            pageMain.btnsEnabled = true;
                            mainPageStack.executeJavaScript("editor_colors(" + mainPageStack.settings.editorColors + ")");
                        }
                    }
 					onFeaturePermissionRequested: {
						console.log("grantFeaturePermission", feature)
						_webview.grantFeaturePermission(securityOrigin, feature, true);
					}
            }

                onNavigationRequested:{
                    var url = request.url.toString();

                    // Save
                    if (QmlJs.url_starts_with(url, 'http://save/')) {
                        var contentHTML = request.url.toString().replace(/^http:\/\/save\//,'');
                        QmlJs.saveFile(mainPageStack.filename, contentHTML);
                    }
                    // Save & New
                    else if (QmlJs.url_starts_with(url, 'http://save_and_new/')) {
                        var contentHTML = request.url.toString().replace(/^http:\/\/save_and_new\//,'');
                        QmlJs.saveFile(mainPageStack.filename, contentHTML);
                        mainPageStack.filename = '';
                    }
                    // New
                    else if (QmlJs.url_starts_with(url, 'http://modified_new/')) {
                        if (url == 'http://modified_new/false') {
                            mainPageStack.filename = '';
                            mainPageStack.executeJavaScript("qml_file_new()");
                        }
                        else {
                            mainPageStack.saveAsOperation = 'new';
                            PopupUtils.open(ask4save);
                        }
                    }
                    // Load
                    else if (QmlJs.url_starts_with(url, 'http://modified_load/')) {
                        if (url == 'http://modified_load/false') {
                            mainPageStack.childPageOpened = true;
                            pageMain.pageStack.addPageToNextColumn(pageMain, Qt.resolvedUrl("LoadFile.qml"));
                        }
                        else {
                            mainPageStack.saveAsOperation = 'load';
                            PopupUtils.open(ask4save);
                        }
                    }
                    // New
                    else if (QmlJs.url_starts_with(url, 'http://new/')) {
                        mainPageStack.filename = '';
                    }
                    // Open URL
                    else if (QmlJs.url_starts_with(url, 'http')) {
                        Qt.openUrlExternally(url);
                    }

					if (typeof url[0] != "undefined" && url[0].includes("http"))
						request.action = WebEngineNavigationRequest.IgnoreRequest;
                }

            }
        }
    }

    Component {
         id: ask4save
         Dialog {
            id: dialogueAsk4Save
            title: i18n.tr("Save file")
            text: i18n.tr("Do you want to save the text?")
            Button {
                text: i18n.tr("Yes")
                color: UbuntuColors.green
                onClicked: {
                    PopupUtils.close(dialogueAsk4Save)
                    if (mainPageStack.filename) {
                        mainPageStack.executeJavaScript("qml_save_content(true)");
                        if (mainPageStack.saveAsOperation != 'new') {
                            mainPageStack.childPageOpened = true;
                            pageMain.pageStack.addPageToNextColumn(pageMain, Qt.resolvedUrl("LoadFile.qml"));
                        }
                    }
                    else {
                        if (mainPageStack.saveAsOperation == 'new') {
                            mainPageStack.childPageOpened = true;
                            pageMain.pageStack.addPageToNextColumn(pageMain, Qt.resolvedUrl("SaveAs.qml"), {"setNewDoc": true, "callLoadDoc": false, "mainFilename": mainPageStack.filename});
                        }
                        if (mainPageStack.saveAsOperation == 'load') {
                            mainPageStack.childPageOpened = true;
                            pageMain.pageStack.addPageToNextColumn(pageMain, Qt.resolvedUrl("SaveAs.qml"), {"setNewDoc": false, "callLoadDoc": true, "mainFilename": mainPageStack.filename});
                        }
                    }
                }
            }
            Button {
                text: i18n.tr("No")
                color: UbuntuColors.red
                onClicked: {
                    PopupUtils.close(dialogueAsk4Save);
                    mainPageStack.filename = '';
                    mainPageStack.executeJavaScript("qml_file_new()");
                    if (mainPageStack.saveAsOperation == 'load') {
                        mainPageStack.childPageOpened = true;
                        pageMain.pageStack.addPageToNextColumn(pageMain, Qt.resolvedUrl("LoadFile.qml"));
                    }
                }
            }
            Button {
                text: i18n.tr("Cancel")
                onClicked: {
                    PopupUtils.close(dialogueAsk4Save);
                }
            }
        }
    }


    Connections {
        target: Qt.application
        onStateChanged:
            if(Qt.application.state !== Qt.ApplicationActive && mainPageStack.settings.autosave && mainPageStack.filename) {
                mainPageStack.executeJavaScript("qml_save_content(false)");
            }
    }

}
