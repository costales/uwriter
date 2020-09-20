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
import Ubuntu.Components.ListItems 1.3 as ListItem
import Ubuntu.Components.Popups 1.3

Page {
    id: pageMenu
    
    property bool expandLink: false
    property bool expandImg: false
    property bool expandTableCreate: false
    property bool expandFind: false
    property bool expandReplace: false
    
    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Menu")
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
                            mainPageStack.removePages(pageMenu);
                        }
                    }
                }
            ]
        }
        trailingActionBar {
            numberOfSlots: 2
            actions: [
                Action {
                    id: actionAbout
                    iconName: "info"
                    text: i18n.tr("About")
                    onTriggered: {
                        pageMain.pageStack.addPageToNextColumn(pageMain, Qt.resolvedUrl("About.qml"));
                        mainPageStack.removePages(pageMenu);
                    }
                },
                Action {
                    id: actionSettings
                    iconName: "settings"
                    enabled: pageMain.btnsEnabled
                    text: i18n.tr("Settings")
                    onTriggered: {
                        mainPageStack.childPageOpened = true;
                        pageMain.pageStack.addPageToNextColumn(pageMain, Qt.resolvedUrl("Settings.qml"));
                    }
                }
            ]
        }
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        anchors.topMargin: units.gu(6)
        contentHeight: expandingItem2.height + expandingItem3.height + expandingItem4.height + expandingItem5.height + expandingItem6.height + expandingItem7.height + expandingItem8.height
        
        Column {
            anchors { top:pageHeader.bottom; left: parent.left; right: parent.right }
            clip: true

                ListItem.Expandable {
                    id: expandingItem2
                    expandedHeight: contentCol2.height + units.gu(1)
                    onClicked: {
                        expanded = !expanded;
                    }
                    Column {
                        id: contentCol2
                        anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                        Item {
                            anchors { left: parent.left; right: parent.right}
                            height: expandingItem2.collapsedHeight
                            Label {
                                anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter}
                                text: i18n.tr("Edit")
                            }
                        }

                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Cut")
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('Cut')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Copy")
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('Copy')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Select all")
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('selectAll')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Replace…")
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        pageMenu.expandReplace = !pageMenu.expandReplace;
                                    }
                                }
                            }
                            Row {
                                spacing: units.gu(1)
                                anchors { left: parent.left; leftMargin: units.gu(3);}
                                visible: pageMenu.expandReplace
                                height: units.gu(6)
                                TextField {
                                    id: fieldFind2Replace
                                    width: (contentCol2.width - btn1ContentCol2.width - units.gu(5))/2
                                    placeholderText: i18n.tr("Search")
                                }
                                TextField {
                                    id: fieldReplace
                                    width: fieldFind2Replace.width
                                    placeholderText: i18n.tr("Replace")
                                }
                                Button {
                                    id: btn1ContentCol2
                                    anchors { left: fieldReplace.right + units.gu(1); }
                                    width: units.gu(4)
                                    text: "»"
                                    enabled: fieldFind2Replace.text && fieldReplace.text
                                    color: UbuntuColors.green
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.get('wp').setContent(tinyMCE.get('wp').getContent().replace(/" + fieldFind2Replace.text + "/g, \"" + fieldReplace.text + "\"))");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                    }
                }

                ListItem.Expandable {
                    id: expandingItem3
                    expandedHeight: contentCol3.height + units.gu(1)
                    onClicked: {
                        expanded = !expanded;
                    }
                    Column {
                        id: contentCol3
                        anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                        Item {
                            anchors { left: parent.left; right: parent.right}
                            height: expandingItem3.collapsedHeight
                            Label {
                                anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter}
                                text: i18n.tr("Insert")
                            }
                        }

                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Horizontal line")
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('mceInsertContent', false, '<hr>')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Current date")
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('mceInsertDate')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Current time")
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('mceInsertTime')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Image…")
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        pageMenu.expandImg = !pageMenu.expandImg
                                    }
                                }
                            }
                            Row {
                                spacing: units.gu(1)
                                anchors { left: parent.left; leftMargin: units.gu(3);right: parent.right}
                                visible: pageMenu.expandImg
                                height: units.gu(6)
                                TextField {
                                    id: fieldImg
                                    width: contentCol3.width - btn1ContentCol3.width - units.gu(5)
                                    placeholderText: i18n.tr("Image link")
                                }
                                Button {
                                    id: btn1ContentCol3
                                    anchors { left: fieldImg.right + units.gu(1); }
                                    width: units.gu(4)
                                    text: "»"
                                    enabled: fieldImg.text.trim()
                                    color: UbuntuColors.green
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('mceInsertContent', false, '<img src=\"" + fieldImg.text.trim() + "\">')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Link…")
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        pageMenu.expandLink = !pageMenu.expandLink;
                                    }
                                }
                            }
                            Row {
                                spacing: units.gu(1)
                                anchors { left: parent.left; leftMargin: units.gu(3); }
                                visible: pageMenu.expandLink
                                height: units.gu(6)
                                TextField {
                                    id: fieldLink
                                    width: contentCol3.width - btn2ContentCol3.width - units.gu(5)
                                    placeholderText: i18n.tr("URL (empty = remove)")
                                }
                                Button {
                                    id: btn2ContentCol3
                                    anchors.leftMargin: units.gu(0.2)
                                    width: units.gu(4)
                                    text: "»"
                                    color: UbuntuColors.green
                                    onClicked: {
                                        if (!fieldLink.text.trim()) {
                                            mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('Unlink')");
                                        }
                                        else {
                                            mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('mceInsertLink', false, '" + fieldLink.text.trim() + "')");
                                        }
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                    }
                }
                
                ListItem.Expandable {
                    id: expandingItem7
                    expandedHeight: contentCol7.height + units.gu(1)
                    onClicked: {
                        expanded = !expanded;
                    }
                    Column {
                        id: contentCol7
                        anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                        Item {
                            anchors { left: parent.left; right: parent.right}
                            height: expandingItem7.collapsedHeight
                            Label {
                                anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter}
                                text: i18n.tr("Table")
                            }
                        }

                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Insert…")
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        pageMenu.expandTableCreate = !pageMenu.expandTableCreate
                                    }
                                }
                            }
                            Row {
                                spacing: units.gu(1)
                                anchors { left: parent.left; leftMargin: units.gu(3);}
                                visible: pageMenu.expandTableCreate
                                height: units.gu(6)
                                TextField {
                                    id: fieldRows
                                    validator: IntValidator{bottom: 1; top: 50;}
                                    inputMethodHints: Qt.ImhDialableCharactersOnly
                                    width: (contentCol7.width - btn1contentCol7.width - separatorcontentCol7.width - units.gu(7))/2
                                    placeholderText: i18n.tr("Rows")
                                }
                                Label {
                                    id: separatorcontentCol7
                                    text: "x"
                                    height: units.gu(4)
                                    verticalAlignment: Text.AlignVCenter
                                }
                                TextField {
                                    id: fieldCols
                                    validator: IntValidator{bottom: 1; top: 10;}
                                    inputMethodHints: Qt.ImhDialableCharactersOnly
                                    width: fieldRows.width
                                    placeholderText: i18n.tr("Cols")
                                }
                                Button {
                                    id: btn1contentCol7
                                    anchors { left: fieldImg.right + units.gu(1); }
                                    width: units.gu(4)
                                    text: "»"
                                    enabled: (fieldRows.text && fieldCols.text)
                                    color: UbuntuColors.green
                                    onClicked: {
                                        var grid_table = "";
                                        var r = 1;
                                        var c = 1;
                                        while (r <= parseInt(fieldRows.text)) {
                                            c = 1;
                                            grid_table = grid_table + "<tr>";
                                            while (c <= parseInt(fieldCols.text)) {
                                                grid_table = grid_table + "<td></td>";
                                                c++;
                                            }
                                            grid_table = grid_table + "</tr>";
                                            r++;
                                        }
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('mceInsertContent', false, '<table width=\"100%\"><tbody>" + grid_table + "</tbody></table>')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Delete")
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('mceTableDelete')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                    }
                }
                
                ListItem.Expandable {
                    id: expandingItem4
                    expandedHeight: contentCol4.height + units.gu(1)
                    onClicked: {
                        expanded = !expanded;
                    }
                    Column {
                        id: contentCol4
                        anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                        Item {
                            anchors { left: parent.left; right: parent.right}
                            height: expandingItem4.collapsedHeight
                            Label {
                                anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter}
                                text: i18n.tr("Text")
                            }
                        }

                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Bold")
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('Bold')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                        }
                                    }
                                }
                            }
                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Italic")
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('Italic')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Underline")
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('Underline')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Strikethrough")
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('Strikethrough')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Superscript")
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('Superscript')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Subscript")
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('Subscript')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                    }
                }
                

                ListItem.Expandable {
                    id: expandingItem5
                    expandedHeight: contentCol5.height + units.gu(1)
                    onClicked: {
                        expanded = !expanded;
                    }
                    Column {
                        id: contentCol5
                        anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                        Item {
                            anchors { left: parent.left; right: parent.right}
                            height: expandingItem5.collapsedHeight
                            Label {
                                anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter}
                                text: i18n.tr("Alignment")
                            }
                        }

                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Left")
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('JustifyLeft')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Center")
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('JustifyCenter')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Right")
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('JustifyRight')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Justify")
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('JustifyFull')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                    }
                }
                


                ListItem.Expandable {
                    id: expandingItem6
                    expandedHeight: contentCol6.height + units.gu(1)
                    onClicked: {
                        expanded = !expanded;
                    }
                    Column {
                        id: contentCol6
                        anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                        Item {
                            anchors { left: parent.left; right: parent.right}
                            height: expandingItem6.collapsedHeight
                            Label {
                                anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter}
                                text: i18n.tr("Heading")
                            }
                        }

                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Heading %1").arg('1')
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('FormatBlock', false, 'h1')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Heading %1").arg('2')
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('FormatBlock', false, 'h2')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Heading %1").arg('3')
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('FormatBlock', false, 'h3')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Heading %1").arg('4')
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('FormatBlock', false, 'h4')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Heading %1").arg('5')
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('FormatBlock', false, 'h5')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                            Label {
                                anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                                height: units.gu(4)
                                text: i18n.tr("Heading %1").arg('6')
                                color: "#2a2a2a"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        mainPageStack.executeJavaScript("tinyMCE.activeEditor.execCommand('FormatBlock', false, 'h6')");
                                        if (mainPageStack.columns === 1) {
                                            mainPageStack.childPageOpened = false;
                                            mainPageStack.removePages(pageMenu);
                                        }

                                    }
                                }
                            }
                    }
                }
                
                ListItem.Expandable {
                    id: expandingItem8
                    expandedHeight: contentCol8.height + units.gu(1)
                    onClicked: {
                        Qt.openUrlExternally("https://costales.github.io/posts/how-to-print-document-from-uwriter//")
                    }
                    Column {
                        id: contentCol8
                        anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); }
                        Item {
                            anchors { left: parent.left; right: parent.right}
                            height: expandingItem8.collapsedHeight
                            Label {
                                anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter}
                                text: i18n.tr("Print…")
                            }
                        }
                    }
                }

            }
    }
}
