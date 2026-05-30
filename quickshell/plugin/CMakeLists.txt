cmake_minimum_required(VERSION 3.19)
project(c1ph3r-blobs LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(Qt6 REQUIRED COMPONENTS Core Qml Quick ShaderTools)
qt_standard_project_setup(REQUIRES 6.6)

qt_add_qml_module(c1ph3r-blobs
    URI C1ph3r.Blobs
    VERSION 1.0
    SOURCES
        blobgroup.cpp blobgroup.hpp
        blobshape.cpp blobshape.hpp
        blobrect.cpp  blobrect.hpp
        blobinvertedrect.cpp blobinvertedrect.hpp
        blobmaterial.cpp blobmaterial.hpp
)

qt_add_shaders(c1ph3r-blobs "blob_shaders"
    BATCHABLE OPTIMIZED NOHLSL NOMSL
    GLSL "300es,330"
    PREFIX "/"
    FILES
        shaders/blob.frag
        shaders/blob.vert
)

target_link_libraries(c1ph3r-blobs PRIVATE Qt6::Core Qt6::Qml Qt6::Quick)

qt_query_qml_module(c1ph3r-blobs
    TARGET_PATH   module_target_path
    PLUGIN_TARGET plugin_target
    QMLDIR        qmldir_path
    TYPEINFO      typeinfo_path
)

set(QML_INSTALL_DIR "lib/qt6/qml/${module_target_path}")

install(TARGETS c1ph3r-blobs ${plugin_target}
    LIBRARY DESTINATION "${QML_INSTALL_DIR}"
    RUNTIME DESTINATION "${QML_INSTALL_DIR}"
)
install(FILES "${qmldir_path}" "${typeinfo_path}"
    DESTINATION "${QML_INSTALL_DIR}"
)
