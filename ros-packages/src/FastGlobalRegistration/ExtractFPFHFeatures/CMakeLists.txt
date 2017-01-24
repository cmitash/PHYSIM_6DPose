cmake_minimum_required(VERSION 2.8.3)
project(ExtractFPFH)

find_package (PCL REQUIRED COMPONENTS io common visualization features) 

include_directories(
  ${PCL_INCLUDE_DIRS}
)

add_library(
			${PROJECT_NAME}_lib 
			${PROJECT_SOURCE_DIR}/src/ExtractFPFH.cpp)

target_link_libraries(${PROJECT_NAME}_lib 
                      ${PCL_LIBRARIES} )

add_executable(ExtractFPFH ${PROJECT_SOURCE_DIR}/src/ExtractFPFH.cpp)
target_link_libraries(ExtractFPFH ${PROJECT_NAME}_lib)