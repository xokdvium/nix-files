cmake_minimum_required(VERSION 3.23)
# [FIXME]: Update project name
project(cxx_project_template)

option(INSOURCEBUILD OFF) # Prevent in-source style builds
if((${PROJECT_SOURCE_DIR} STREQUAL ${PROJECT_BINARY_DIR}) AND NOT
                                                              ${INSOURCEBUILD})
  message(
    FATAL_ERROR
      "In-source building disabled. Provide -DINSOURCEBUILD option if you are sure about it."
  )
endif()

option(SANITIZE OFF)
if(${SANITIZE})
  add_compile_options(-fsanitize=undefined,address -fno-omit-frame-pointer)
  add_link_options(-fsanitize=undefined,address -fno-omit-frame-pointer)
endif()

option(THREAD_SANITIZE OFF)
if(${THREAD_SANITIZE})
  add_compile_options(-fsanitize=thread -fno-omit-frame-pointer)
  add_link_options(-fsanitize=thread -fno-omit-frame-pointer)
endif()

if(THREAD_SANITIZE AND SANITIZE)
  message(FATAL_ERROR "Thread and address sanitizer can't be used together")
endif()

include(cmake/functions.cmake)

function(add_example_executable TARGET_NAME SOURCE)
  add_executable(${TARGET_NAME} ${SOURCE})
  target_enable_linter(${TARGET_NAME})
  target_compile_features(${TARGET_NAME} PUBLIC cxx_std_20)
  enable_warnings(${TARGET_NAME})
endfunction()

add_example_executable(example examples/example.cc)

# [FIXME]: Update project name
option(CXX_PROJECT_TEMPLATE_BUILD_DOCS OFF)
if(CXX_PROJECT_TEMPLATE_BUILD_DOCS)
  find_package(Doxygen REQUIRED OPTIONAL_COMPONENTS mscgen dia)

  doxygen_add_docs(${CMAKE_PROJECT}_docs include ALL)
endif()
