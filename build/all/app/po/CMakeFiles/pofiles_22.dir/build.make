# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.5

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/costales/Desktop/uwriter

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/costales/Desktop/uwriter/build/all/app

# Utility rule file for pofiles_22.

# Include the progress variables for this target.
include po/CMakeFiles/pofiles_22.dir/progress.make

po/CMakeFiles/pofiles_22: po/uk.gmo


po/uk.gmo: ../../../po/uk.po
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/home/costales/Desktop/uwriter/build/all/app/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Generating uk.gmo"
	cd /home/costales/Desktop/uwriter/po && /usr/bin/msgfmt -o /home/costales/Desktop/uwriter/build/all/app/po/uk.gmo /home/costales/Desktop/uwriter/po/uk.po

pofiles_22: po/CMakeFiles/pofiles_22
pofiles_22: po/uk.gmo
pofiles_22: po/CMakeFiles/pofiles_22.dir/build.make

.PHONY : pofiles_22

# Rule to build all files generated by this target.
po/CMakeFiles/pofiles_22.dir/build: pofiles_22

.PHONY : po/CMakeFiles/pofiles_22.dir/build

po/CMakeFiles/pofiles_22.dir/clean:
	cd /home/costales/Desktop/uwriter/build/all/app/po && $(CMAKE_COMMAND) -P CMakeFiles/pofiles_22.dir/cmake_clean.cmake
.PHONY : po/CMakeFiles/pofiles_22.dir/clean

po/CMakeFiles/pofiles_22.dir/depend:
	cd /home/costales/Desktop/uwriter/build/all/app && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/costales/Desktop/uwriter /home/costales/Desktop/uwriter/po /home/costales/Desktop/uwriter/build/all/app /home/costales/Desktop/uwriter/build/all/app/po /home/costales/Desktop/uwriter/build/all/app/po/CMakeFiles/pofiles_22.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : po/CMakeFiles/pofiles_22.dir/depend

