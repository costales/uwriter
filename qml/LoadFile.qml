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
import Qt.labs.folderlistmodel 1.0
import Ubuntu.Components.ListItems 0.1 as ListItem
import "js/utils.js" as QmlJs


Page {
    id: pageLoadFiles
    
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
                        onClicked: {
                            mainPageStack.childPageOpened = false;
                            mainPageStack.removePages(pageLoadFiles);
                        }
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
                mainPageStack.removePages(pageLoadFiles);
            }
        }
    }
}


