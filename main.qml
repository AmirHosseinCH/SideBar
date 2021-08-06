import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: window

    width: 750
    height: 850
    visible: true
    title: 'SideBar'
    color: '#E0E2ED'

    FontLoader {
        id: sourceSansProFont

        source: 'fonts/SourceSansPro-Regular.ttf'
        name: 'SourceSansPro'
    }

    SideBar {}
}
