cmake_minimum_required(VERSION 3.16.0)
PROJECT(OSCPACK VERSION 1.1.0.3 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)

OPTION(OSC_LIB_ONLY "Enable build only library" OFF)

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})

# separate versions of NetworkingUtils.cpp and UdpSocket.cpp are provided for Win32 and POSIX
# the IpSystemTypePath selects the correct ones based on the current platform

IF(WIN32)
    set(IpSystemTypePath ip/win32)
    set(LIBS ${LIBS} Ws2_32 winmm)
    #Place version to .rc
    set(STR_OSC_VERSION ${OSCPACK_VERSION})
    string(REPLACE "." "." RC_SPLIT ${STR_OSC_VERSION})
    string(REPLACE "." ";" RC_SPLIT ${RC_SPLIT})
    message(STATUS "OSCPACK is now: ${STR_OSC_VERSION}")
    list(GET RC_SPLIT 0 OSC_VERSION)
    list(GET RC_SPLIT 1 OSC_MAJOR_VERSION)
    list(GET RC_SPLIT 2 OSC_MINOR_VERSION)
    list(GET RC_SPLIT 3 OSC_PATCH_VERSION)
    configure_file(OSCPACK.rc.in ${PROJECT_BINARY_DIR}/OSCPACK.rc)
    set(SOURCES
        ${SOURCES}
        OSCPACK.rc.in
        ${PROJECT_BINARY_DIR}/OSCPACK.rc
        )
ELSE(WIN32)
 set(IpSystemTypePath ip/posix)
ENDIF(WIN32)

set(SOURCES ${SOURCES}

ip/IpEndpointName.h
ip/IpEndpointName.cpp

ip/NetworkingUtils.h
${IpSystemTypePath}/NetworkingUtils.cpp

ip/UdpSocket.h
${IpSystemTypePath}/UdpSocket.cpp

ip/PacketListener.h
ip/TimerListener.h

osc/OscTypes.h
osc/OscTypes.cpp 
osc/OscHostEndianness.h
osc/OscException.h
osc/OscPacketListener.h
osc/MessageMappingOscPacketListener.h
osc/OscReceivedElements.h
osc/OscReceivedElements.cpp
osc/OscPrintReceivedElements.h
osc/OscPrintReceivedElements.cpp
osc/OscOutboundPacketStream.h
osc/OscOutboundPacketStream.cpp

)

OPTION(OSC_LIB_STATIC "Build OSCPACK as static library" OFF)

if(OSC_LIB_STATIC)
    add_library(OSCPACK STATIC ${SOURCES})
endif()

if(NOT OSC_LIB_STATIC)
    add_library(OSCPACK SHARED ${SOURCES})
endif()

if(NOT ANDROID)
    set_target_properties(OSCPACK
        PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/Appfolder")
endif()

if(WIN32)
target_link_libraries(OSCPACK PRIVATE ${LIBS})
endif()

IF(NOT OSC_LIB_ONLY)
  ADD_EXECUTABLE(OscUnitTests tests/OscUnitTests.cpp)
  TARGET_LINK_LIBRARIES(OscUnitTests oscpack ${LIBS})

  ADD_EXECUTABLE(OscSendTests tests/OscSendTests.cpp)
  TARGET_LINK_LIBRARIES(OscSendTests oscpack ${LIBS})

  ADD_EXECUTABLE(OscReceiveTest tests/OscReceiveTest.cpp)
  TARGET_LINK_LIBRARIES(OscReceiveTest oscpack ${LIBS})

  ADD_EXECUTABLE(OscDump examples/OscDump.cpp)
  TARGET_LINK_LIBRARIES(OscDump oscpack ${LIBS})

  ADD_EXECUTABLE(SimpleReceive examples/SimpleReceive.cpp)
  TARGET_LINK_LIBRARIES(SimpleReceive oscpack ${LIBS})

  ADD_EXECUTABLE(SimpleSend examples/SimpleSend.cpp)
  TARGET_LINK_LIBRARIES(SimpleSend oscpack ${LIBS})
ENDIF(NOT OSC_LIB_ONLY)

if(MSVC)
    set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS TRUE)
  # Force to always compile with W4
  if(CMAKE_CXX_FLAGS MATCHES "/W[0-4]")
    string(REGEX REPLACE "/W[0-4]" "/W4" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
  else()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4")
  endif()
elseif(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX)
  # Update if necessary
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wno-long-long -pedantic")
endif()
