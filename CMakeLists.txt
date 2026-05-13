cmake_minimum_required(VERSION 3.16)

project(CryptAlgorithm VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON) # Перенеси сюда
set(CMAKE_AUTOUIC ON) # Полезно для будущего
set(CMAKE_AUTORCC ON) # Для ресурсов

set(CMAKE_CXX_STANDARD 17)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)

# Добавляем include директории вручную
include_directories(${Qt6Core_INCLUDE_DIRS})
include_directories(${Qt6Gui_INCLUDE_DIRS})
include_directories(${Qt6Qml_INCLUDE_DIRS})
include_directories(${Qt6Quick_INCLUDE_DIRS})

qt_standard_project_setup(REQUIRES 6.4)

qt_add_executable(appCryptAlgorithm
    main.cpp
    CipherLogic.cpp
    CipherLogic.h
)

qt_add_qml_module(appCryptAlgorithm
    URI CryptAlgorithm
    VERSION 1.0
    QML_FILES
        Main.qml
)

set_target_properties(appCryptAlgorithm PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appCryptAlgorithm
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Qml
    PRIVATE Qt6::Core
    PRIVATE Qt6::Gui
)

include(GNUInstallDirs)
install(TARGETS appCryptAlgorithm
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)


# Для Windows: иконка и тип приложения
if(WIN32)
    set_target_properties(appCryptAlgorithm PROPERTIES WIN32_EXECUTABLE TRUE)
endif()

# --- СЕКЦИЯ ДЕПЛОЯ И СБОРКИ DEB ПАКЕТА (LINUX) ---
if(UNIX AND NOT ANDROID)
    include(GNUInstallDirs)

    # Правила копирования бинарника и ресурсов при сборке пакета
    install(TARGETS appCryptAlgorithm
        BUNDLE DESTINATION .
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    )

    # Метаданные для Linux DEB менеджера пакетов
    set(CPACK_GENERATOR "DEB")
    set(CPACK_PACKAGE_NAME "CipherAlghorithm")
    set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
    set(CPACK_PACKAGE_CONTACT "hfhdvdffvv@gmail.com") # Замените на свою почту
    set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Cross-platform Qt6 Audio Visualizer Application")
    set(CPACK_PACKAGE_VENDOR "SouthKartman")
    set(CPACK_SECTION "utils")
    set(CPACK_PACKAGE_ARCHITECTURE "amd64")

    # Автоматический поиск и генерация системных зависимостей (glibc, libstdc++, X11 и т.д.)
    set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON)
    # //meow
    include(CPack)
endif()


