/*
 * uWriter http://launchpad.net/uwriter
 * Copyright (C) 2015-2016 Marcos Alvarez Costales https://launchpad.net/~costales
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
import "js/utils.js" as QmlJs
import "components"

Page {
    id: aboutPage
    title: i18n.tr("About")

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("About")
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
                            mainPageStack.removePages(aboutPage);
                        }
                    }
                }
            ]
        }
    }


    ListModel {
        id: creditsModel

        Component.onCompleted: initialize()

        function initialize() {
            // Resources
            //creditsModel.append({ category: i18n.tr("Resources"), name: i18n.tr("Rate on Store"), link: "scope://com.canonical.scopes.clickstore?q=uwriter" })
            creditsModel.append({ category: i18n.tr("Resources"), name: i18n.tr("Translations"), link: "https://translations.launchpad.net/uwriter" })
            creditsModel.append({ category: i18n.tr("Resources"), name: i18n.tr("Answers"), link: "https://answers.launchpad.net/uwriter" })
            creditsModel.append({ category: i18n.tr("Resources"), name: i18n.tr("Bugs"), link: "https://bugs.launchpad.net/uwriter" })
            creditsModel.append({ category: i18n.tr("Resources"), name: i18n.tr("Contact"), link: "mailto:costales.marcos@gmail.com" })

            // Developers
            creditsModel.append({ category: i18n.tr("Developer"), name: "Marcos Costales", link: "https://wiki.ubuntu.com/costales" })

            // Artwork
            creditsModel.append({ category: i18n.tr("Logo"), name: "Sam Hewitt", link: "http://samuelhewitt.com/" })

            // Translators
            var translators = QmlJs.getTranslators( i18n.tr("translator-credits") )
            translators.forEach(function(translator) {
                creditsModel.append({ category: i18n.tr("Translators"), name: translator['name'], link: translator['link'] });
            });

            // Powered By
            creditsModel.append({ category: i18n.tr("Powered by"), name: "tinyMCE", link: "https://www.tinymce.com" })
        }
    }

    ListView {
        id: creditsListView

        model: creditsModel
        anchors.fill: parent
        section.property: "category"
        section.criteria: ViewSection.FullString
        section.delegate: ListItemHeader {
            title: section
        }

        header: Item {
            width: parent.width
            height: appColumn.height + units.gu(10)
            Column {
                id: appColumn
                spacing: units.gu(1)
                anchors {
                    top: parent.top; left: parent.left; right: parent.right; topMargin: units.gu(7)
                }
                Image {
                    id: appImage
                    source: "../assets/uwp.png"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Label {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    //TRANSLATORS: %1 and %2 are links that do not have to be translated: Year + Project + License
                    text: "© uWriter 2015-" + new Date().getFullYear()
                    onLinkActivated: Qt.openUrlExternally(link)
                }
                Label {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    //TRANSLATORS: %1 and %2 are links that do not have to be translated: Year + Project + License
                    text: i18n.tr("Version %1. Under license %2").arg("0.33").arg("<a href=\"http://www.gnu.org/licenses/gpl-3.0.en.html\">GPL3</a>")
                    onLinkActivated: Qt.openUrlExternally(link)
                }
            }
        }

        delegate: ListItem {
            height: creditsDelegateLayout.height
            divider.visible: false
            ListItemLayout {
                id: creditsDelegateLayout
                title.text: model.name
                ProgressionSlot {}
            }
            onClicked: Qt.openUrlExternally(model.link)
        }
    }
}

