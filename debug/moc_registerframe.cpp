/****************************************************************************
** Meta object code from reading C++ file 'registerframe.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.9.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../src/frame_management/registerframe.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'registerframe.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.9.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_RegisterFrame_t {
    QByteArrayData data[10];
    char stringdata0[133];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_RegisterFrame_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_RegisterFrame_t qt_meta_stringdata_RegisterFrame = {
    {
QT_MOC_LITERAL(0, 0, 13), // "RegisterFrame"
QT_MOC_LITERAL(1, 14, 19), // "updateFeedbackLabel"
QT_MOC_LITERAL(2, 34, 0), // ""
QT_MOC_LITERAL(3, 35, 16), // "feedback_message"
QT_MOC_LITERAL(4, 52, 14), // "feedback_color"
QT_MOC_LITERAL(5, 67, 7), // "success"
QT_MOC_LITERAL(6, 75, 16), // "userRegisteredIn"
QT_MOC_LITERAL(7, 92, 6), // "signUp"
QT_MOC_LITERAL(8, 99, 16), // "entered_username"
QT_MOC_LITERAL(9, 116, 16) // "entered_password"

    },
    "RegisterFrame\0updateFeedbackLabel\0\0"
    "feedback_message\0feedback_color\0success\0"
    "userRegisteredIn\0signUp\0entered_username\0"
    "entered_password"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_RegisterFrame[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       3,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       2,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    3,   29,    2, 0x06 /* Public */,
       6,    0,   36,    2, 0x06 /* Public */,

 // methods: name, argc, parameters, tag, flags
       7,    2,   37,    2, 0x02 /* Public */,

 // signals: parameters
    QMetaType::Void, QMetaType::QString, QMetaType::QString, QMetaType::Bool,    3,    4,    5,
    QMetaType::Void,

 // methods: parameters
    QMetaType::Void, QMetaType::QString, QMetaType::QString,    8,    9,

       0        // eod
};

void RegisterFrame::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        RegisterFrame *_t = static_cast<RegisterFrame *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->updateFeedbackLabel((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2])),(*reinterpret_cast< bool(*)>(_a[3]))); break;
        case 1: _t->userRegisteredIn(); break;
        case 2: _t->signUp((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            typedef void (RegisterFrame::*_t)(QString , QString , bool );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&RegisterFrame::updateFeedbackLabel)) {
                *result = 0;
                return;
            }
        }
        {
            typedef void (RegisterFrame::*_t)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&RegisterFrame::userRegisteredIn)) {
                *result = 1;
                return;
            }
        }
    }
}

const QMetaObject RegisterFrame::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_RegisterFrame.data,
      qt_meta_data_RegisterFrame,  qt_static_metacall, nullptr, nullptr}
};


const QMetaObject *RegisterFrame::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *RegisterFrame::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_RegisterFrame.stringdata0))
        return static_cast<void*>(this);
    if (!strcmp(_clname, "RequestingFrame"))
        return static_cast< RequestingFrame*>(this);
    return QObject::qt_metacast(_clname);
}

int RegisterFrame::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 3)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 3;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 3)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 3;
    }
    return _id;
}

// SIGNAL 0
void RegisterFrame::updateFeedbackLabel(QString _t1, QString _t2, bool _t3)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)), const_cast<void*>(reinterpret_cast<const void*>(&_t3)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void RegisterFrame::userRegisteredIn()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
