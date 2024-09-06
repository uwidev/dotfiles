// import './lib/test.ts'
import 'style/style' // style is applied during import
import { NotificationsPopups } from './widgets/notifications/notificationsPopups'
import { Bar } from './widgets/bar/bar'
import Launcher from './widgets/launcher/launcher'

App.config({
    windows: [
        Bar(0),
        // Bar(1),
        NotificationsPopups(0),
        Launcher()
    ],
})

export { }
