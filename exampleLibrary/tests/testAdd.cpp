#define CATCH_CONFIG_MAIN
#include <catch2/catch.hpp>

#include <examplePrefix/exampleLibrary/add.h>

TEST_CASE( "Add" )
{
    CHECK( 3 == Add( 1, 2 ) );
}
