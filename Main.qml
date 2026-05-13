import QtQuick
import QtQuick.Controls
import QtQuick.Layouts 
import CryptAlgorithm

ApplicationWindow {
    id: root
    width:600
    height: 778
    visible: true
    title: "CryptAlgorithm - Шифрование подстановкой"
    
    // Цветовая схема
    readonly property color bgColor: "#0a0a0f"
    readonly property color surfaceColor: "#1a1a1f"
    readonly property color cardColor: "#25252b"
    readonly property color accentColor: '#ffffff'
    readonly property color successColor: '#3d3d3d'
    readonly property color warningColor: '#626262'
    readonly property color errorColor: "#e74c3c"
    readonly property color textColor: "#ffffff"
    readonly property color textSecondary: "#8e8e93"
    
    color: bgColor
    
    CipherLogic {
        id: cipher
        onNotification: (msg, isErr) => {
            showNotification(msg, isErr)
        }
    }
    
    // Основной контейнер
    Column {
        id: mainColumn
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15
        
        // Заголовок
        Rectangle {
            width: parent.width
            height: 70
            color: surfaceColor
            radius: 12
            
            Text {
                anchors.centerIn: parent
                text: "Шифрование подстановкой"
                font.pixelSize: 24
                font.bold: true
                color: accentColor
                
                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation { from: 0.8; to: 1; duration: 1500 }
                    NumberAnimation { from: 1; to: 0.8; duration: 1500 }
                }
            }
        }
        
        // Ключевое слово
        Rectangle {
            width: parent.width
            height: 90
            color: cardColor
            radius: 12
            
            Column {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8
                
                Text {
                    text: "КЛЮЧЕВОЕ СЛОВО"
                    color: textSecondary
                    font.pixelSize: 10
                    font.bold: true
                }
                
                Row {
                    width: parent.width
                    spacing: 10
                    
                    Rectangle {
                        width: parent.width - 110
                        height: 40
                        color: surfaceColor
                        radius: 8
                        border.color: keywordField.activeFocus ? accentColor : "#333"
                        border.width: 1
                        
                        TextInput {
                            id: keywordField
                            anchors.fill: parent
                            anchors.margins: 10
                            color: textColor
                            font.pixelSize: 12
                            selectionColor: accentColor
                            cursorVisible: true
                            onTextChanged: cipher.keyword = text
                        }
                        
                        Text {
                            anchors.fill: parent
                            anchors.margins: 10
                            text: "Введите ключевое слово"
                            color: textSecondary
                            font.pixelSize: 12
                            visible: keywordField.text.length === 0
                        }
                    }
                    
                    Rectangle {
                        width: 100
                        height: 40
                        color: accentColor
                        radius: 8
                        opacity: keywordField.text.length > 0 ? 1 : 0.5
                        
                        Text {
                            anchors.centerIn: parent
                            text: "СГЕНЕРИРОВАТЬ"
                            color: "white"
                            font.pixelSize: 10
                            font.weight: Font.Medium
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            enabled: keywordField.text.length > 0
                            onClicked: {
                                cipher.generateAlphabet()
                                generateAnim.start()
                            }
                        }
                        
                        SequentialAnimation {
                            id: generateAnim
                            PropertyAnimation {
                                target: parent
                                property: "scale"
                                to: 0.95
                                duration: 100
                            }
                            PropertyAnimation {
                                target: parent
                                property: "scale"
                                to: 1
                                duration: 100
                            }
                        }
                    }
                }
            }
        }
        
        // Алфавит замены
        Rectangle {
            width: parent.width
            height: cipher.alphabetReady ? 100 : 70
            color: cardColor
            radius: 12
            
            Behavior on height {
                NumberAnimation { duration: 300 }
            }
            
            Column {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8
                
                Text {
                    text: "АЛФАВИТ ЗАМЕНЫ"
                    color: textSecondary
                    font.pixelSize: 10
                    font.bold: true
                }
                
                Text {
                    text: "Исходный: A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
                    color: textSecondary
                    font.pixelSize: 9
                    font.family: "monospace"
                    wrapMode: Text.WordWrap
                }
                
                Rectangle {
                    width: parent.width
                    height: 1
                    color: "#333"
                    visible: cipher.alphabetReady
                }
                
                Text {
                    text: cipher.alphabetReady ? 
                          "Замены: " + cipher.cipherAlphabet : 
                          "✦ Алфавит не сгенерирован ✦"
                    color: cipher.alphabetReady ? accentColor : textSecondary
                    font.pixelSize: 9
                    font.family: "monospace"
                    wrapMode: Text.WordWrap
                }
            }
        }
        
        // Входной текст
        Rectangle {
            width: parent.width
            height: 130
            color: cardColor
            radius: 12
            
            Column {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8
                
                Text {
                    text: "ВХОДНОЙ ТЕКСТ"
                    color: textSecondary
                    font.pixelSize: 10
                    font.bold: true
                }
                
                Rectangle {
                    width: parent.width
                    height: 70
                    color: surfaceColor
                    radius: 8
                    border.color: inputField.activeFocus ? accentColor : "#333"
                    border.width: 1
                    
                    Flickable {
                        anchors.fill: parent
                        anchors.margins: 8
                        contentHeight: inputField.height
                        clip: true
                        
                        TextArea {
                            id: inputField
                            width: parent.width
                            color: textColor
                            font.pixelSize: 12
                            wrapMode: Text.WordWrap
                            background: null
                            selectByMouse: true
                        }
                    }
                    
                    Text {
                        anchors.fill: parent
                        anchors.margins: 12
                        text: "Введите текст для шифрования или расшифрования..."
                        color: textSecondary
                        font.pixelSize: 12
                        visible: inputField.text.length === 0
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
        
        // Кнопки действий
        Row {
            width: parent.width
            spacing: 10
            
            Rectangle {
                width: (parent.width - 20) / 2
                height: 45
                color: successColor
                radius: 8
                opacity: cipher.alphabetReady && inputField.text.length > 0 ? 1 : 0.5
                
                Text {
                    anchors.centerIn: parent
                    text: "🔒 ЗАШИФРОВАТЬ"
                    color: "white"
                    font.pixelSize: 11
                    font.weight: Font.Medium
                }
                
                MouseArea {
                    anchors.fill: parent
                    enabled: cipher.alphabetReady && inputField.text.length > 0
                    onClicked: {
                        let result = cipher.encrypt(inputField.text)
                        if (result) outputField.text = result
                        encryptAnim.start()
                    }
                }
                
                SequentialAnimation {
                    id: encryptAnim
                    PropertyAnimation {
                        target: parent
                        property: "scale"
                        to: 0.97
                        duration: 100
                    }
                    PropertyAnimation {
                        target: parent
                        property: "scale"
                        to: 1
                        duration: 100
                    }
                }
            }
            
            Rectangle {
                width: (parent.width - 20) / 2
                height: 45
                color: warningColor
                radius: 8
                opacity: cipher.alphabetReady && inputField.text.length > 0 ? 1 : 0.5
                
                Text {
                    anchors.centerIn: parent
                    text: "🔓 РАСШИФРОВАТЬ"
                    color: "white"
                    font.pixelSize: 11
                    font.weight: Font.Medium
                }
                
                MouseArea {
                    anchors.fill: parent
                    enabled: cipher.alphabetReady && inputField.text.length > 0
                    onClicked: {
                        let result = cipher.decrypt(inputField.text)
                        if (result) outputField.text = result
                        decryptAnim.start()
                    }
                }
                
                SequentialAnimation {
                    id: decryptAnim
                    PropertyAnimation {
                        target: parent
                        property: "scale"
                        to: 0.97
                        duration: 100
                    }
                    PropertyAnimation {
                        target: parent
                        property: "scale"
                        to: 1
                        duration: 100
                    }
                }
            }
        }
        
        // Кнопка очистки
        Rectangle {
            width: parent.width
            height: 45
            color: "#2a2a2a"
            radius: 8
            
            Text {
                anchors.centerIn: parent
                text: "🗑 ОЧИСТИТЬ ВСЁ"
                color: textColor
                font.pixelSize: 11
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    inputField.text = ""
                    outputField.text = ""
                    clearAnim.start()
                }
            }
            
            SequentialAnimation {
                id: clearAnim
                PropertyAnimation {
                    target: parent
                    property: "scale"
                    to: 0.98
                    duration: 100
                }
                PropertyAnimation {
                    target: parent
                    property: "scale"
                    to: 1
                    duration: 100
                }
            }
        }
        
        // Результат
        Rectangle {
            width: parent.width
            height: 120
            color: cardColor
            radius: 12
            
            Column {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8
                
                Text {
                    text: "РЕЗУЛЬТАТ"
                    color: textSecondary
                    font.pixelSize: 10
                    font.bold: true
                }
                
                Rectangle {
                    width: parent.width
                    height: 70
                    color: surfaceColor
                    radius: 8
                    
                    Flickable {
                        anchors.fill: parent
                        anchors.margins: 8
                        contentHeight: outputField.height
                        clip: true
                        
                        TextArea {
                            id: outputField
                            width: parent.width
                            color: accentColor
                            font.pixelSize: 12
                            wrapMode: Text.WordWrap
                            readOnly: true
                            background: null
                            selectByMouse: true
                            
                            Behavior on color {
                                ColorAnimation { duration: 300 }
                            }
                        }
                    }
                    
                    Text {
                        anchors.fill: parent
                        anchors.margins: 12
                        text: "Результат появится здесь..."
                        color: textSecondary
                        font.pixelSize: 12
                        visible: outputField.text.length === 0
                        wrapMode: Text.WordWrap
                    }
                }
            }

        }

         // Заголовок
        Rectangle {
            width: parent.width
            height: 70
            color: surfaceColor
            radius: 12
            
            Text {
                anchors.centerIn: parent
                text: "Сделано Артёмом Мишиным из группы ТРИС-2-25 for love by Nonphix 2026"
                font.pixelSize: 12
                font.bold: true 
                color: textColor
                
                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation { from: 0.8; to: 1; duration: 1500 }
                    NumberAnimation { from: 1; to: 0.8; duration: 1500 }
                }
            }
        }
    }
    
    
    function showNotification(message, isError) {
        notificationText.text = message
        notification.color = isError ? errorColor : successColor
        showNotification.start()
    }
}