/****************************************************************************
** Meta object code from reading C++ file 'usermanagement.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.9.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../usermanagement.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'usermanagement.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.9.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_UserManagement_t {
    QByteArrayData data[12];
    char stringdata0[177];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_UserManagement_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_UserManagement_t qt_meta_stringdata_UserManagement = {
    {
QT_MOC_LITERAL(0, 0, 14), // "UserManagement"
QT_MOC_LITERAL(1, 15, 25), // "errorLabelNotExistentUser"
QT_MOC_LITERAL(2, 41, 0), // ""
QT_MOC_LITERAL(3, 42, 8), // "response"
QT_MOC_LITERAL(4, 51, 18), // "refreshContactList"
QT_MOC_LITERAL(5, 70, 10), // "newContact"
QT_MOC_LITERAL(6, 81, 24), // "refreshMessageListFromMe"
QT_MOC_LITERAL(7, 106, 11), // "contactName"
QT_MOC_LITERAL(8, 118, 3), // "msg"
QT_MOC_LITERAL(9, 122, 5), // "index"
QT_MOC_LITERAL(10, 128, 34), // "pushMessageListForConversatio..."
QT_MOC_LITERAL(11, 163, 13) // "deleteContact"

    },
    "UserManagement\0errorLabelNotExistentUser\0"
    "\0response\0refreshContactList\0newContact\0"
    "refreshMessageListFromMe\0contactName\0"
    "msg\0index\0pushMessageListForConversationWith\0"
    "deleteContact"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_UserManagement[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       5,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    1,   39,    2, 0x06 /* Public */,

 // methods: name, argc, parameters, tag, flags
       4,    1,   42,    2, 0x02 /* Public */,
       6,    3,   45,    2, 0x02 /* Public */,
      10,    1,   52,    2, 0x02 /* Public */,
      11,    1,   55,    2, 0x02 /* Public */,

 // signals: parameters
    QMetaType::Void, QMetaType::Bool,    3,

 // methods: parameters
    QMetaType::Void, QMetaType::QString,    5,
    QMetaType::Void, QMetaType::QString, QMetaType::QString, QMetaType::Int,    7,    8,    9,
    QMetaType::Void, QMetaType::QString,    7,
    QMetaType::Void, QMetaType::QString,    7,

       0        // eod
};

void UserManagement::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        UserManagement *_t = static_cast<UserManagement *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->errorLabelNotExistentUser((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 1: _t->refreshContactList((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 2: _t->refreshMessageListFromMe((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2])),(*reinterpret_cast< int(*)>(_a[3]))); break;
        case 3: _t->pushMessageListForConversationWith((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 4: _t->deleteContact((*reinterpret_cast< QString(*)>(_a[1]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            typedef void (UserManagement::*_t)(bool );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&UserManagement::errorLabelNotExistentUser)) {
                *result = 0;
                return;
            }
        }
    }
}

const QMetaObject UserManagement::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_UserManagement.data,
      qt_meta_data_UserManagement,  qt_static_metacall, nullptr, nullptr}
};


const QMetaObject *UserManagement::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *UserManagement::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_UserManagement.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int UserManagement::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 5)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 5;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 5)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 5;
    }
    return _id;
}

// SIGNAL 0
void UserManagement::errorLabelNotExistentUser(bool _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
