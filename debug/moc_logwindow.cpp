/****************************************************************************
** Meta object code from reading C++ file 'logwindow.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.9.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../logwindow.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'logwindow.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.9.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_LogFrame_t {
    QByteArrayData data[10];
    char stringdata0[112];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_LogFrame_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_LogFrame_t qt_meta_stringdata_LogFrame = {
    {
QT_MOC_LITERAL(0, 0, 8), // "LogFrame"
QT_MOC_LITERAL(1, 9, 16), // "updateErrorLabel"
QT_MOC_LITERAL(2, 26, 0), // ""
QT_MOC_LITERAL(3, 27, 7), // "err_msg"
QT_MOC_LITERAL(4, 35, 12), // "userLoggedIn"
QT_MOC_LITERAL(5, 48, 13), // "signInClicked"
QT_MOC_LITERAL(6, 62, 15), // "refreshUsername"
QT_MOC_LITERAL(7, 78, 8), // "username"
QT_MOC_LITERAL(8, 87, 15), // "refreshPassword"
QT_MOC_LITERAL(9, 103, 8) // "password"

    },
    "LogFrame\0updateErrorLabel\0\0err_msg\0"
    "userLoggedIn\0signInClicked\0refreshUsername\0"
    "username\0refreshPassword\0password"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_LogFrame[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       5,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       2,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    1,   39,    2, 0x06 /* Public */,
       4,    0,   42,    2, 0x06 /* Public */,

 // methods: name, argc, parameters, tag, flags
       5,    0,   43,    2, 0x02 /* Public */,
       6,    1,   44,    2, 0x02 /* Public */,
       8,    1,   47,    2, 0x02 /* Public */,

 // signals: parameters
    QMetaType::Void, QMetaType::QString,    3,
    QMetaType::Void,

 // methods: parameters
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString,    7,
    QMetaType::Void, QMetaType::QString,    9,

       0        // eod
};

void LogFrame::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        LogFrame *_t = static_cast<LogFrame *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->updateErrorLabel((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 1: _t->userLoggedIn(); break;
        case 2: _t->signInClicked(); break;
        case 3: _t->refreshUsername((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 4: _t->refreshPassword((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            typedef void (LogFrame::*_t)(QString );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&LogFrame::updateErrorLabel)) {
                *result = 0;
                return;
            }
        }
        {
            typedef void (LogFrame::*_t)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&LogFrame::userLoggedIn)) {
                *result = 1;
                return;
            }
        }
    }
}

const QMetaObject LogFrame::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_LogFrame.data,
      qt_meta_data_LogFrame,  qt_static_metacall, nullptr, nullptr}
};


const QMetaObject *LogFrame::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *LogFrame::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_LogFrame.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int LogFrame::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
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
void LogFrame::updateErrorLabel(QString _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void LogFrame::userLoggedIn()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
