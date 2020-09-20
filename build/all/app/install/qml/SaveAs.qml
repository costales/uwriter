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


import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.ListItems 0.1 as ListItem
import Qt.labs.folderlistmodel 1.0
import "js/utils.js" as QmlJs


Page {
    id: pageSaveAsFile
    
    Component.onCompleted: {
        PopupUtils.open(saveAs);
    }
    
    property bool   setNewDoc
    property bool   callLoadDoc
    property string mainFilename
    
    property bool overwriteFileName: false
    property string fileName: pageSaveAsFile.mainFilename

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Files")
        StyleHints {
            foregroundColor: '#ffffff'
            backgroundColor: '#ffb84f'
            dividerColor: UbuntuColors.slate
        }

        leadingActionBar {
            numberOfSlots: 1
            actions: [
                Action {
                    id: actionBack
                    iconName: "back"
                    text: i18n.tr("Back")
                    onTriggered: {
                        mainPageStack.childPageOpened = false;
                        mainPageStack.removePages(pageSaveAsFile);
                    }
                }
            ]
        }
    }

    Label {
        id: lblNnoFiles
        width: parent.width - units.gu(4)
        anchors.centerIn: parent
        visible: folderModel.count === 0
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        text: i18n.tr("No files yet")
    }

    FolderListModel {
        id: folderModel
        folder: "/home/phablet/.local/share/uwp.costales"
        nameFilters: [ "*.html" ]
        showDirs: false
    }

    ListView {
        id: listView
        anchors.top: pageHeader.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        model: folderModel
        delegate: ListItem.Standard {
            text: model.fileName
            onClicked: {
                mainPageStack.filename = model.fileName.replace(/.html$/,'');
                QmlJs.openFile(model.fileName);
                mainPageStack.childPageOpened = false;
                mainPageStack.removePages(pageSaveAsFile);
            }
        }
    }
    
    
    Component {
     id: saveAs
         Dialog {
            id: dialogueSaveAs
            title: i18n.tr("Save document")
            text: i18n.tr("Enter a file name")
            TextField {
                focus: true
                id: fileNameField
                width: parent.width
                text: pageSaveAsFile.fileName
                hasClearButton: true
                placeholderText: i18n.tr("Don't use extension")
                inputMethodHints: Qt.ImhNoPredictiveText
                onTextChanged: {
                    pageSaveAsFile.fileName = fileNameField.text.trim();
                    dialogueSaveAs.text = i18n.tr("Enter a file name");
                    pageSaveAsFile.overwriteFileName = false;
                    var i = 0;
                    for (i=0; i<folderModel.count; i++) {
                        if (fileNameField.text.trim() === folderModel.get(i, "fileName").slice(0,-5)) {
                            pageSaveAsFile.overwriteFileName = true;
                            dialogueSaveAs.text = i18n.tr("This file exists");
                        }
                    }
                }
            }
            
            Button {
                text: i18n.tr("Save")
                color: UbuntuColors.green
                enabled: fileNameField.text.trim()
                onClicked: {
                    if (pageSaveAsFile.overwriteFileName) {
                        PopupUtils.close(dialogueSaveAs);
                        PopupUtils.open(overwrite);
                    }
                    else {
                        PopupUtils.close(dialogueSaveAs);
                        mainPageStack.filename = pageSaveAsFile.fileName;
                        mainPageStack.executeJavaScript("qml_save_content(" + pageSaveAsFile.setNewDoc + ")");
                        if (!pageSaveAsFile.callLoadDoc) {
                            mainPageStack.childPageOpened = false;
                            mainPageStack.removePages(pageSaveAsFile);
                        }
                    }
                }
            }
            Button {
                text: i18n.tr("Cancel")
                onClicked: {
                    PopupUtils.close(dialogueSaveAs)
                    mainPageStack.childPageOpened = false;
                    mainPageStack.removePages(pageSaveAsFile);
                }
            }
        }
    }

    Component {
         id: overwrite
         Dialog {
            id: dialogueOverwrite
            title: i18n.tr("File name exists")
            text: i18n.tr("Do you want to overwrite it?")
            Button {
                text: i18n.tr("Yes")
                color: UbuntuColors.red
                onClicked: {
                    PopupUtils.close(dialogueOverwrite)
                    mainPageStack.filename = pageSaveAsFile.fileName;
                    mainPageStack.executeJavaScript("qml_save_content(" + pageSaveAsFile.setNewDoc + ")");
                    if (!pageSaveAsFile.callLoadDoc) {
                        mainPageStack.childPageOpened = false;
                        mainPageStack.removePages(pageSaveAsFile);
                    }
                }
            }
            Button {
                text: i18n.tr("No")
                onClicked: {
                    PopupUtils.close(dialogueOverwrite);
                    PopupUtils.open(saveAs);
                }
            }
        }
    }

}


