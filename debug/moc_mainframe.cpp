/****************************************************************************
** Meta object code from reading C++ file 'mainframe.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.9.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../src/frame_management/mainframe.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'mainframe.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.9.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_MainFrame_t {
    QByteArrayData data[29];
    char stringdata0[478];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_MainFrame_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_MainFrame_t qt_meta_stringdata_MainFrame = {
    {
QT_MOC_LITERAL(0, 0, 9), // "MainFrame"
QT_MOC_LITERAL(1, 10, 21), // "finishedAddingContact"
QT_MOC_LITERAL(2, 32, 0), // ""
QT_MOC_LITERAL(3, 33, 10), // "add_result"
QT_MOC_LITERAL(4, 44, 7), // "err_msg"
QT_MOC_LITERAL(5, 52, 13), // "statusChanged"
QT_MOC_LITERAL(6, 66, 14), // "new_status_gui"
QT_MOC_LITERAL(7, 81, 12), // "new_date_gui"
QT_MOC_LITERAL(8, 94, 37), // "receivedMessageForCurrentConv..."
QT_MOC_LITERAL(9, 132, 22), // "receivedForeignContact"
QT_MOC_LITERAL(10, 155, 10), // "addContact"
QT_MOC_LITERAL(11, 166, 16), // "entered_username"
QT_MOC_LITERAL(12, 183, 16), // "updateUserStatus"
QT_MOC_LITERAL(13, 200, 14), // "entered_status"
QT_MOC_LITERAL(14, 215, 18), // "getCurrentUsername"
QT_MOC_LITERAL(15, 234, 16), // "getCurrentStatus"
QT_MOC_LITERAL(16, 251, 20), // "getCurrentStatusDate"
QT_MOC_LITERAL(17, 272, 18), // "refreshContactsGUI"
QT_MOC_LITERAL(18, 291, 10), // "logOutUser"
QT_MOC_LITERAL(19, 302, 20), // "loadConversationWith"
QT_MOC_LITERAL(20, 323, 12), // "contact_name"
QT_MOC_LITERAL(21, 336, 25), // "finishCurrentConversation"
QT_MOC_LITERAL(22, 362, 18), // "refreshMessagesGUI"
QT_MOC_LITERAL(23, 381, 11), // "sendMessage"
QT_MOC_LITERAL(24, 393, 22), // "conversation_recipient"
QT_MOC_LITERAL(25, 416, 12), // "entered_text"
QT_MOC_LITERAL(26, 429, 17), // "addForeignContact"
QT_MOC_LITERAL(27, 447, 17), // "refreshContactGUI"
QT_MOC_LITERAL(28, 465, 12) // "username_gui"

    },
    "MainFrame\0finishedAddingContact\0\0"
    "add_result\0err_msg\0statusChanged\0"
    "new_status_gui\0new_date_gui\0"
    "receivedMessageForCurrentConversation\0"
    "receivedForeignContact\0addContact\0"
    "entered_username\0updateUserStatus\0"
    "entered_status\0getCurrentUsername\0"
    "getCurrentStatus\0getCurrentStatusDate\0"
    "refreshContactsGUI\0logOutUser\0"
    "loadConversationWith\0contact_name\0"
    "finishCurrentConversation\0refreshMessagesGUI\0"
    "sendMessage\0conversation_recipient\0"
    "entered_text\0addForeignContact\0"
    "refreshContactGUI\0username_gui"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_MainFrame[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
      18,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       5,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    2,  104,    2, 0x06 /* Public */,
       5,    3,  109,    2, 0x06 /* Public */,
       5,    2,  116,    2, 0x26 /* Public | MethodCloned */,
       8,    0,  121,    2, 0x06 /* Public */,
       9,    0,  122,    2, 0x06 /* Public */,

 // methods: name, argc, parameters, tag, flags
      10,    1,  123,    2, 0x02 /* Public */,
      12,    1,  126,    2, 0x02 /* Public */,
      14,    0,  129,    2, 0x02 /* Public */,
      15,    0,  130,    2, 0x02 /* Public */,
      16,    0,  131,    2, 0x02 /* Public */,
      17,    0,  132,    2, 0x02 /* Public */,
      18,    0,  133,    2, 0x02 /* Public */,
      19,    1,  134,    2, 0x02 /* Public */,
      21,    0,  137,    2, 0x02 /* Public */,
      22,    0,  138,    2, 0x02 /* Public */,
      23,    2,  139,    2, 0x02 /* Public */,
      26,    0,  144,    2, 0x02 /* Public */,
      27,    1,  145,    2, 0x02 /* Public */,

 // signals: parameters
    QMetaType::Void, QMetaType::Bool, QMetaType::QString,    3,    4,
    QMetaType::Void, QMetaType::QString, QMetaType::QString, QMetaType::QString,    6,    7,    4,
    QMetaType::Void, QMetaType::QString, QMetaType::QString,    6,    7,
    QMetaType::Void,
    QMetaType::Void,

 // methods: parameters
    QMetaType::Void, QMetaType::QString,   11,
    QMetaType::Void, QMetaType::QString,   13,
    QMetaType::QString,
    QMetaType::QString,
    QMetaType::QString,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString,   20,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString, QMetaType::QString,   24,   25,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString,   28,

       0        // eod
};

