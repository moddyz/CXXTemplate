#pragma once

/// \file add.h
///
/// Addition operator.

#if defined( _WIN32 ) || defined( _WIN64 )
#define CXXTEMPLATE_EXPORT __declspec( dllexport )
#else
#define CXXTEMPLATE_EXPORT
#endif

/// Adds integers \p i_lhs and \p i_rhs and returns the result.
CXXTEMPLATE_EXPORT
int Add( int i_lhs, int i_rhs );
