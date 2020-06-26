# CMakeTemplate {#mainpage}

\section CMakeTemplate Introduction

\b CMakeTemplate is a GitHub template project used to serve as a basic starting point for C++ based projects.

\section Example Usage

To use this template: 
-# Create a new repository based with \b CMakeTemplate as the selected template project>
-# Replace occurances of "CMakeTemplate" with your project name.

\section CMakeTemplate_Building Building

A convenience build script is provided at the root of the repository for building all targets, and optionally installing to a location: 
\code
./build.sh <OPTIONAL_INSTALL_LOCATION>`
\endcode

\subsection CMakeTemplate_Building_Documentation Building Documentation

To build documentation for CMakeTemplate, set the cmake option `BUILD_DOCUMENTATION="ON"` when configuring cmake.

\section CMakeTemplate_DeveloperNotes Developer Notes

\subsection CMakeTemplate_DeveloperNotes_SourceTree Source Tree

The CMake functions and macros are organized under \p cmake/macros.

Examples libraries and programs built using the fore-mentioned functions & macros are organized under \p src/.

\subsection CMakeTemplate_DeveloperNotes_Motivation Motivation

It takes time and energy to set up a C++ project, even with the conveniences of CMake.  

Abstracting away some of the build details will help with shifting more of that focus to writing code for the library or application.

\section CMakeTemplate_GitHubHosted GitHub Repository

The CMakeTemplate project is hosted on GitHub: https://github.com/moddyz/CMakeTemplate.