void MainFrame::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        MainFrame *_t = static_cast<MainFrame *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->finishedAddingContact((*reinterpret_cast< bool(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        case 1: _t->statusChanged((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2])),(*reinterpret_cast< QString(*)>(_a[3]))); break;
        case 2: _t->statusChanged((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        case 3: _t->receivedMessageForCurrentConversation(); break;
        case 4: _t->receivedForeignContact(); break;
        case 5: _t->addContact((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 6: _t->updateUserStatus((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 7: { QString _r = _t->getCurrentUsername();
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        case 8: { QString _r = _t->getCurrentStatus();
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        case 9: { QString _r = _t->getCurrentStatusDate();
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        case 10: _t->refreshContactsGUI(); break;
        case 11: _t->logOutUser(); break;
        case 12: _t->loadConversationWith((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 13: _t->finishCurrentConversation(); break;
        case 14: _t->refreshMessagesGUI(); break;
        case 15: _t->sendMessage((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        case 16: _t->addForeignContact(); break;
        case 17: _t->refreshContactGUI((*reinterpret_cast< QString(*)>(_a[1]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            typedef void (MainFrame::*_t)(bool , QString );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&MainFrame::finishedAddingContact)) {
                *result = 0;
                return;
            }
        }
        {
            typedef void (MainFrame::*_t)(QString , QString , QString );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&MainFrame::statusChanged)) {
                *result = 1;
                return;
            }
        }
        {
            typedef void (MainFrame::*_t)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&MainFrame::receivedMessageForCurrentConversation)) {
                *result = 3;
                return;
            }
        }
        {
            typedef void (MainFrame::*_t)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&MainFrame::receivedForeignContact)) {
                *result = 4;
                return;
            }
        }
    }
}

const QMetaObject MainFrame::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_MainFrame.data,
      qt_meta_data_MainFrame,  qt_static_metacall, nullptr, nullptr}
};


const QMetaObject *MainFrame::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *MainFrame::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_MainFrame.stringdata0))
        return static_cast<void*>(this);
    if (!strcmp(_clname, "RequestingFrame"))
        return static_cast< RequestingFrame*>(this);
    return QObject::qt_metacast(_clname);
}

int MainFrame::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 18)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 18;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 18)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 18;
    }
    return _id;
}

// SIGNAL 0
void MainFrame::finishedAddingContact(bool _t1, QString _t2)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void MainFrame::statusChanged(QString _t1, QString _t2, QString _t3)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)), const_cast<void*>(reinterpret_cast<const void*>(&_t3)) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}

// SIGNAL 3
void MainFrame::receivedMessageForCurrentConversation()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void MainFrame::receivedForeignContact()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
