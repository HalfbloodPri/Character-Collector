from PyQt5.QtCore import QUrl, QObject, pyqtSlot, pyqtSignal
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQuick import QQuickView
import mnistMethod

path = 'mainWindow.qml'
app = QGuiApplication([])
view = QQuickView()
view.engine().quit.connect(app.quit)
view.setHeight(700)
view.setWidth(1200)
view.setSource(QUrl(path))
view.show()

context = view.rootContext()
root = view.rootObject()

context.setContextProperty("mnistHandler", mnistMethod.mnistHandler)

app.exec_()