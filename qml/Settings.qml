/*
 * uWriter http://launchpad.net/uwriter
 * Copyright (C) 2015-2016 Marcos Alvarez Costales https://launchpad.net/~costales
 * Copyright (C) 2015-2016 JkB https://launchpad.net/~joergberroth
 * Copyright (C) 2016 Nekhelesh Ramananthan https://launchpad.net/~nik90
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
import "components"

Page {
    id: pageSettings

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Settings")
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
                            pageMain.pageStack.addPageToNextColumn(pageMain, Qt.resolvedUrl("Menu.qml"));
                            mainPageStack.removePages(pageSettings);
                        }
                    }
                }
            ]
        }
    }

    ListModel {
        id: editorColorsModeModel
        Component.onCompleted: initialize()
        function initialize() {
            editorColorsModeModel.append({ "mode": i18n.tr("Black on white"),     "index": 0 })
            editorColorsModeModel.append({ "mode": i18n.tr("White on black"),     "index": 1 })
            editorColorsModeModel.append({ "mode": i18n.tr("White on aubergine"), "index": 2 })
            editorColorsModeModel.append({ "mode": i18n.tr("Grey on blue"),       "index": 3 })

            modeList.subText.text = editorColorsModeModel.get(mainPageStack.settings.editorColors).mode
        }
    }

    Flickable {
        id: flickable
        anchors {
            top: pageHeader.bottom
            left: parent.left
            right: parent.right
        }
        contentHeight: settingsColumn.height + units.gu(4)

        Column {
            id: settingsColumn

            anchors.fill: parent

            ListItemHeader {
                 id: editorColorsListHeader
                 title: i18n.tr("Interface")
            }

            ExpandableListItem {
                id: modeList

                listViewHeight: units.gu(17+1)
                titleText.text: i18n.tr("Color Schemes")

                model: editorColorsModeModel

                delegate: ListItem {
                    divider.visible: false
                    height: editorColorsListItemLayout.height
                    ListItemLayout {
                        id: editorColorsListItemLayout
                        title.text: model.mode
                        title.color: "#5D5D5D"
                        padding { top: units.gu(1); bottom: units.gu(1) }
                        Icon {
                            SlotsLayout.position: SlotsLayout.Trailing
                            width: units.gu(2)
                            name: "tick"
                            visible: mainPageStack.settings.editorColors === model.index
                        }
                    }

                    onClicked: {
                        mainPageStack.settings.editorColors = model.index;
                        mainPageStack.executeJavaScript("editor_colors(" + model.index + ")");
                        modeList.subText.text = editorColorsModeModel.get(mainPageStack.settings.editorColors).mode;
                        modeList.toggleExpansion();
                    }
                }
            }

            ListItem {
                height: convergenceLayout.height + divider.height
                ListItemLayout {
                    id: convergenceLayout
                    title.text: i18n.tr("Convergence")
                    Switch {
                        id: convergenceSwitch
                        checked: mainPageStack.settings.convergence
                        onClicked: {
                            mainPageStack.settings.convergence = checked;
                        }
                        SlotsLayout.position: SlotsLayout.Last
                    }
                }
            }


            ListItemHeader {
                id: docListHeader
                title: i18n.tr("Document")
            }
            
            ListItem {
                height: autosaveLayout.height + divider.height
                ListItemLayout {
                    id: autosaveLayout
                    title.text: i18n.tr("Autosave (needs be saved before)")
                    Switch {
                        id: autosaveSwitch
                        checked: mainPageStack.settings.autosave
                        onClicked: {
                            mainPageStack.settings.autosave = checked;
                        }
                        SlotsLayout.position: SlotsLayout.Last
                    }
                }
            }
        }

    }
}
