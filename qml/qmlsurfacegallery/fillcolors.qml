Rectangle {
    width: 200; height: 200

    ListModel {
        id: fruitModel

        ListElement {
            color1: "aliceblue"
            name: '#f0f8ff'
        }
    }

    Component {
        id: fruitDelegate
        Row {
            spacing: 10
            Text { text: color1 ; width: 100}
            Text { text: name ; width: 100}
        }
    }

    ListView {
        anchors.fill: parent
        model: fruitModel
        delegate: fruitDelegate
    }
}


function insertList() {
    for (var prop in colorColor)
        fruitModel.append({"color1": prop, "name": colorColor[prop]}
        )
}