import QtQuick
import QtQuick.Controls

Item {
    id: newbutton

    property alias text: buttonText.text

    signal clicked

    implicitWidth: buttonText.implicitWidth + 5
    implicitHeight: buttonText.implicitHeight + 10

    Button {
        id: buttonText
        width: parent.width
        height: parent.height

        style: ButtonStyle {
            label: Component {
                Text {
                    text: buttonText.text
                    clip: true
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    anchors.fill: parent
                }
            }
        }
        onClicked: newbutton.clicked()
    }
}