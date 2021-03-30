CONFIG -= qt
CONFIG -= gui

TEMPLATE = lib
#Comment for dynamic library
#CONFIG += staticlib

DEFINES += QT_DEPRECATED_WARNINGS

CONFIG += c++11

TARGET = OSCPACK
RC_ICONS = ../MixFaceMedia/mf_icon_16.ico
#win32:VERSION = 1.1.0.3
#else:VERSION = 1.1.0
QMAKE_TARGET_COMPANY = "Ross Bencina <rossb@audiomulch.com>"
QMAKE_TARGET_DESCRIPTION = "Open Sound Control packet manipulation library."
QMAKE_TARGET_COPYRIGHT = "MIT License."
QMAKE_TARGET_PRODUCT = "OSCPACK Library."
QMAKE_TARGET_ORIGINAL_FILENAME = OSCPACK.dll

SOURCES += \
ip/IpEndpointName.cpp \
osc/OscOutboundPacketStream.cpp \
osc/OscPrintReceivedElements.cpp \
osc/OscReceivedElements.cpp \
osc/OscTypes.cpp

win32{
    SOURCES += ip/win32/NetworkingUtils.cpp
    SOURCES += ip/win32/UdpSocket.cpp
}else{
    SOURCES += ip/posix/NetworkingUtils.cpp
    SOURCES += ip/posix/UdpSocket.cpp
}

HEADERS += \
ip/IpEndpointName.h \
ip/NetworkingUtils.h \
ip/PacketListener.h \
ip/TimerListener.h \
ip/UdpSocket.h \
osc/MessageMappingOscPacketListener.h \
osc/OscException.h \
osc/OscHostEndianness.h \
osc/OscOutboundPacketStream.h \
osc/OscPacketListener.h \
osc/OscPrintReceivedElements.h \
osc/OscReceivedElements.h \
osc/OscTypes.h

win32{
LIBS += -lkernel32 -lws2_32 -lwinmm
}

# Default rules for deployment.
unix {
    target.path = /usr/lib
}
!isEmpty(target.path): INSTALLS += target
