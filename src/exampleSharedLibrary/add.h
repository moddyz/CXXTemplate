#pragma once

/// \file add.h
///
/// Addition operator.

#if defined( _WIN32 ) || defined( _WIN64 )
#if defined( exampleSharedLibrary_EXPORTS )
#define CXXTEMPLATE_API __declspec( dllexport )
#else
#define CXXTEMPLATE_API __declspec( dllimport )
#endif
#else
#define CXXTEMPLATE_API
#endif

/// Adds integers \p i_lhs and \p i_rhs and returns the result.
CXXTEMPLATE_API int Add( int i_lhs, int i_rhs );
