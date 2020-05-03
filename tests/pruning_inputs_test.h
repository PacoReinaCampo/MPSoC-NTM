//   OpenNN: Open Neural Networks Library
//   www.opennn.net
//
//   P R U N I N G   I N P U T S   T E S T   C L A S S   H E A D E R       
//
//   Artificial Intelligence Techniques SL
//   artelnics@artelnics.com                                           

#ifndef PRUNINGINPUTSTEST_H
#define PRUNINGINPUTSTEST_H

// Unit testing includes

#include "unit_testing.h"

using namespace OpenNN;


class PruningInputsTest : public UnitTesting
{

#define	STRING(x) #x
#define TOSTRING(x) STRING(x)
#define LOG __FILE__ ":" TOSTRING(__LINE__)"\n"

public:

   // CONSTRUCTOR

   explicit PruningInputsTest();


   

   virtual ~PruningInputsTest();


   

   // Constructor and destructor methods

   void test_constructor();
   void test_destructor();

   // Set methods

   void test_set_default();

   // Input selection methods

   void test_perform_inputs_selection();

   // Serialization methods

   void test_to_XML();

   void test_from_XML();

   // Unit testing methods

   void run_test_case();

};


#endif
